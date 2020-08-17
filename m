Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6287D24765D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgHQP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbgHQP2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C239238E1;
        Mon, 17 Aug 2020 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678100;
        bh=A4X9IdiTBJ1xoQQLa2m88VESOr4Le8PIWGChoLy6KN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwlQ/t4he0nf/ApavPMDQE8Uqv1tkKPXa9GwiI2ybUtkxiaQZ8+1wiFqQCXpB4Uyk
         l32KvNpaC+TiSioxYHuzR8uiq87eFr+cxyH8DdV1VfAPoYzR4TFJIowM88fpClyvgJ
         8APUQbixcpUNbzv2fRScivyFzfQsmt0Jqt3mmUso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 188/464] selftests/lkdtm: Reset WARN_ONCE to avoid false negatives
Date:   Mon, 17 Aug 2020 17:12:21 +0200
Message-Id: <20200817143842.827845237@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4fccc8c0ff740e62343b6de38426a48b345b95f4 ]

Since we expect to see warnings every time for many tests, just reset
the WARN_ONCE flags each time the script runs.

Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200625203704.317097-4-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lkdtm/run.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
index ee64ff8df8f4d..8383eb89d88a9 100755
--- a/tools/testing/selftests/lkdtm/run.sh
+++ b/tools/testing/selftests/lkdtm/run.sh
@@ -8,6 +8,7 @@
 #
 set -e
 TRIGGER=/sys/kernel/debug/provoke-crash/DIRECT
+CLEAR_ONCE=/sys/kernel/debug/clear_warn_once
 KSELFTEST_SKIP_TEST=4
 
 # Verify we have LKDTM available in the kernel.
@@ -67,6 +68,11 @@ cleanup() {
 }
 trap cleanup EXIT
 
+# Reset WARN_ONCE counters so we trip it each time this runs.
+if [ -w $CLEAR_ONCE ] ; then
+	echo 1 > $CLEAR_ONCE
+fi
+
 # Save existing dmesg so we can detect new content below
 dmesg > "$DMESG"
 
-- 
2.25.1



