Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D8499FA2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841913AbiAXXAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835199AbiAXWfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:35:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28695C0E9BA3;
        Mon, 24 Jan 2022 12:59:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9742B8121C;
        Mon, 24 Jan 2022 20:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3AAC340EF;
        Mon, 24 Jan 2022 20:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057938;
        bh=YRDgXVbtszFbMEbOxnXPIBVRAGY0rRsNjTeP+1sYIQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAFmoZaLQcWrE0wjFWHfbnLbpAj2o6626tcdFsvsfqEmbDiURzyyXCewu9rjYQGXX
         M+9vBMLd1nF0orGygs47On25ZNr2UF9OPz6m5Ya3/UJ6TauU7JjLqTtLe/QDYXdBi5
         xGR63vcSFPQFygI714c7BXDdKn2muadWu85Y9ugI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0129/1039] media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()
Date:   Mon, 24 Jan 2022 19:31:58 +0100
Message-Id: <20220124184129.497979574@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cb4d67a998e97365afdf34965b069601da1dae60 ]

The "power" pointer is not initialized on the else path and that would
lead to an Oops.

Link: https://lore.kernel.org/linux-media/20211012082150.GA31086@kili
Fixes: c30f4cb2d4c7 ("media: atomisp: Refactor PMIC detection to a separate function")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
index d8c9e31314b2e..62dc06e224765 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
@@ -481,7 +481,7 @@ fail:
 
 static u8 gmin_get_pmic_id_and_addr(struct device *dev)
 {
-	struct i2c_client *power;
+	struct i2c_client *power = NULL;
 	static u8 pmic_i2c_addr;
 
 	if (pmic_id)
-- 
2.34.1



