Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990DC5496A4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357048AbiFMLz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356886AbiFMLxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:53:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E562ED57;
        Mon, 13 Jun 2022 03:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D3E61375;
        Mon, 13 Jun 2022 10:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22AEC341D3;
        Mon, 13 Jun 2022 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117744;
        bh=0MVcLKtOiJ1en+qFatDzRtpZOqV8V0+YNba66rRBLvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GchJcHpowOyslPrAVJB4C21NsiFnnoaxwVLfBE/oNXkUtAVWEyTBNK1+WHABWx4T4
         jmOCMA3qw8Fb7imfJ9qwzUcOeiinBZjVTpzvcVfEBDdRvh3LDqsMeZfzuLkQNq0v0y
         lz/p7m2rDdKLcPoNrcQtq4hXvpvUvcQGPTQ1OIrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/287] regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt
Date:   Mon, 13 Jun 2022 12:08:38 +0200
Message-Id: <20220613094926.729668023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit afaa7b933ef00a2d3262f4d1252087613fb5c06d ]

of_node_get() returns a node with refcount incremented.
Calling of_node_put() to drop the reference when not needed anymore.

Fixes: 3784b6d64dc5 ("regulator: pfuze100: add pfuze100 regulator driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511113506.45185-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pfuze100-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 4b8306594c3f..8b1940110561 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -513,6 +513,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	parent = of_get_child_by_name(np, "regulators");
 	if (!parent) {
 		dev_err(dev, "regulators node not found\n");
+		of_node_put(np);
 		return -EINVAL;
 	}
 
@@ -542,6 +543,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	}
 
 	of_node_put(parent);
+	of_node_put(np);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
2.35.1



