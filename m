Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE8A8F41
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbfIDSCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388800AbfIDSCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE45D208E4;
        Wed,  4 Sep 2019 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620161;
        bh=1RYvOBwHtQajG5Il0JH6xNqFr/+oHkRE2seaRdexZtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw3cRvcBS7fbY1UuTaRlHtcca3zUpVJ4hzao3azUVNpak1Dn/N3x/sM9Ik6qjB4fy
         fEp5TZsLXPZTLCivrviqeBTed3jknVyHZUhhsbgn7gSX9/bGGZejrIWi4yGwnIxxlI
         LPaXPXzZ/mT6GHNFQK7oM5zy5P6ofdtsOipCLSkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/57] drm/bridge: tfp410: fix memleak in get_modes()
Date:   Wed,  4 Sep 2019 19:53:41 +0200
Message-Id: <20190904175303.217813422@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c08f99c39083ab55a9c93b3e93cef48711294dad ]

We don't free the edid blob allocated by the call to drm_get_edid(),
causing a memleak. Fix this by calling kfree(edid) at the end of the
get_modes().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610135739.6077-1-tomi.valkeinen@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-tfp410.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-tfp410.c b/drivers/gpu/drm/bridge/ti-tfp410.c
index acb857030951a..1bb01905be8e3 100644
--- a/drivers/gpu/drm/bridge/ti-tfp410.c
+++ b/drivers/gpu/drm/bridge/ti-tfp410.c
@@ -64,7 +64,12 @@ static int tfp410_get_modes(struct drm_connector *connector)
 
 	drm_mode_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	ret = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return ret;
+
 fallback:
 	/* No EDID, fallback on the XGA standard modes */
 	ret = drm_add_modes_noedid(connector, 1920, 1200);
-- 
2.20.1



