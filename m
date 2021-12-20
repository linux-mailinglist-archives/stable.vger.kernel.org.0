Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FC047AE2D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhLTO6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47368 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238820AbhLTO4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66271611A5;
        Mon, 20 Dec 2021 14:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA6BC36AE7;
        Mon, 20 Dec 2021 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012203;
        bh=fUYtSx8KmCiJ5XRQoWxn1Yx888lD/HSjuimQMi9xwkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np4tDuDSbt0VSOmjhZVHobC03p24ONVSq6miMJDYd7EBbp/ETKy7aKviKJPX1EL1B
         BZVP+JH0TwJnfaMS9aR2+pu9ed4SG86RclU9iiflEblA9MmWx0Uo2VmWlSd4DKaJWO
         glE7rvf44aJb7xPUyfjFkLHzUyDdgiid0/ji3Kd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 5.15 118/177] usb: dwc2: fix STM ID/VBUS detection startup delay in dwc2_driver_probe
Date:   Mon, 20 Dec 2021 15:34:28 +0100
Message-Id: <20211220143044.051858683@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit fac6bf87c55f7f0733efb0375565fb6a50cf2caf upstream.

When activate_stm_id_vb_detection is enabled, ID and Vbus detection relies
on sensing comparators. This detection needs time to stabilize.
A delay was already applied in dwc2_resume() when reactivating the
detection, but it wasn't done in dwc2_probe().
This patch adds delay after enabling STM ID/VBUS detection. Then, ID state
is good when initializing gadget and host, and avoid to get a wrong
Connector ID Status Change interrupt.

Fixes: a415083a11cc ("usb: dwc2: add support for STM32MP15 SoCs USB OTG HS and FS")
Cc: stable <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211207124510.268841-1-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/platform.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -575,6 +575,9 @@ static int dwc2_driver_probe(struct plat
 		ggpio |= GGPIO_STM32_OTG_GCCFG_IDEN;
 		ggpio |= GGPIO_STM32_OTG_GCCFG_VBDEN;
 		dwc2_writel(hsotg, ggpio, GGPIO);
+
+		/* ID/VBUS detection startup time */
+		usleep_range(5000, 7000);
 	}
 
 	retval = dwc2_drd_init(hsotg);


