Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67314B1E48
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfIMNIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbfIMNIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:08:50 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72822206BB;
        Fri, 13 Sep 2019 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380130;
        bh=qarEm0hUiGkoxrVW/LNQVYyGT6o/jny66w5VK6Nzozk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLAofI58pYZsJ+/pTR5knkGNc53GDAvTrxZ5Kt7pR/93L5OuXOBo/xioYiqb3Xi+c
         gCMWoG/1y6yrLjpDMC9SQfPDHAKyY/BCCqkvOHxdERHiCx8NvpYoaViIgLCAyABDtS
         iMpE6aLefmSgVCFJgEHe07MO+yeqsLrehy0c1WxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 5/9] scripts/decode_stacktrace: match basepath using shell prefix operator, not regex
Date:   Fri, 13 Sep 2019 14:06:55 +0100
Message-Id: <20190913130429.429077844@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
References: <20190913130424.160808669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 31013836a71e07751a6827f9d2ad41ef502ddaff ]

The basepath may contain special characters, which would confuse the regex
matcher.  ${var#prefix} does the right thing.

Link: http://lkml.kernel.org/r/20190518055946.181563-1-drinkcat@chromium.org
Fixes: 67a28de47faa8358 ("scripts/decode_stacktrace: only strip base path when a prefix of the path")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index ffc46c7c3afbb..4f5e76f76b9dc 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -64,7 +64,7 @@ parse_symbol() {
 	fi
 
 	# Strip out the base of the path
-	code=${code//^$basepath/""}
+	code=${code#$basepath/}
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
-- 
2.20.1



