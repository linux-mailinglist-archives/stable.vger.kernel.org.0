Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97233F5640
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhHXDAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 23:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234634AbhHXC7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36414613DB;
        Tue, 24 Aug 2021 02:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773944;
        bh=akNljmYAqpUMZJ8WHvhlsM/Hp3zTlWeCIqfNRJNdbWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Uf2xE78W2VQZtpYXM6/6OwNUsdhfGGP5+nXqhV4aFqz+FRQ2M12nmK7Xi7mV7kZs9
         o3YSOVS8irf+i8x2k1peyB/WXxWQ/ZiIC1AAfK945XKI8tvVbFulN+Yg3osogzgTh9
         X4hHApaAzFu+DRKXL/xgh2ydo1ziawLLBCLVSD9saq1uytx/Xi55tJQmYjEr7w8N0i
         Ds/r7+Z+hfNIiOwXuFZHAx0fd7aTkPGs1YXaI0ad/ZY96Vw/hpLwfTw7XYNrsLGyt1
         8KkGCkRmDcBHQXSOGUZlB1FFz+lGg6RyLN0XD7cFb+7ZDD/rKHxkDEGU/zMoDtnT9v
         /Qo1uBuk7tbkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, jlayton@kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "fs: warn about impending deprecation of mandatory locks" failed to apply to 4.4-stable tree
Date:   Mon, 23 Aug 2021 22:59:02 -0400
Message-Id: <20210824025903.660376-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From fdd92b64d15bc4aec973caa25899afd782402e68 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 20 Aug 2021 09:29:50 -0400
Subject: [PATCH] fs: warn about impending deprecation of mandatory locks

We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
have disabled it. Warn the stragglers that still use "-o mand" that
we'll be dropping support for that mount option.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ab4174a3c802..2279473d0d6f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1716,8 +1716,12 @@ static inline bool may_mount(void)
 }
 
 #ifdef	CONFIG_MANDATORY_FILE_LOCKING
-static inline bool may_mandlock(void)
+static bool may_mandlock(void)
 {
+	pr_warn_once("======================================================\n"
+		     "WARNING: the mand mount option is being deprecated and\n"
+		     "         will be removed in v5.15!\n"
+		     "======================================================\n");
 	return capable(CAP_SYS_ADMIN);
 }
 #else
-- 
2.30.2




