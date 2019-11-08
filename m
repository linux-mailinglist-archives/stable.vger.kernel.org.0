Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E445CF4BDC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfKHMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfKHMhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:03 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAEBA222C9;
        Fri,  8 Nov 2019 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216622;
        bh=5sUlAvPVEquXe3byxGhXB++28iVn9vJkmQM5rwjvzM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv1EJ1p8HqjFB1oVg4HArXnQoxSzI+7xtHejdPTuQ2j3YKUKtjuUiQuvEyI5yuAsf
         ZRg+T+WDahQUqx0bQ5nl1uYHIfcfVe1Y8VB3M5sN1NAHxe4MV2lpw56zmhchcFqCvI
         oJasCrzsWx+6ZvXonF2skW6wSVjAdWT5PMR6w3B8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 32/50] ARM: oabi-compat: copy semops using __copy_from_user()
Date:   Fri,  8 Nov 2019 13:35:36 +0100
Message-Id: <20191108123554.29004-33-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
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
---
 arch/arm/kernel/sys_oabi-compat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 5f221acd21ae..640748e27035 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -328,9 +328,11 @@ asmlinkage long sys_oabi_semtimedop(int semid,
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
-- 
2.20.1

