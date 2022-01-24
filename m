Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D6499917
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454145AbiAXVbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451491AbiAXVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCC6C028C31;
        Mon, 24 Jan 2022 12:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2004861491;
        Mon, 24 Jan 2022 20:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0300DC340E5;
        Mon, 24 Jan 2022 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055432;
        bh=YRDgXVbtszFbMEbOxnXPIBVRAGY0rRsNjTeP+1sYIQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uxx2vE0HLcavSZ7WH7kfIm+UDJLIE01KWsUMFYR8tyUKNRcHpkYHZh7PQw4Vtv54
         gWsYF+QGJQ+0SSiWNOpGEZelV3DAp4nvTtVRl6FDqBNU/B/93GJ3U9O0cuvyorChh/
         0m0JhQgYCi+dtw0Ip/2+xfkcYd3li91IJiKlsQLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/846] media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()
Date:   Mon, 24 Jan 2022 19:33:53 +0100
Message-Id: <20220124184104.972052235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



