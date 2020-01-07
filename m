Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFAB133333
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgAGVGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbgAGVGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC33222D9;
        Tue,  7 Jan 2020 21:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431197;
        bh=X1olxmeGS+hSOKkAH1nvOlnj9Bz0S9uKNKI8lnj2Mjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTqVLKGVBFaz6G9idHhEes+Cpgdmgv4ajkG2RsB7V1oBMwRgH0OEuXHEnsSeKtPOw
         Mzw+xGmOz+x1foFzkUdPpcvfbhlgPmJlQjTGyUzniWtSplOwaUUCSvffsfITZ+XNs9
         5tVZKY1kqmJjbB2vOWoPWpUWu64k3R1fHUzApk0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Mavrodiev <stefan@olimex.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 4.19 046/115] drm/sun4i: hdmi: Remove duplicate cleanup calls
Date:   Tue,  7 Jan 2020 21:54:16 +0100
Message-Id: <20200107205302.184939895@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mavrodiev <stefan@olimex.com>

commit 57177d214ee0816c4436c23d6c933ccb32c571f1 upstream.

When the HDMI unbinds drm_connector_cleanup() and drm_encoder_cleanup()
are called. This also happens when the connector and the encoder are
destroyed. This double call triggers a NULL pointer exception.

The patch fixes this by removing the cleanup calls in the unbind
function.

Cc: <stable@vger.kernel.org>
Fixes: 9c5681011a0c ("drm/sun4i: Add HDMI support")
Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20191217124632.20820-1-stefan@olimex.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -651,8 +651,6 @@ static void sun4i_hdmi_unbind(struct dev
 	struct sun4i_hdmi *hdmi = dev_get_drvdata(dev);
 
 	cec_unregister_adapter(hdmi->cec_adap);
-	drm_connector_cleanup(&hdmi->connector);
-	drm_encoder_cleanup(&hdmi->encoder);
 	i2c_del_adapter(hdmi->i2c);
 	clk_disable_unprepare(hdmi->mod_clk);
 	clk_disable_unprepare(hdmi->bus_clk);


