Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16C3111FF7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfLCWlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfLCWlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074D820684;
        Tue,  3 Dec 2019 22:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412857;
        bh=1Wa7Y73D3XJhTks5us0CBd3ZwsIhfCstPHl28n/jOqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCpjKsZzhGWGraMA2ahSeD5U/l6BLGlUvbzlLTjGy6NHs9hPrHaeF8SM3Edf391FU
         xHIkyBsiG6kNCflDR+YN3R/M8VC9eE0t+HBSngpLKAO+uzIoiumue+vDBX7qUO86m4
         dS9s86CoCRrPxzYhUObRADCDEMt0uQTJ2hamhL54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Campbell <lists2009@fnarfbargle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 007/135] thunderbolt: Read DP IN adapter first two dwords in one go
Date:   Tue,  3 Dec 2019 23:34:07 +0100
Message-Id: <20191203213007.107464122@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit fd5c46b754d4799afda8dcdd6851e0390aa4961a ]

When we discover existing DP tunnels the code checks whether DP IN
adapter port is enabled by calling tb_dp_port_is_enabled() before it
continues the discovery process. On Light Ridge (gen 1) controller
reading only the first dword of the DP IN config space causes subsequent
access to the same DP IN port path config space to fail or return
invalid data as can be seen in the below splat:

  thunderbolt 0000:07:00.0: CFG_ERROR(0:d): Invalid config space or offset
  Call Trace:
   tb_cfg_read+0xb9/0xd0
   __tb_path_deactivate_hop+0x98/0x210
   tb_path_activate+0x228/0x7d0
   tb_tunnel_restart+0x95/0x200
   tb_handle_hotplug+0x30e/0x630
   process_one_work+0x1b4/0x340
   worker_thread+0x44/0x3d0
   kthread+0xeb/0x120
   ? process_one_work+0x340/0x340
   ? kthread_park+0xa0/0xa0
   ret_from_fork+0x1f/0x30

If both DP In adapter config dwords are read in one go the issue does
not reproduce. This is likely firmware bug but we can work it around by
always reading the two dwords in one go. There should be no harm for
other controllers either so can do it unconditionally.

Link: https://lkml.org/lkml/2019/8/28/160
Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 5668a44e0653b..00daf5a7f46a5 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -887,12 +887,13 @@ int tb_dp_port_set_hops(struct tb_port *port, unsigned int video,
  */
 bool tb_dp_port_is_enabled(struct tb_port *port)
 {
-	u32 data;
+	u32 data[2];
 
-	if (tb_port_read(port, &data, TB_CFG_PORT, port->cap_adap, 1))
+	if (tb_port_read(port, data, TB_CFG_PORT, port->cap_adap,
+			 ARRAY_SIZE(data)))
 		return false;
 
-	return !!(data & (TB_DP_VIDEO_EN | TB_DP_AUX_EN));
+	return !!(data[0] & (TB_DP_VIDEO_EN | TB_DP_AUX_EN));
 }
 
 /**
@@ -905,19 +906,21 @@ bool tb_dp_port_is_enabled(struct tb_port *port)
  */
 int tb_dp_port_enable(struct tb_port *port, bool enable)
 {
-	u32 data;
+	u32 data[2];
 	int ret;
 
-	ret = tb_port_read(port, &data, TB_CFG_PORT, port->cap_adap, 1);
+	ret = tb_port_read(port, data, TB_CFG_PORT, port->cap_adap,
+			   ARRAY_SIZE(data));
 	if (ret)
 		return ret;
 
 	if (enable)
-		data |= TB_DP_VIDEO_EN | TB_DP_AUX_EN;
+		data[0] |= TB_DP_VIDEO_EN | TB_DP_AUX_EN;
 	else
-		data &= ~(TB_DP_VIDEO_EN | TB_DP_AUX_EN);
+		data[0] &= ~(TB_DP_VIDEO_EN | TB_DP_AUX_EN);
 
-	return tb_port_write(port, &data, TB_CFG_PORT, port->cap_adap, 1);
+	return tb_port_write(port, data, TB_CFG_PORT, port->cap_adap,
+			     ARRAY_SIZE(data));
 }
 
 /* switch utility functions */
-- 
2.20.1



