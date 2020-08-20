Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5114424AAF8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgHTAGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgHTADc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:03:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B33214F1;
        Thu, 20 Aug 2020 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881812;
        bh=H3PgQ+KoHDCKHKEBvlCxJCjz5lnvNV3Q3WKv9qcex58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+a8lXbtUnYnu99gf4OmQvQpvNtVOCV1rcDGT5gKEC4Vi8uJgwTdPhR/hG6RT4GcP
         GZ8yv6LKBSSsOCfMa0SVjzvxIHMYXQS8zyd5zk6CKMlgOCLGo52/wQayJSryLN4wtm
         4BYR4sdZWX6CFTxLbCiRIEmbX28Aw++CsfOAhlqo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/13] media: budget-core: Improve exception handling in budget_register()
Date:   Wed, 19 Aug 2020 20:03:17 -0400
Message-Id: <20200820000328.215755-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000328.215755-1-sashal@kernel.org>
References: <20200820000328.215755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit fc0456458df8b3421dba2a5508cd817fbc20ea71 ]

budget_register() has no error handling after its failure.
Add the missed undo functions for error handling to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ttpci/budget-core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index 97499b2af7144..20524376b83be 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -383,20 +383,25 @@ static int budget_register(struct budget *budget)
 	ret = dvbdemux->dmx.add_frontend(&dvbdemux->dmx, &budget->hw_frontend);
 
 	if (ret < 0)
-		return ret;
+		goto err_release_dmx;
 
 	budget->mem_frontend.source = DMX_MEMORY_FE;
 	ret = dvbdemux->dmx.add_frontend(&dvbdemux->dmx, &budget->mem_frontend);
 	if (ret < 0)
-		return ret;
+		goto err_release_dmx;
 
 	ret = dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, &budget->hw_frontend);
 	if (ret < 0)
-		return ret;
+		goto err_release_dmx;
 
 	dvb_net_init(&budget->dvb_adapter, &budget->dvb_net, &dvbdemux->dmx);
 
 	return 0;
+
+err_release_dmx:
+	dvb_dmxdev_release(&budget->dmxdev);
+	dvb_dmx_release(&budget->demux);
+	return ret;
 }
 
 static void budget_unregister(struct budget *budget)
-- 
2.25.1

