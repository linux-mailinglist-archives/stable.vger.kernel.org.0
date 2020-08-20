Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041624BE0C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgHTNRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbgHTJep (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56E0B21775;
        Thu, 20 Aug 2020 09:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916083;
        bh=wtGVyYjZYxCX1zOoHAaTpFZdg8jlmbqqKlpOeNdE2pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw2QYEX/SWvch3MGArmxu74KrV8BbVimshJJ9OwVG3BukBkVK/4vkMjH66z9z9ceS
         gZT0nwoh4No2H5Muir2R3ZnWQqQcqBVh/kcS2a+yBj1Z3I94SQfHVC+/OcW2Z+Adni
         en5ozL3/1/vkYe4ZG65L96P7LFeUip9VXWhoc988=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 5.8 227/232] drm/tidss: fix modeset init for DPI panels
Date:   Thu, 20 Aug 2020 11:21:18 +0200
Message-Id: <20200820091623.778527848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit a72a6a16d51034045cb6355924b62221a8221ca3 upstream.

The connector type for DISPC's DPI videoport was set the LVDS instead of
DPI. This causes any DPI panel setup to fail with tidss, making all DPI
panels unusable.

Fix this by using correct connector type.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: 32a1795f57eecc39749017 ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org # v5.7+
Link: https://patchwork.freedesktop.org/patch/msgid/20200604080214.107159-1-tomi.valkeinen@ti.com
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tidss/tidss_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -154,7 +154,7 @@ static int tidss_dispc_modeset_init(stru
 				break;
 			case DISPC_VP_DPI:
 				enc_type = DRM_MODE_ENCODER_DPI;
-				conn_type = DRM_MODE_CONNECTOR_LVDS;
+				conn_type = DRM_MODE_CONNECTOR_DPI;
 				break;
 			default:
 				WARN_ON(1);


