Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B362E139C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgLWCcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgLWCZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235F4221E5;
        Wed, 23 Dec 2020 02:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690279;
        bh=MtdmVI51KGlsdcDnJIWYE1WKTLsMFbdiPwdG4XWsvfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcaykQt5s61GqumNDR2XJ79sSYUEH2JvJ48DYKBsJku0k1RK4ggPs9Ls59kcqDw5l
         WwooNXD+zs3+br4FuHNAeEQlYozc+NBm0C0tVMo+rfiGTEXcbdT+B9U/2cHCq6w7yE
         NedJeFvc7X2U8lnazV4mYQ2YtxPvc5DYnzslnHLwFGFL7K2jw/ItAnvan/EpLZ2K8U
         o67FPld7xUJqTZNQOOZA/vyNt6QjWyNRl58bHm/pPMvRcvoyNj1gvG7yReGPOShWmJ
         V0Iuaj3Wbq3brdPpnknizkoUcFWNFvvJVetvZBxv/g424R+XvlSZhSxmn3eqBIq+Nw
         DE3GE6c5hlT6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 19/48] media: dvbdev: Fix memleak in dvb_register_device
Date:   Tue, 22 Dec 2020 21:23:47 -0500
Message-Id: <20201223022417.2794032-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 167faadfcf9339088910e9e85a1b711fcbbef8e9 ]

When device_create() fails, dvbdev and dvbdevfops should
be freed just like when dvb_register_media_device() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a1cc1c1e53182..ffd01d54edca8 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -515,6 +515,9 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if (IS_ERR(clsdev)) {
 		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
 		return PTR_ERR(clsdev);
 	}
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
-- 
2.27.0

