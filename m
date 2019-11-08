Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA3F4BEB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKHMhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfKHMhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:21 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4642248C;
        Fri,  8 Nov 2019 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216640;
        bh=97pYGULCAD/3xuYZMgC9g2UXEdK175xz0efDfkqBNXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yA5fYwq6adlX7LBQ/xFHdQw4ljZoJhQUwKITIXGnkwb2980uiSENICiXsrcGuhVr7
         K561Wibc9mk0gEVOjpPb5M0VlYngjGcCwJ1+HbwlpMMLyr+XchtoCpwplVfOdBPa4b
         0X+mi1HoIWtTnxlS3oJ0XUqMQ/+OmX7ZLFnMNZXI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Julien Thierry <julien.thierry@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 43/50] ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc
Date:   Fri,  8 Nov 2019 13:35:47 +0100
Message-Id: <20191108123554.29004-44-ardb@kernel.org>
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

Commit 5df7a99bdd0de4a0480320264c44c04543c29d5a upstream.

In vfp_preserve_user_clear_hwstate, ufp_exc->fpinst2 gets assigned to
itself. It should actually be hwstate->fpinst2 that gets assigned to the
ufp_exc field.

Fixes commit 3aa2df6ec2ca6bc143a65351cca4266d03a8bc41 ("ARM: 8791/1:
vfp: use __copy_to_user() when saving VFP state").

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/vfp/vfpmodule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index f07567eedd82..f9392fb060ea 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -583,7 +583,7 @@ int vfp_preserve_user_clear_hwstate(struct user_vfp *ufp,
 	 */
 	ufp_exc->fpexc = hwstate->fpexc;
 	ufp_exc->fpinst = hwstate->fpinst;
-	ufp_exc->fpinst2 = ufp_exc->fpinst2;
+	ufp_exc->fpinst2 = hwstate->fpinst2;
 
 	/* Ensure that VFP is disabled. */
 	vfp_flush_hwstate(thread);
-- 
2.20.1

