Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C712E1480
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgLWCkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgLWCXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3CFB2222D;
        Wed, 23 Dec 2020 02:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690205;
        bh=jnVDOmEeGyU9l9N9TYOqlwQedoGghCb0HUwCnNEMQak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoCd8qHzZyzCTyHMCNEPtVZdATGYlWAJ0TLVMDnnXYOqwmewBOLaaqawGTpujtI16
         fI+RIPLJV74Q2PvZ6zgr1mnEwojiVW/W50M27afwGcv10IPGj81/2dZ5OKbvgivxH3
         2zqCBeo3Ux3Ne3gxzeEvd/BhRVpGvJPwwPT7pu7bcO9YR71s3lMn1YAaTsy2fMHC+V
         MvMa7do7NI2WzXP3+EGocdXHvMgiY2EMuSQM1YavuDVhiGtXuDo+RvA4dAgXwSVf91
         v+975YS1Pk5+fztA4B+Hv/zuGDQHGsK8nSFs36duNSfd9S11Ur4ZV58R5NNFmQcvAw
         5QiQ+AYa65f3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 26/66] media: dvbdev: Fix memleak in dvb_register_device
Date:   Tue, 22 Dec 2020 21:22:12 -0500
Message-Id: <20201223022253.2793452-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index ba3c68fb9676b..b19db83e1aeb9 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -516,6 +516,9 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if (IS_ERR(clsdev)) {
 		pr_err("%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
 		return PTR_ERR(clsdev);
 	}
 	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
-- 
2.27.0

