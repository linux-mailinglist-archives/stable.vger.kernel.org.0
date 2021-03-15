Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F4533B75E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhCOOAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhCON7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD0664F0D;
        Mon, 15 Mar 2021 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816737;
        bh=CItlQUAyUgrNxFHqww8cOQnFk16YPb2U7KaeooOTORE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4A7waRfe6yxeA7aCDenrhl0KUsMZ1k9l9FuFkMqVdOYp3xdP0eR0EIx08Oaof2c2
         j7EMaYmTyIRP/2cBNJGH0Da9HgnkXXWXd+RYCHYYzU0dARtoWMF/o7539+OdxKmkjB
         TpKt0FPuQFJr9HoaN8DdOJ83y2xHuxUwE7x9ZTEE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 4.14 28/95] drm: meson_drv add shutdown function
Date:   Mon, 15 Mar 2021 14:56:58 +0100
Message-Id: <20210315135741.198194285@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Artem Lapkin <art@khadas.com>

commit fa0c16caf3d73ab4d2e5d6fa2ef2394dbec91791 upstream.

Problem: random stucks on reboot stage about 1/20 stuck/reboots
// debug kernel log
[    4.496660] reboot: kernel restart prepare CMD:(null)
[    4.498114] meson_ee_pwrc c883c000.system-controller:power-controller: shutdown begin
[    4.503949] meson_ee_pwrc c883c000.system-controller:power-controller: shutdown domain 0:VPU...
...STUCK...

Solution: add shutdown function to meson_drm driver
// debug kernel log
[    5.231896] reboot: kernel restart prepare CMD:(null)
[    5.246135] [drm:meson_drv_shutdown]
...
[    5.259271] meson_ee_pwrc c883c000.system-controller:power-controller: shutdown begin
[    5.274688] meson_ee_pwrc c883c000.system-controller:power-controller: shutdown domain 0:VPU...
[    5.338331] reboot: Restarting system
[    5.358293] psci: PSCI_0_2_FN_SYSTEM_RESET reboot_mode:0 cmd:(null)
bl31 reboot reason: 0xd
bl31 reboot reason: 0x0
system cmd  1.
...REBOOT...

Tested: on VIM1 VIM2 VIM3 VIM3L khadas sbcs - 1000+ successful reboots
and Odroid boards, WeTek Play2 (GXBB)

Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Signed-off-by: Artem Lapkin <art@khadas.com>
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210302042202.3728113-1-art@khadas.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_drv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -361,6 +361,16 @@ static int meson_probe_remote(struct pla
 	return count;
 }
 
+static void meson_drv_shutdown(struct platform_device *pdev)
+{
+	struct meson_drm *priv = dev_get_drvdata(&pdev->dev);
+	struct drm_device *drm = priv->drm;
+
+	DRM_DEBUG_DRIVER("\n");
+	drm_kms_helper_poll_fini(drm);
+	drm_atomic_helper_shutdown(drm);
+}
+
 static int meson_drv_probe(struct platform_device *pdev)
 {
 	struct component_match *match = NULL;
@@ -405,6 +415,7 @@ MODULE_DEVICE_TABLE(of, dt_match);
 
 static struct platform_driver meson_drm_platform_driver = {
 	.probe      = meson_drv_probe,
+	.shutdown   = meson_drv_shutdown,
 	.driver     = {
 		.name	= "meson-drm",
 		.of_match_table = dt_match,


