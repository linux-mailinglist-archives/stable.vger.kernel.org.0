Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA4559DA3C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352005AbiHWKGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243465AbiHWKFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E1A262D;
        Tue, 23 Aug 2022 01:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 754286123D;
        Tue, 23 Aug 2022 08:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749F7C433D6;
        Tue, 23 Aug 2022 08:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244715;
        bh=j77QJl1TcNYkGHqZiSjCkKoxYzy27qIOtLmaK1Cnxb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWCKcINgZ+uizg6URZOvVOhbgAZKlpFWr3/EvbdJEMRYpxFpWQEAH0+D9kHL5wTBJ
         rdNLliWJHKSGLR3UYd4iuLREs7tbg24yhirINbSRmpj51rHgWD9Sw5EslWgwwnI9vl
         jgSXAFrugGWEQ+FFTpPAtDgcvTjSSbGwfeOONc0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 138/244] net: fix potential refcount leak in ndisc_router_discovery()
Date:   Tue, 23 Aug 2022 10:24:57 +0200
Message-Id: <20220823080103.755618325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit 7396ba87f1edf549284869451665c7c4e74ecd4f upstream.

The issue happens on specific paths in the function. After both the
object `rt` and `neigh` are grabbed successfully, when `lifetime` is
nonzero but the metric needs change, the function just deletes the
route and set `rt` to NULL. Then, it may try grabbing `rt` and `neigh`
again if above conditions hold. The function simply overwrite `neigh`
if succeeds or returns if fails, without decreasing the reference
count of previous `neigh`. This may result in memory leaks.

Fix it by decrementing the reference count of `neigh` in place.

Fixes: 6b2e04bc240f ("net: allow user to set metric on default route learned via Router Advertisement")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ndisc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1317,6 +1317,9 @@ static void ndisc_router_discovery(struc
 	if (!rt && lifetime) {
 		ND_PRINTK(3, info, "RA: adding default router\n");
 
+		if (neigh)
+			neigh_release(neigh);
+
 		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
 					 skb->dev, pref, defrtr_usr_metric);
 		if (!rt) {


