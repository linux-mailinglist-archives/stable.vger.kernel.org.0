Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1F521ABD
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbiEJODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245161AbiEJOC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87E52DFF6C;
        Tue, 10 May 2022 06:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 294F4B81D7A;
        Tue, 10 May 2022 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92960C385C2;
        Tue, 10 May 2022 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190019;
        bh=+CdKEBrJOZ14N3GaTYo8fVIQEL64bR5Zsspbwf4pWUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU58wQ+TpkcuSpBBIy9s50BMYym3e0BKVM6s6TQkmyon0OFl2yPRgMyMzpIppD3Un
         aSB8div0HppwMniOJu/Vg8+SCbVB5z+Dq6fUFF81K+qrpj2Fk5/CjYgumA5752LUc0
         ozRRrn56kcagaGa9eI/gaR11amBSyu0z9wfWw+cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 085/140] net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
Date:   Tue, 10 May 2022 15:07:55 +0200
Message-Id: <20220510130744.041391285@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -2224,6 +2224,7 @@ mt7530_setup(struct dsa_switch *ds)
 				ret = of_get_phy_mode(mac_np, &interface);
 				if (ret && ret != -ENODEV) {
 					of_node_put(mac_np);
+					of_node_put(phy_node);
 					return ret;
 				}
 				id = of_mdio_parse_addr(ds->dev, phy_node);


