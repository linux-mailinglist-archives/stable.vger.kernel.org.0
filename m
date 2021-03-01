Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A249328E32
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbhCATZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237167AbhCATVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49667601FA;
        Mon,  1 Mar 2021 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620770;
        bh=BUuaOkVv+wk9oXuy73PoMLvwcMY3EXYNqt2PyTUw314=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Py6nWKCvc0l5fV6ebhkkxrMqjY6tfnEX3VtjwCYqWxoNgpGyXH9A2tCKr9Zseqib/
         RLokj9LpaixzPuQJT00iPf1VJs7ViYUEK6/WmX6FJJMEJccZyCqgxB9uK5KzjRokxJ
         Ba6LvhEKQlM/bvaXss797R5JXDvNkIIM7wce2RDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 274/775] drm/vc4: hdmi: Fix register offset with longer CEC messages
Date:   Mon,  1 Mar 2021 17:07:22 +0100
Message-Id: <20210301161215.171252634@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 4a59ed546c0511f01a4bf6b886fe34b6cce2513f ]

The code prior to 311e305fdb4e ("drm/vc4: hdmi: Implement a register
layout abstraction") was relying on the fact that the register offset
was incremented by 4 for each readl call. That worked since the register
width is 4 bytes.

However, since that commit the HDMI_READ macro is now taking an enum,
and the offset doesn't increment by 4 but 1 now. Divide the index by 4
to fix this.

Fixes: 311e305fdb4e ("drm/vc4: hdmi: Implement a register layout abstraction")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-4-maxime@cerno.tech
(cherry picked from commit e9c9481f373eb7344f9e973eb28fc6e9d0f46485)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ea50ecf985d1c..3d473638dbe18 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1312,13 +1312,20 @@ static irqreturn_t vc4_cec_irq_handler_thread(int irq, void *priv)
 
 static void vc4_cec_read_msg(struct vc4_hdmi *vc4_hdmi, u32 cntrl1)
 {
+	struct drm_device *dev = vc4_hdmi->connector.dev;
 	struct cec_msg *msg = &vc4_hdmi->cec_rx_msg;
 	unsigned int i;
 
 	msg->len = 1 + ((cntrl1 & VC4_HDMI_CEC_REC_WRD_CNT_MASK) >>
 					VC4_HDMI_CEC_REC_WRD_CNT_SHIFT);
+
+	if (msg->len > 16) {
+		drm_err(dev, "Attempting to read too much data (%d)\n", msg->len);
+		return;
+	}
+
 	for (i = 0; i < msg->len; i += 4) {
-		u32 val = HDMI_READ(HDMI_CEC_RX_DATA_1 + i);
+		u32 val = HDMI_READ(HDMI_CEC_RX_DATA_1 + (i >> 2));
 
 		msg->msg[i] = val & 0xff;
 		msg->msg[i + 1] = (val >> 8) & 0xff;
@@ -1411,11 +1418,17 @@ static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg)
 {
 	struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
+	struct drm_device *dev = vc4_hdmi->connector.dev;
 	u32 val;
 	unsigned int i;
 
+	if (msg->len > 16) {
+		drm_err(dev, "Attempting to transmit too much data (%d)\n", msg->len);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < msg->len; i += 4)
-		HDMI_WRITE(HDMI_CEC_TX_DATA_1 + i,
+		HDMI_WRITE(HDMI_CEC_TX_DATA_1 + (i >> 2),
 			   (msg->msg[i]) |
 			   (msg->msg[i + 1] << 8) |
 			   (msg->msg[i + 2] << 16) |
-- 
2.27.0



