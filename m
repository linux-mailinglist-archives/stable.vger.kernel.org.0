Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681BDF4BE6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHMhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfKHMhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:13 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC9B224D3;
        Fri,  8 Nov 2019 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216632;
        bh=gRdun5q5XOK+Ts7w8sB/Z1w+m9s6+mqnzWaFuQ24LAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1SWn0yqi9KqVYmB4CLnD9S4zWIjAWPhbliDvLQUIKoR13VbU1yOLtn1AIqR0r/JU
         IYku5vkDBo8mMAYiV1fhkzJAzJU8E+VEXNb9rdShgOIvkZyTxBsKx/x7hZ1S9FI7/0
         tswTl7LCkokZbAh/FyHt7fTu3r7m25RbApkwBe80=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Julien Thierry <julien.thierry@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 38/50] ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()
Date:   Fri,  8 Nov 2019 13:35:42 +0100
Message-Id: <20191108123554.29004-39-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 319508902600c2688e057750148487996396e9ca upstream.

Copy events to user using __copy_to_user() rather than copy members of
individually with __put_user_error().
This has the benefit of disabling/enabling PAN once per event intead of
once per event member.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/sys_oabi-compat.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 640748e27035..d844c5c9364b 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -276,6 +276,7 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 				    int maxevents, int timeout)
 {
 	struct epoll_event *kbuf;
+	struct oabi_epoll_event e;
 	mm_segment_t fs;
 	long ret, err, i;
 
@@ -294,8 +295,11 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 	set_fs(fs);
 	err = 0;
 	for (i = 0; i < ret; i++) {
-		__put_user_error(kbuf[i].events, &events->events, err);
-		__put_user_error(kbuf[i].data,   &events->data,   err);
+		e.events = kbuf[i].events;
+		e.data = kbuf[i].data;
+		err = __copy_to_user(events, &e, sizeof(e));
+		if (err)
+			break;
 		events++;
 	}
 	kfree(kbuf);
-- 
2.20.1

