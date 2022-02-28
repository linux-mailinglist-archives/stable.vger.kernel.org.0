Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155014C7666
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiB1SEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240629AbiB1SDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3492CDBF;
        Mon, 28 Feb 2022 09:47:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0719B81085;
        Mon, 28 Feb 2022 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D03C340E7;
        Mon, 28 Feb 2022 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070415;
        bh=mnkt+5Ak8JOKgSSwk+d2Lz2WiQE6cY/xo0S7CuH+MwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXUufLwK2aRIi3Pkqh0riTz1TxZGc/5V9qdzPVBT63gKbhodZJ9+aXcRGFX+79Yy0
         9Lyi4U8DDUbgi9+jkQfY7lbTMC8MolC3B4TGIrW6V2OzCt03lD+HIH36Q3xyHTUqnH
         ZTvzWh3BjS5Mzn8JzRaki4vyF3Kwk9uCN4thORPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 098/164] net/mlx5e: Add missing increment of count
Date:   Mon, 28 Feb 2022 18:24:20 +0100
Message-Id: <20220228172408.662393867@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

commit 5ee02b7a800654ff9549807bcf0b4c9fd5cf25f9 upstream.

Add mistakenly missing increment of count variable when looping over
output buffer in mlx5e_self_test().

This resolves the issue of garbage values output when querying with self
test via ethtool.

before:
$ ethtool -t eth2
The test result is PASS
The test extra info:
Link Test        0
Speed Test       1768697188
Health Test      758528120
Loopback Test    3288687

after:
$ ethtool -t eth2
The test result is PASS
The test extra info:
Link Test        0
Speed Test       0
Health Test      0
Loopback Test    0

Fixes: 7990b1b5e8bd ("net/mlx5e: loopback test is not supported in switchdev mode")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -334,6 +334,7 @@ void mlx5e_self_test(struct net_device *
 		netdev_info(ndev, "\t[%d] %s start..\n", i, st.name);
 		buf[count] = st.st_func(priv);
 		netdev_info(ndev, "\t[%d] %s end: result(%lld)\n", i, st.name, buf[count]);
+		count++;
 	}
 
 	mutex_unlock(&priv->state_lock);


