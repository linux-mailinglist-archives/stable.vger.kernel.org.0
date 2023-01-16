Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F3066CC88
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjAPR0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbjAPR0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:26:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F9F1D91C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:03:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3663B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE3CC433D2;
        Mon, 16 Jan 2023 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888624;
        bh=vzoHGS+S1Gu/M+dbz91evZO4kuebFM+zJyNIfuuudE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2khVHB7SuMQUmnNN6fgpzz2lqFsI/lHpMnHek7C8qHQpJHOVUburjZ3aTobrg9cMY
         vL0X3GbMI/AnbLlZhvaKV3IMqFrJLhema91/MmwPjADp6tJ6hc6LKycb/CSaFEGDx7
         VA/Skxm1hHJtjbLmx+Sl24QEsbDcP6n3y+VuLbYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/338] regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
Date:   Mon, 16 Jan 2023 16:49:08 +0100
Message-Id: <20230116154824.149293215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f2b41b748c19962b82709d9f23c6b2b0ce9d2f91 ]

I got the the following report:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@62/regulators/exten

In of_get_regulator(), the node is returned from of_parse_phandle()
with refcount incremented, after using it, of_node_put() need be called.

Fixes: 69511a452e6d ("regulator: map consumer regulator based on device tree")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221115091508.900752-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ce5162ef9216..d6cd8e6e69cf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1478,6 +1478,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 		node = of_get_regulator(dev, supply);
 		if (node) {
 			r = of_find_regulator_by_node(node);
+			of_node_put(node);
 			if (r)
 				return r;
 
-- 
2.35.1



