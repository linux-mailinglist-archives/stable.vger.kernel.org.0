Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041652F7BC4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbhAONF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732660AbhAOMbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DAB235F9;
        Fri, 15 Jan 2021 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713868;
        bh=eLxc/JivcVOfxYy1bCgsF9Ag5XJf1/dejhZPv7KCAeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFsXr/BTZdKIzNkGjOymAUWg9/8gaXwGNkqB1tjyN2uC5sU7RgR6i9zHe938uNrMc
         tzZ3n6N/cYt/Jqot8Pyio54qMlVr/mN4655TveL5h6RGxtjizl4uHBPcbCvC1ZmIAg
         +vPXu4+5jNzJDeGGQqhjWlBVK00pqCFu/wCgHbrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 14/28] ARM: OMAP2+: omap_device: fix idling of devices during probe
Date:   Fri, 15 Jan 2021 13:27:51 +0100
Message-Id: <20210115121957.466324353@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

commit ec76c2eea903947202098090bbe07a739b5246e9 upstream.

On the GTA04A5 od->_driver_status was not set to BUS_NOTIFY_BIND_DRIVER
during probe of the second mmc used for wifi. Therefore
omap_device_late_idle idled the device during probing causing oopses when
accessing the registers.

It was not set because od->_state was set to OMAP_DEVICE_STATE_IDLE
in the notifier callback. Therefore set od->_driver_status also in that
case.

This came apparent after commit 21b2cec61c04 ("mmc: Set
PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.4") causing this
oops:

omap_hsmmc 480b4000.mmc: omap_device_late_idle: enabled but no driver.  Idling
8<--- cut here ---
Unhandled fault: external abort on non-linefetch (0x1028) at 0xfa0b402c
...
(omap_hsmmc_set_bus_width) from [<c07996bc>] (omap_hsmmc_set_ios+0x11c/0x258)
(omap_hsmmc_set_ios) from [<c077b2b0>] (mmc_power_up.part.8+0x3c/0xd0)
(mmc_power_up.part.8) from [<c077c14c>] (mmc_start_host+0x88/0x9c)
(mmc_start_host) from [<c077d284>] (mmc_add_host+0x58/0x84)
(mmc_add_host) from [<c0799190>] (omap_hsmmc_probe+0x5fc/0x8c0)
(omap_hsmmc_probe) from [<c0666728>] (platform_drv_probe+0x48/0x98)
(platform_drv_probe) from [<c066457c>] (really_probe+0x1dc/0x3b4)

Fixes: 04abaf07f6d5 ("ARM: OMAP2+: omap_device: Sync omap_device and pm_runtime after probe defer")
Fixes: 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.4")
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
[tony@atomide.com: left out extra parens, trimmed description stack trace]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_device.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -224,10 +224,12 @@ static int _omap_device_notifier_call(st
 		break;
 	case BUS_NOTIFY_BIND_DRIVER:
 		od = to_omap_device(pdev);
-		if (od && (od->_state == OMAP_DEVICE_STATE_ENABLED) &&
-		    pm_runtime_status_suspended(dev)) {
+		if (od) {
 			od->_driver_status = BUS_NOTIFY_BIND_DRIVER;
-			pm_runtime_set_active(dev);
+			if (od->_state == OMAP_DEVICE_STATE_ENABLED &&
+			    pm_runtime_status_suspended(dev)) {
+				pm_runtime_set_active(dev);
+			}
 		}
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:


