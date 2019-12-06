Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC20114D79
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 09:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfLFITJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 03:19:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:60830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfLFITJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 03:19:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DBF5BA28;
        Fri,  6 Dec 2019 08:19:07 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     john.p.donnelly@oracle.com, daniel.vetter@ffwll.ch,
        airlied@redhat.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: [PATCH] drm/mgag200: Flag all G200 SE A machines as broken wrt <startadd>
Date:   Fri,  6 Dec 2019 09:19:01 +0100
Message-Id: <20191206081901.9938-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Several MGA G200 SE machines don't respect the value of the startadd
register field. After more feedback on affected machines, neither PCI
subvendor ID nor the internal ID seem to hint towards the bug. All
affected machines have a PCI ID of 0x0522 (i.e., G200 SE A). It was
decided to flag all G200 SE A machines as broken.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 1591fadf857c ("drm/mgag200: Add workaround for HW that does not support 'startadd'")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: John Donnelly <john.p.donnelly@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.3+
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
---
 drivers/gpu/drm/mgag200/mgag200_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index 30b3b827adf8..9f4f5f071add 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -30,9 +30,8 @@ module_param_named(modeset, mgag200_modeset, int, 0400);
 static struct drm_driver driver;
 
 static const struct pci_device_id pciidlist[] = {
-	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_VENDOR_ID_SUN, 0x4852, 0, 0,
+	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		G200_SE_A | MGAG200_FLAG_HW_BUG_NO_STARTADD},
-	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_A },
 	{ PCI_VENDOR_ID_MATROX, 0x524, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_B },
 	{ PCI_VENDOR_ID_MATROX, 0x530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_EV },
 	{ PCI_VENDOR_ID_MATROX, 0x532, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_WB },
-- 
2.23.0

