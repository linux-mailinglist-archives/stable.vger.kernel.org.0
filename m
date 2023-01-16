Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7500966C709
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjAPQ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjAPQ1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:27:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A03D27D69
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140F961040
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8A0C433EF;
        Mon, 16 Jan 2023 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885722;
        bh=XwkNTwjSvQjpEK++AbypaoT6FLRgWOSlRngm363nkMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kc9JEFJzZHPc5++gjC0rDwaA9fy5JIcx3zypw5hz+zAI0k3BZXU+uwe8g4qGsGwPV
         NXC1cQwF0eI9yiryfyZ9ffotm+ZO1lMcPR154hwVqj534NS7ND3AScH3zvwfmBZg2k
         Ryf+lAEkJXyE9/p0AfABo2234vIVOUniCeLkbv5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/658] regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
Date:   Mon, 16 Jan 2023 16:43:38 +0100
Message-Id: <20230116154915.394303028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 7d15312d6792..ee71dcb009bf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1734,6 +1734,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 		node = of_get_regulator(dev, supply);
 		if (node) {
 			r = of_find_regulator_by_node(node);
+			of_node_put(node);
 			if (r)
 				return r;
 
-- 
2.35.1



