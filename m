Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3959469ED4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379583AbhLFPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390514AbhLFPm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B902C0A888A;
        Mon,  6 Dec 2021 07:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE3A61310;
        Mon,  6 Dec 2021 15:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17DBC34900;
        Mon,  6 Dec 2021 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804431;
        bh=MxK77b//Mj/cYj0ZT2TpaodAuEGes9XeVHOxQvtpX94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRRW51Uzxtxsa2CPFoTqboUgJRHfwgVubNM6xwpikUscA9nWoWLfVIG3Fwvk7I7qZ
         UMAXrasvEX6+uCiT1ZxrVSwyXNqVzjvsdmin5XwEBwhzELRUIj3unaf73gxGgPRink
         DkhK+JJNNXwsMXj2VHNeeNiBr/XglTfx551zrgX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <dbezrukov@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 145/207] atlantic: Increase delay for fw transactions
Date:   Mon,  6 Dec 2021 15:56:39 +0100
Message-Id: <20211206145615.256810685@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbezrukov@marvell.com>

commit aa1dcb5646fdf34a15763facf4bf5e482a2814ca upstream.

The max waiting period (of 1 ms) while reading the data from FW shared
buffer is too small for certain types of data (e.g., stats). There's a
chance that FW could be updating buffer at the same time and driver
would be unsuccessful in reading data. Firmware manual recommends to
have 1 sec timeout to fix this issue.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -84,7 +84,7 @@ static int hw_atl2_shared_buffer_read_bl
 			if (cnt > AQ_A2_FW_READ_TRY_MAX)
 				return -ETIME;
 			if (tid1.transaction_cnt_a != tid1.transaction_cnt_b)
-				udelay(1);
+				mdelay(1);
 		} while (tid1.transaction_cnt_a != tid1.transaction_cnt_b);
 
 		hw_atl2_mif_shared_buf_read(self, offset, (u32 *)data, dwords);
@@ -339,8 +339,11 @@ static int aq_a2_fw_update_stats(struct
 {
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
 	struct statistics_s stats;
+	int err;
 
-	hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	if (err)
+		return err;
 
 #define AQ_SDELTA(_N_, _F_) (self->curr_stats._N_ += \
 			stats.msm._F_ - priv->last_stats.msm._F_)


