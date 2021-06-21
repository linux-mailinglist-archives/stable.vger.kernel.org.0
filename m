Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB73AEF34
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhFUQg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhFUQfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDFF611BD;
        Mon, 21 Jun 2021 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292853;
        bh=3u/VxQOcPI8nrQx6xccER5Q/Dw3tS9Y8yzh4EZ+oMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL1648JYqu5CRIMItNIl/yk2tLqguWKWCSx2koEIydMsYGyJjCRcCpA+302EeAAV8
         taFOisCbgC9d70Ko+ObEItAgGtwlSAxT3bwO9cc+3uO6T+JMiozRcnjTafDpt5zzM1
         oENK2HBHJx2AKQc5vN0KcMBs2cDmsb5xifAeU8Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 001/178] dmaengine: idxd: add engine struct device missing bus type assignment
Date:   Mon, 21 Jun 2021 18:13:35 +0200
Message-Id: <20210621154921.295236518@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 1c4841ccbd2b185587010d6178aac11953f61d4c ]

engine 'struct device' setup is missing assigning the bus type. Add it to
dsa_bus_type.

Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161947841562.984844.17505646725993659651.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 59f2104ffc77..f73677490b6c 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -218,6 +218,7 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 		engine->idxd = idxd;
 		device_initialize(&engine->conf_dev);
 		engine->conf_dev.parent = &idxd->conf_dev;
+		engine->conf_dev.bus = &dsa_bus_type;
 		engine->conf_dev.type = &idxd_engine_device_type;
 		rc = dev_set_name(&engine->conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
-- 
2.30.2



