Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14E01ECF9
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfEOLDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfEOLDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3645C2084F;
        Wed, 15 May 2019 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918226;
        bh=4wTWFXDjryCe5iFXbF2nI5BOQ8SlDGdkom76bwAV1Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQhYdomCZybn3vb4hNeatzwL2XRPcKgL1bXw9NjylvJ7lqIqczrLjOBzvQSUFBEUY
         R+fp2M5s3NA6xiGVvGSXIlnLqN1T2AsfMBSzjQs3hWscx4Z+PKvpO0Q4I5HNFeqNu1
         /ipbwqfNPYZK1W5NIevjRPog72vGSvB07Iney3bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 026/266] powerpc/64s: Move cpu_show_meltdown()
Date:   Wed, 15 May 2019 12:52:13 +0200
Message-Id: <20190515090723.454615121@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8ad33041563a10b34988800c682ada14b2612533 upstream.

This landed in setup_64.c for no good reason other than we had nowhere
else to put it. Now that we have a security-related file, that is a
better place for it so move it.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |   11 +++++++++++
 arch/powerpc/kernel/setup_64.c |    8 --------
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -5,6 +5,8 @@
 // Copyright 2018, Michael Ellerman, IBM Corporation.
 
 #include <linux/kernel.h>
+#include <linux/device.h>
+
 #include <asm/security_features.h>
 
 
@@ -13,3 +15,12 @@ unsigned long powerpc_security_features
 	SEC_FTR_L1D_FLUSH_PR | \
 	SEC_FTR_BNDS_CHK_SPEC_BAR | \
 	SEC_FTR_FAVOUR_SECURITY;
+
+
+ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	if (rfi_flush)
+		return sprintf(buf, "Mitigation: RFI Flush\n");
+
+	return sprintf(buf, "Vulnerable\n");
+}
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -961,12 +961,4 @@ static __init int rfi_flush_debugfs_init
 }
 device_initcall(rfi_flush_debugfs_init);
 #endif
-
-ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	if (rfi_flush)
-		return sprintf(buf, "Mitigation: RFI Flush\n");
-
-	return sprintf(buf, "Vulnerable\n");
-}
 #endif /* CONFIG_PPC_BOOK3S_64 */


