Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16370B5D53
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfIRGdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbfIRGUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B92F21927;
        Wed, 18 Sep 2019 06:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787648;
        bh=31PfhR496BnP9+5tJnRpJLobrLzoiQuv95VPwes3B00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORybFhC+czHzaL6/5ZDZqGB1v8aG7bikJRSysrx+gJnH2p+k0k3IyetkGk0hrq/yb
         62y8B22rIibyT7SOGl+fDBlj907s18A0DzKrmrwm3mVWzs01yd/Lo/f7KPOw6MtoK/
         /3bW8CbECzO4FcTueveChQdQFWsUJg0yVA2NWDL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 27/45] powerpc: Add barrier_nospec to raw_copy_in_user()
Date:   Wed, 18 Sep 2019 08:19:05 +0200
Message-Id: <20190918061225.904794189@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit 6fbcdd59094ade30db63f32316e9502425d7b256 upstream.

Commit ddf35cf3764b ("powerpc: Use barrier_nospec in copy_from_user()")
Added barrier_nospec before loading from user-controlled pointers. The
intention was to order the load from the potentially user-controlled
pointer vs a previous branch based on an access_ok() check or similar.

In order to achieve the same result, add a barrier_nospec to the
raw_copy_in_user() function before loading from such a user-controlled
pointer.

Fixes: ddf35cf3764b ("powerpc: Use barrier_nospec in copy_from_user()")
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/uaccess.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -280,6 +280,7 @@ extern unsigned long __copy_tofrom_user(
 static inline unsigned long
 raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
+	barrier_nospec();
 	return __copy_tofrom_user(to, from, n);
 }
 #endif /* __powerpc64__ */


