Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB8627F34
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbiKNM4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiKNM4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:56:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DCF27FC3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E48326117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACA2C433C1;
        Mon, 14 Nov 2022 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430589;
        bh=6wZbWtX0447m3dqN179O85Iu8PadKz4h4y/HDJ8kDI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUccJQR45jTAYNZ+67fw3IAh/Fk66ew5VQ3G6Ji+p0B38O46QKePTWRD9rmi1MkgT
         IE5EZxDHyoRyVRORvaKyweGGJWErQfV8YiVgx+8zcWuhmDZkeKDJ4DDRpzqjGNlWwi
         GKvXyy+5q1NzSq+wsrDtzK/jAB13WOIEqliWKrqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Antoine Tenart <atenart@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/131] net: phy: mscc: macsec: clear encryption keys when freeing a flow
Date:   Mon, 14 Nov 2022 13:45:42 +0100
Message-Id: <20221114124451.806343783@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1b16b3fdf675cca15a537572bac50cc5354368fc ]

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the MSCC PHY driver made a copy, kept
it in the flow data and did not clear it when freeing a flow. Fix this.

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..c00eef457b85 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -632,6 +632,7 @@ static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
 
 	list_del(&flow->list);
 	clear_bit(flow->index, bitmap);
+	memzero_explicit(flow->key, sizeof(flow->key));
 	kfree(flow);
 }
 
-- 
2.35.1



