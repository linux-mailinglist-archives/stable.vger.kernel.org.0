Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9AA8FD0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389363AbfIDSF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389360AbfIDSF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E418206B8;
        Wed,  4 Sep 2019 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620358;
        bh=0np0P7IWLxE9lnVSb3QHHfmMoU9gDJIs4h21PuBCexA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McxNEEzO8ybG9uyXtby+yW66Cth47BWG3K/j7Z5ATynQFd1wadOLDcarvomKtR5WJ
         hPkYMaYDMF00ftodY+bNeGK1jlbVQeQWWh9YZylObHH5S4+P9D0+wjdYdb+mpOLhWF
         tnRp76ywibA5kOsGW10r+26EVmrt7EKlvQwjAKFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/93] drm/bridge: tfp410: fix memleak in get_modes()
Date:   Wed,  4 Sep 2019 19:53:30 +0200
Message-Id: <20190904175305.756905244@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
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
index c3e32138c6bb0..9dc109df0808c 100644
--- a/drivers/gpu/drm/bridge/ti-tfp410.c
+++ b/drivers/gpu/drm/bridge/ti-tfp410.c
@@ -64,7 +64,12 @@ static int tfp410_get_modes(struct drm_connector *connector)
 
 	drm_connector_update_edid_property(connector, edid);
 
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



