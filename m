Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D515A16F4
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfH2KwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfH2KvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A8323405;
        Thu, 29 Aug 2019 10:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075876;
        bh=xoxk9jxkuoOZfhocIiS0de+uIj2KTFu3DX/VP0RtgBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3OoZLel88WVmEfiqRKSbY/RmZYPSWeyjk62ZZdbnzK84bpyZvfDRxWE27JyhuOLA
         dpH+d6gZ8yUUhNcMkw2IHbrIWLaZq9Ma/Gnw7z2ycY3AbL/Qi3mA0eElYikNhPOO2c
         2hq0yAma89xBmSS+J7yFOZ/Ex3tXeEQ11Ye4v02I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 4/6] scripts/decode_stacktrace: match basepath using shell prefix operator, not regex
Date:   Thu, 29 Aug 2019 06:51:08 -0400
Message-Id: <20190829105110.2748-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105110.2748-1-sashal@kernel.org>
References: <20190829105110.2748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

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

