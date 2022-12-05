Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23EB64329C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiLET1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLET0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B409C26555
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D0961311
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6F8C433D7;
        Mon,  5 Dec 2022 19:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268231;
        bh=R6T1HikAAeYSv7LBvZFiTMQo06xlSarkLpelg8PygGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANPZGIc81cJsUQqpGEaQFgI8pC7f4HsjaMIrlqvoK2aCEKsxdZm3KwmzrqaMu+EK/
         /V5YaGbD1dLagnNOo64F32mc6pxmxPWzilHdOshTA3w77fbYkn3i1LcLcoZs/e078x
         LeMHTqBYz7Qd0VKt/i1ceR+y+gfUd6dJQ2FAT4U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/124] of: property: decrement node refcount in of_fwnode_get_reference_args()
Date:   Mon,  5 Dec 2022 20:08:53 +0100
Message-Id: <20221205190809.221333749@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

[ Upstream commit 60d865bd5a9b15a3961eb1c08bd4155682a3c81e ]

In of_fwnode_get_reference_args(), the refcount of of_args.np has
been incremented in the case of successful return from
of_parse_phandle_with_args() or of_parse_phandle_with_fixed_args().

Decrement the refcount if of_args is not returned to the caller of
of_fwnode_get_reference_args().

Fixes: 3e3119d3088f ("device property: Introduce fwnode_property_get_reference_args")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Link: https://lore.kernel.org/r/20221121023209.3909759-1-yangyingliang@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 967f79b59016..134cfc980b70 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -993,8 +993,10 @@ of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
 						       nargs, index, &of_args);
 	if (ret < 0)
 		return ret;
-	if (!args)
+	if (!args) {
+		of_node_put(of_args.np);
 		return 0;
+	}
 
 	args->nargs = of_args.args_count;
 	args->fwnode = of_fwnode_handle(of_args.np);
-- 
2.35.1



