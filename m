Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3224BCB4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgHTMvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729116AbgHTJn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E35992173E;
        Thu, 20 Aug 2020 09:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916637;
        bh=wtGVyYjZYxCX1zOoHAaTpFZdg8jlmbqqKlpOeNdE2pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRkwn/1/oeW8IvRaZBJpEVZvu1WwH+5qWKEI5TaytkW325STpIV3w8sLmZJyAKVTh
         UX/EWAok3NFhog1n0mQsLQZHCeymAP3Ne8hjIVQN5Nkobzi9271gCE5dbjXQHrJ9v0
         Biq3W/XzIJlyMJlL2NFf9Mo0jgD7BcWHvc1IkMV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 5.7 199/204] drm/tidss: fix modeset init for DPI panels
Date:   Thu, 20 Aug 2020 11:21:36 +0200
Message-Id: <20200820091616.120461314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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


