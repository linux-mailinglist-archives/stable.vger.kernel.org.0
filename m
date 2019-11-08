Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C1EF54CA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfKHSyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbfKHSyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624AE2178F;
        Fri,  8 Nov 2019 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239260;
        bh=eGIRXN3ZuubHvJtJ1VY8AcPqPsHFDvRiJESLjbShVhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSxad0fv3lCEXT5FLrJq705XbRMkmwkOuQGs6o30f/ozyDctJAkQnvurzJ147legF
         D17DIQkan+2klEI0K6Zj7e5GePwUbAC0S1eO9bN8XcPVN9cXUc+Ra+0MG7pWCswo5E
         7joJQcVjrynx2wIzFrbL8dut0u0uT8RqJypUeiZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 55/75] ARM: oabi-compat: copy semops using __copy_from_user()
Date:   Fri,  8 Nov 2019 19:50:12 +0100
Message-Id: <20191108174757.494478119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 8c8484a1c18e3231648f5ba7cc5ffb7fd70b3ca4 upstream.

__get_user_error() is used as a fast accessor to make copying structure
members as efficient as possible.  However, with software PAN and the
recent Spectre variant 1, the efficiency is reduced as these are no
longer fast accessors.

In the case of software PAN, it has to switch the domain register around
each access, and with Spectre variant 1, it would have to repeat the
access_ok() check for each access.

Rather than using __get_user_error() to copy each semops element member,
copy each semops element in full using __copy_from_user().

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/sys_oabi-compat.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -328,9 +328,11 @@ asmlinkage long sys_oabi_semtimedop(int
 		return -ENOMEM;
 	err = 0;
 	for (i = 0; i < nsops; i++) {
-		__get_user_error(sops[i].sem_num, &tsops->sem_num, err);
-		__get_user_error(sops[i].sem_op,  &tsops->sem_op,  err);
-		__get_user_error(sops[i].sem_flg, &tsops->sem_flg, err);
+		struct oabi_sembuf osb;
+		err |= __copy_from_user(&osb, tsops, sizeof(osb));
+		sops[i].sem_num = osb.sem_num;
+		sops[i].sem_op = osb.sem_op;
+		sops[i].sem_flg = osb.sem_flg;
 		tsops++;
 	}
 	if (timeout) {


