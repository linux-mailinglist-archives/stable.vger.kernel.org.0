Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5206AF040
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjCGS3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjCGS3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADA8A3B52
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F7261530
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F657C433EF;
        Tue,  7 Mar 2023 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213331;
        bh=/CMlKbgu7ZHcfwgq2kZJq9NL/oI31B5f5/ceCswkJc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+Nwu/r5I7pagTdXau3laKf3mC7+i1wXFoiYUdECuWTwt+M6G69OtXh6u7XMrO2zR
         T7HBTHwD/dfCUmnTzL5DD9G0A7WCB0dTDnwR1dSOJkKbweRkI6HO1pdUO678mAHMOp
         U99bhVoJ/VBRT2JIMg1FjpCdtI7BUKWzi57j+/zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/885] driver core: location: Free struct acpi_pld_info *pld before return false
Date:   Tue,  7 Mar 2023 17:56:17 +0100
Message-Id: <20230307170021.684474008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 0d150f967e8410e1e6712484543eec709356a65d ]

struct acpi_pld_info *pld should be freed before the return of allocation
failure, to prevent memory leak, add the ACPI_FREE() to fix it.

Fixes: bc443c31def5 ("driver core: location: Check for allocations failure")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1669102648-11517-1-git-send-email-guohanjun@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/physical_location.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/physical_location.c b/drivers/base/physical_location.c
index 87af641cfe1a3..951819e71b4ad 100644
--- a/drivers/base/physical_location.c
+++ b/drivers/base/physical_location.c
@@ -24,8 +24,11 @@ bool dev_add_physical_location(struct device *dev)
 
 	dev->physical_location =
 		kzalloc(sizeof(*dev->physical_location), GFP_KERNEL);
-	if (!dev->physical_location)
+	if (!dev->physical_location) {
+		ACPI_FREE(pld);
 		return false;
+	}
+
 	dev->physical_location->panel = pld->panel;
 	dev->physical_location->vertical_position = pld->vertical_position;
 	dev->physical_location->horizontal_position = pld->horizontal_position;
-- 
2.39.2



