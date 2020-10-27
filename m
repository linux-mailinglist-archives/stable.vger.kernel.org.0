Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5F529B911
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802181AbgJ0Ppz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798591AbgJ0P26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A782F206E9;
        Tue, 27 Oct 2020 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812538;
        bh=mgRVCVMtf2z99kFJGVdKlFtCoTxg6B7DmfxDCorpz6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjfnBlu5NXiv4n4MFcPKAk1NrK0moJZ26c+cayGX60pRT0LA7HPHgZ43LXJsOKJRs
         cbOLlIgU/pHcqa3sjX8fa3m3omLQxlr0KzJWDSb+W8j2TmWTW8JronUWueBuXHY9mP
         Qk5EZDnaOTsKtS01PzuS8SjwoTDgPy9RuMkdhEtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 213/757] selftests/livepatch: Do not check order when using "comm" for dmesg checking
Date:   Tue, 27 Oct 2020 14:47:43 +0100
Message-Id: <20201027135500.608878968@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

[ Upstream commit 884ee754f5aedbe54406a4d308a6cc57335747ce ]

check_result() uses "comm" to check expected results of selftests output
in dmesg. Everything works fine if timestamps in dmesg are unique. If
not, like in this example

[   86.844422] test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_LIVE] Normal state
[   86.844422] livepatch: 'test_klp_callbacks_demo': starting unpatching transition

, "comm" fails with "comm: file 2 is not in sorted order". Suppress the
order checking with --nocheck-order option.

Fixes: 2f3f651f3756 ("selftests/livepatch: Use "comm" instead of "diff" for dmesg")
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/livepatch/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 1aba83c87ad32..846c7ed71556f 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -278,7 +278,7 @@ function check_result {
 	# help differentiate repeated testing runs.  Remove them with a
 	# post-comparison sed filter.
 
-	result=$(dmesg | comm -13 "$SAVED_DMESG" - | \
+	result=$(dmesg | comm --nocheck-order -13 "$SAVED_DMESG" - | \
 		 grep -e 'livepatch:' -e 'test_klp' | \
 		 grep -v '\(tainting\|taints\) kernel' | \
 		 sed 's/^\[[ 0-9.]*\] //')
-- 
2.25.1



