Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC15218BE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbiEJNjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244961AbiEJNiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A493878929;
        Tue, 10 May 2022 06:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387E46170D;
        Tue, 10 May 2022 13:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F47C385C2;
        Tue, 10 May 2022 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189205;
        bh=Y25/R4Z9zWRfq6oQO6x6b8SBv9CRfRZbAbHgBjQAO2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYk+RlMyBOiPEGDl11TARMb1LeUvK9FCmuIMw8ZPrVO/1hd4RAs8C+BqbTtHtWBXi
         kvTAoKEtSpHQ9G3jRP2TnSSjj2hP5jtm2rW5KKcsHF4olU9gp2CATTve4pr5/5uwhc
         zaQDsMOqbltol8IuHk4M46ivuc8kxsygvvRbCf04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 46/70] net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
Date:   Tue, 10 May 2022 15:08:05 +0200
Message-Id: <20220510130734.207506860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit a9e9b091a1c14ecd8bd9d3214a62142a1786fe30 upstream.

Add of_node_put() if of_get_phy_mode() fails in mt7530_setup()

Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220428095317.538829-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1663,6 +1663,7 @@ mt7530_setup(struct dsa_switch *ds)
 				ret = of_get_phy_mode(mac_np, &interface);
 				if (ret && ret != -ENODEV) {
 					of_node_put(mac_np);
+					of_node_put(phy_node);
 					return ret;
 				}
 				id = of_mdio_parse_addr(ds->dev, phy_node);


