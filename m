Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2595E59D921
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242405AbiHWJrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352566AbiHWJqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:46:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404596050F;
        Tue, 23 Aug 2022 01:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40838CE1B44;
        Tue, 23 Aug 2022 08:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B0BC433C1;
        Tue, 23 Aug 2022 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244161;
        bh=iwlSgC6Aa0nWy47+NA8m36MZZmWgMbKUT66h/Y2MjP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mofMnoaNR2AicMb4hCqphwc93rudAgDjnzO/MNE1FSjNidMDThgEffG3bsv/dLxk+
         5cg5SEAy5WB0I37QgeyIi2TRA6ZjJOy4iWt1t8lofMJqEJkVNh9eLEIg5QO7PwGJXk
         F0H3Zq1fNhjPdgeZE7IqcZGeWS1sWr7l+Ky5b0Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/229] mtd: maps: Fix refcount leak in ap_flash_init
Date:   Tue, 23 Aug 2022 10:24:16 +0200
Message-Id: <20220823080057.103541548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 77087a04c8fd554134bddcb8a9ff87b21f357926 ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: b0afd44bc192 ("mtd: physmap_of: add a hook for Versatile write protection")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220523143255.4376-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap_of_versatile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/maps/physmap_of_versatile.c b/drivers/mtd/maps/physmap_of_versatile.c
index 961704228dd2..7d56e97bd50f 100644
--- a/drivers/mtd/maps/physmap_of_versatile.c
+++ b/drivers/mtd/maps/physmap_of_versatile.c
@@ -107,6 +107,7 @@ static int ap_flash_init(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	ebi_base = of_iomap(ebi, 0);
+	of_node_put(ebi);
 	if (!ebi_base)
 		return -ENODEV;
 
-- 
2.35.1



