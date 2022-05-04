Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5771A51A93B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356224AbiEDRMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357038AbiEDRJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466EF4889D;
        Wed,  4 May 2022 09:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BDDAB827C2;
        Wed,  4 May 2022 16:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0EAC385B0;
        Wed,  4 May 2022 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683416;
        bh=SRazH2uyyXomn+ZtPfi6A/TGv9uvTaddlbbFfB3+IhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeNqCzQEBnJzlIzPtDTbuMOgY9enyXH5M2WQ35anVRvnktn4Yj9cX0WtzFdqaThLk
         qYPu1J3T+1i2pkKKJknMjAkD8gMzX99HQ3mjRRwS/uPyMkZyucba9H3E5Dp/gQsgYs
         paQdFckxfibP/EM0ybqb+i4rdBI3UXNqloR6gaQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 101/225] net: dsa: Add missing of_node_put() in dsa_port_link_register_of
Date:   Wed,  4 May 2022 18:45:39 +0200
Message-Id: <20220504153119.734641238@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fc06b2867f4cea543505acfb194c2be4ebf0c7d3 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.
of_node_put() will check for NULL value.

Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1a40c52f5a42..4368fd32c4a5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1240,8 +1240,10 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+			of_node_put(phy_np);
 			return dsa_port_phylink_register(dp);
 		}
+		of_node_put(phy_np);
 		return 0;
 	}
 
-- 
2.35.1



