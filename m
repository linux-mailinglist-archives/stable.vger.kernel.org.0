Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551AF13EC3D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394043AbgAPRzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:55:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394112AbgAPRoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CEC2475E;
        Thu, 16 Jan 2020 17:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196655;
        bh=PkaWdYxqxdWMRUsmEVtqI7yY+n4bIU56XI/NRCZjYLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2Yv6oGDu/73qL1wVyB2YgBOUSu9qrutu64Xugk+hjVJwpVzclGdqHX9VW4/w89Wt
         /6eYqcj7fEWC4PdL8kzdTW3lVf7CvCoKeoNdzBAnHyZmpR9mHyCYlUE0H5qQ4bfSM2
         wkrgCqUCOcQekad6of2OQNfiUBrPGoLMnMAKtNuQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Mc Guire <hofrat@osadl.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 062/174] media: cx23885: check allocation return
Date:   Thu, 16 Jan 2020 12:40:59 -0500
Message-Id: <20200116174251.24326-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit a3d7f22ef34ec4206b50ee121384d5c8bebd5591 ]

Checking of kmalloc() seems to have been committed - as
cx23885_dvb_register() is checking for != 0 return, returning
-ENOMEM should be fine here.  While at it address the coccicheck
suggestion to move to kmemdup rather than using kmalloc+memcpy.

Fixes: 46b21bbaa8a8 ("[media] Add support for DViCO FusionHDTV DVB-T Dual Express2")

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e543cbbf2ec4..8fe78b8b1c25 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1452,8 +1452,9 @@ static int dvb_register(struct cx23885_tsport *port)
 		if (fe0->dvb.frontend != NULL) {
 			struct i2c_adapter *tun_i2c;
 
-			fe0->dvb.frontend->sec_priv = kmalloc(sizeof(dib7000p_ops), GFP_KERNEL);
-			memcpy(fe0->dvb.frontend->sec_priv, &dib7000p_ops, sizeof(dib7000p_ops));
+			fe0->dvb.frontend->sec_priv = kmemdup(&dib7000p_ops, sizeof(dib7000p_ops), GFP_KERNEL);
+			if (!fe0->dvb.frontend->sec_priv)
+				return -ENOMEM;
 			tun_i2c = dib7000p_ops.get_i2c_master(fe0->dvb.frontend, DIBX000_I2C_INTERFACE_TUNER, 1);
 			if (!dvb_attach(dib0070_attach, fe0->dvb.frontend, tun_i2c, &dib7070p_dib0070_config))
 				return -ENODEV;
-- 
2.20.1

