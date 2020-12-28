Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617682E40CC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440658AbgL1OPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440678AbgL1OPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE2B207B2;
        Mon, 28 Dec 2020 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164890;
        bh=ru7VfCUzhDwXPSmUE9w67o+EJFfnR3QxtyIwwT1hSDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VJrPquQ1MMmTgYbpmqbNylFku/8hnt/s/zvGsCcWe9H1wZerFfjirkhqHyhexBFH
         Flsj+v2uxpk2cis0tAu5V4Kp2yzOMj1Lc9iO0J1xs8IiohxXdVXgSaOEcPsdCiMrOD
         2yCwz/1T5qmk7T1AEy5DoUVp2+vvqXAFzxjlZMG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/717] staging: bcm2835: fix vchiq_mmal dependencies
Date:   Mon, 28 Dec 2020 13:45:33 +0100
Message-Id: <20201228125037.070890072@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6c91799f59ed491a2b5bf5ef7c6d60306cda4e09 ]

When the MMAL code is built-in but the vchiq core config is
set to =m, the mmal code never gets built, which in turn can
lead to link errors:

ERROR: modpost: "vchiq_mmal_port_set_format" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_port_disable" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_port_parameter_set" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_component_finalise" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_port_connect_tunnel" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_component_enable" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_finalise" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_component_init" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_component_disable" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "mmal_vchi_buffer_init" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_port_enable" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_version" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_submit_buffer" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_init" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "mmal_vchi_buffer_cleanup" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!
ERROR: modpost: "vchiq_mmal_port_parameter_get" [drivers/staging/vc04_services/bcm2835-camera/bcm2835-v4l2.ko] undefined!

Change the Kconfig to depend on BCM2835_VCHIQ like the other drivers,
and remove the now redundant dependencies.

Fixes: b18ee53ad297 ("staging: bcm2835: Break MMAL support out from camera")
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201203223836.1362313-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/vchiq-mmal/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/vchiq-mmal/Kconfig b/drivers/staging/vc04_services/vchiq-mmal/Kconfig
index 500c0d12e4ff2..c99525a0bb452 100644
--- a/drivers/staging/vc04_services/vchiq-mmal/Kconfig
+++ b/drivers/staging/vc04_services/vchiq-mmal/Kconfig
@@ -1,6 +1,6 @@
 config BCM2835_VCHIQ_MMAL
 	tristate "BCM2835 MMAL VCHIQ service"
-	depends on (ARCH_BCM2835 || COMPILE_TEST)
+	depends on BCM2835_VCHIQ
 	help
 	  Enables the MMAL API over VCHIQ interface as used for the
 	  majority of the multimedia services on VideoCore.
-- 
2.27.0



