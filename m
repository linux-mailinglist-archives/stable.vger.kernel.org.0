Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CD1498F60
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351614AbiAXTwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36948 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356391AbiAXTqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED4EFB8121A;
        Mon, 24 Jan 2022 19:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF38C340E5;
        Mon, 24 Jan 2022 19:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053563;
        bh=6ip6A0h5hrMAi23ynIfiqNaHv6NylR563ug94IIyhyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6ZvJpVVXj+jpLSq2/Q7cTVxfB/ir2EWme5o7Rn+6qnbDGjC2NDCTzfD//T6gRJJo
         0b9SJx3/pGwvSZrsAFM0F+petkRoU7aOPWUEl385wAzKOqMJxjtX31JMOuFXl6KTxf
         +rGW+5fgQKrg+FovNjM/yafoQGU1bvmoLTmmJcqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/563] media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()
Date:   Mon, 24 Jan 2022 19:37:19 +0100
Message-Id: <20220124184026.960692562@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 135994d44802c..34480ca164746 100644
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



