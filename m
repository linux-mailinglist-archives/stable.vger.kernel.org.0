Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A59483346
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiACOfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiACOdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:33:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BCCC061761;
        Mon,  3 Jan 2022 06:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83EAE6112F;
        Mon,  3 Jan 2022 14:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9F3C36AED;
        Mon,  3 Jan 2022 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220329;
        bh=8UKBtvaq+kge4eaTjj755zrfzPSTNSNaJNMjEhe9rI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pb3Jxr5G7cBo5045TZoB9/dTN6qif2Z7i6banTQSIEoHZuuttuHvmUgi5gd3K7F5Q
         SCad1h17ChLv9/BtyvlW3BpKezS5byoL4z6qwUM2h0oAu5pXlXpjTs5MK2makRn46Q
         DRHuN6eX3yoUiIoVT7g83AmntV3RUBp6A3gCJBh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/73] platform/mellanox: mlxbf-pmc: Fix an IS_ERR() vs NULL bug in mlxbf_pmc_map_counters
Date:   Mon,  3 Jan 2022 15:23:28 +0100
Message-Id: <20220103142057.158111717@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 804034c4ffc502795cea9b3867acb2ec7fad99ba ]

The devm_ioremap() function returns NULL on error, it doesn't return
error pointers. Also according to doc of device_property_read_u64_array,
values in info array are properties of device or NULL.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211210070753.10761-1-linmq006@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 04bc3b50aa7a4..65b4a819f1bdf 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1374,8 +1374,8 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 		pmc->block[i].counters = info[2];
 		pmc->block[i].type = info[3];
 
-		if (IS_ERR(pmc->block[i].mmio_base))
-			return PTR_ERR(pmc->block[i].mmio_base);
+		if (!pmc->block[i].mmio_base)
+			return -ENOMEM;
 
 		ret = mlxbf_pmc_create_groups(dev, i);
 		if (ret)
-- 
2.34.1



