Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80995A1746
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfH2Kuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728046AbfH2Kuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126812341C;
        Thu, 29 Aug 2019 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075831;
        bh=ArHiVFqSrRYIIOQuOR5tVWl00xvZYHqTB2s/aommuZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiqTUxaTtzkjnJoVgjfBB7Trqitr9aL3dirWy/MCRSVVW3RI+T6MQj5lpVmWlymPA
         fJne+ArzX5o93Bg+CeJ6cy/XHlEh7FQ09wQ2+VZE2i5sOQ5mf3mab6C8fWpdDk9Y3c
         85EhutoTa3TqWHIy0DGxGmXPyLMTPtCH/K49XV48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 19/29] scripts/decode_stacktrace: match basepath using shell prefix operator, not regex
Date:   Thu, 29 Aug 2019 06:49:59 -0400
Message-Id: <20190829105009.2265-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
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
index c4a9ddb174bc5..5aa75a0a1cede 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -78,7 +78,7 @@ parse_symbol() {
 	fi
 
 	# Strip out the base of the path
-	code=${code//^$basepath/""}
+	code=${code#$basepath/}
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
-- 
2.20.1

