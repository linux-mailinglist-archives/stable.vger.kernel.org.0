Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9632E328959
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbhCARzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231936AbhCARt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6A22650EE;
        Mon,  1 Mar 2021 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618012;
        bh=dTdK1XNUDKrFjFqbLJTwsNmzrJn7tIauk312iexnrOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkN+vQaFUCBINcqACpnHN2iYtsNSDSLhuI5+Q7tUD9oYjqa3L1tIJzZytUsk3bujZ
         Dz9OZmCDYKBE434kM+sp9WyVg7An1F36yRfBze4PUAHdRlG+s/vD6orwM8Nk/y0IFn
         UjUDqFAXmCfOY/xmabBFYrJkUYvmqoaTVltx7Cv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.4 259/340] drm/nouveau/kms: handle mDP connectors
Date:   Mon,  1 Mar 2021 17:13:23 +0100
Message-Id: <20210301161101.047923049@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit d1f5a3fc85566e9ddce9361ef180f070367e6eab upstream.

In some cases we have the handle those explicitly as the fallback
connector type detection fails and marks those as eDP connectors.

Attempting to use such a connector with mutter leads to a crash of mutter
as it ends up with two eDP displays.

Information is taken from the official DCB documentation.

Cc: stable@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: Ben Skeggs <bskeggs@redhat.com>
Reported-by: Mark Pearson <markpearson@lenovo.com>
Tested-by: Mark Pearson <markpearson@lenovo.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h |    1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c             |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
@@ -14,6 +14,7 @@ enum dcb_connector_type {
 	DCB_CONNECTOR_LVDS_SPWG = 0x41,
 	DCB_CONNECTOR_DP = 0x46,
 	DCB_CONNECTOR_eDP = 0x47,
+	DCB_CONNECTOR_mDP = 0x48,
 	DCB_CONNECTOR_HDMI_0 = 0x60,
 	DCB_CONNECTOR_HDMI_1 = 0x61,
 	DCB_CONNECTOR_HDMI_C = 0x63,
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1240,6 +1240,7 @@ drm_conntype_from_dcb(enum dcb_connector
 	case DCB_CONNECTOR_DMS59_DP0:
 	case DCB_CONNECTOR_DMS59_DP1:
 	case DCB_CONNECTOR_DP       :
+	case DCB_CONNECTOR_mDP      :
 	case DCB_CONNECTOR_USB_C    : return DRM_MODE_CONNECTOR_DisplayPort;
 	case DCB_CONNECTOR_eDP      : return DRM_MODE_CONNECTOR_eDP;
 	case DCB_CONNECTOR_HDMI_0   :


