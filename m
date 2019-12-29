Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A53312C781
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfL2RnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbfL2RnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CC79206A4;
        Sun, 29 Dec 2019 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641384;
        bh=EHcmY2V9wTxjVlUy60lI81wwtaSdWQ7RGNXMuYUw+xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuLRGG5N7eu8MtX1S0ZofPGmlxIKc9gjHjriOCPGuqJMt7cvVmnpSKImm0G8/JgV3
         Ffq/mKGUbUBXAsQjA700bv2E3LPJOEDogPnaCLmu7VYJMuPxLhIRvJL/cXHo7b9Fci
         WOzAV5/nqeQUJYlAcPeh1Ho4cULLdrQc3p0fvoKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dariusz Marcinkiewicz <darekm@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Eric Anholt <eric@anholt.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/434] drm/vc4/vc4_hdmi: fill in connector info
Date:   Sun, 29 Dec 2019 18:21:36 +0100
Message-Id: <20191229172704.884902521@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dariusz Marcinkiewicz <darekm@google.com>

[ Upstream commit 66c2dee4ae10a2d841c40b9dd9c7141eb23eee76 ]

Fill in the connector info, allowing userspace to associate
the CEC device with the drm connector.

Tested on a Raspberry Pi 3B.

Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Eric Anholt <eric@anholt.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20190823112427.42394-2-hverkuil-cisco@xs4all.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ee7d4e7b0ee3..0853b980bcb3 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1285,6 +1285,9 @@ static const struct cec_adap_ops vc4_hdmi_cec_adap_ops = {
 
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+	struct cec_connector_info conn_info;
+#endif
 	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct vc4_dev *vc4 = drm->dev_private;
@@ -1403,13 +1406,15 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 #ifdef CONFIG_DRM_VC4_HDMI_CEC
 	hdmi->cec_adap = cec_allocate_adapter(&vc4_hdmi_cec_adap_ops,
 					      vc4, "vc4",
-					      CEC_CAP_TRANSMIT |
-					      CEC_CAP_LOG_ADDRS |
-					      CEC_CAP_PASSTHROUGH |
-					      CEC_CAP_RC, 1);
+					      CEC_CAP_DEFAULTS |
+					      CEC_CAP_CONNECTOR_INFO, 1);
 	ret = PTR_ERR_OR_ZERO(hdmi->cec_adap);
 	if (ret < 0)
 		goto err_destroy_conn;
+
+	cec_fill_conn_info_from_drm(&conn_info, hdmi->connector);
+	cec_s_conn_info(hdmi->cec_adap, &conn_info);
+
 	HDMI_WRITE(VC4_HDMI_CPU_MASK_SET, 0xffffffff);
 	value = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
 	value &= ~VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
-- 
2.20.1



