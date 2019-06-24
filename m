Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7222D5078C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbfFXKHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbfFXKHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:54 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F9F205C9;
        Mon, 24 Jun 2019 10:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370873;
        bh=Cv7B6S4b4ErBNH00xyoVxNtkOjnOPMKuWbetOglwOgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3zX8TcT3U12bhEfkAjBShbzj4uDOeLCe0uTEMxrhPsOJ9gfDsWd/ajsrG7yuRTv/
         P2JVXDLj0fi/9dqJjJ3lCQ04cg4pauBqcZK9mSps7OysP2fgWqCeAgCRku8RS4XQc3
         z07Kl6BxuNfelZodfb4THFyYqcKhKiX4YYSHNRGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 031/121] lkdtm/usercopy: Moves the KERNEL_DS test to non-canonical
Date:   Mon, 24 Jun 2019 17:56:03 +0800
Message-Id: <20190624092322.416427054@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2bf8496f6e9b7e9a557f65eb95eab16fea7958c7 ]

The prior implementation of the KERNEL_DS fault checking would work on
any unmapped kernel address, but this was narrowed to the non-canonical
range instead. This adjusts the LKDTM test to match.

Fixes: 00c42373d397 ("x86-64: add warning for non-canonical user access address dereferences")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/usercopy.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index d5a0e7f1813b..e172719dd86d 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -324,14 +324,16 @@ free_user:
 
 void lkdtm_USERCOPY_KERNEL_DS(void)
 {
-	char __user *user_ptr = (char __user *)ERR_PTR(-EINVAL);
+	char __user *user_ptr =
+		(char __user *)(0xFUL << (sizeof(unsigned long) * 8 - 4));
 	mm_segment_t old_fs = get_fs();
 	char buf[10] = {0};
 
-	pr_info("attempting copy_to_user on unmapped kernel address\n");
+	pr_info("attempting copy_to_user() to noncanonical address: %px\n",
+		user_ptr);
 	set_fs(KERNEL_DS);
-	if (copy_to_user(user_ptr, buf, sizeof(buf)))
-		pr_info("copy_to_user un unmapped kernel address failed\n");
+	if (copy_to_user(user_ptr, buf, sizeof(buf)) == 0)
+		pr_err("copy_to_user() to noncanonical address succeeded!?\n");
 	set_fs(old_fs);
 }
 
-- 
2.20.1



