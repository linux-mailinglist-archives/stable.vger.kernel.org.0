Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB8657CD0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiL1PgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiL1PgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07774140AB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 983E96154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09E8C433D2;
        Wed, 28 Dec 2022 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241775;
        bh=EISk3vffaebLwNiIXktc+CP2gkOQ+8B8Ouwyx1EBlqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0H7bILzj88+0dI2h70T4VAW+RzvSoj0FQH+FwlXoPL26En0jNxIauT/0WMluxa1wq
         fI4lQiuFCcP6V5zxNllxfDzkw8HC2gbyqHj2Vy6IN5jf8qo/EVrRBUMkXEQJyYn+5j
         sYV6x9noaL7vTo9oiS9SalASaNPTUEPtSD4PQFo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/731] power: supply: fix null pointer dereferencing in power_supply_get_battery_info
Date:   Wed, 28 Dec 2022 15:40:28 +0100
Message-Id: <20221228144311.648913301@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit 104bb8a663451404a26331263ce5b96c34504049 ]

when kmalloc() fail to allocate memory in kasprintf(), propname
will be NULL, strcmp() called by of_get_property() will cause
null pointer dereference.

So return ENOMEM if kasprintf() return NULL pointer.

Fixes: 3afb50d7125b ("power: supply: core: Add some helpers to use the battery OCV capacity table")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index c3af54421840..3f9c60c5b250 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -696,6 +696,11 @@ int power_supply_get_battery_info(struct power_supply *psy,
 		int i, tab_len, size;
 
 		propname = kasprintf(GFP_KERNEL, "ocv-capacity-table-%d", index);
+		if (!propname) {
+			power_supply_put_battery_info(psy, info);
+			err = -ENOMEM;
+			goto out_put_node;
+		}
 		list = of_get_property(battery_np, propname, &size);
 		if (!list || !size) {
 			dev_err(&psy->dev, "failed to get %s\n", propname);
-- 
2.35.1



