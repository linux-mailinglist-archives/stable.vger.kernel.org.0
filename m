Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4555650F3F3
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245023AbiDZIaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbiDZI3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:29:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCDF3A5C6;
        Tue, 26 Apr 2022 01:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C574DB81CF6;
        Tue, 26 Apr 2022 08:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3062FC385A4;
        Tue, 26 Apr 2022 08:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961477;
        bh=GYRN8gEHNluHJetTN7qwHBSbp5xnHOcjNQsr6hRA2LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juG99kQaKkVvECZjiFvDTqyxooE8tbLnzIu853S1TRlsDzXtaKEpQJSN3Q6+cH6xm
         P6XA2AXuBc343QVVFu5mJttjIBFIiG+dTVP27NHSh+caksRxQoXVOjDHy8F4A7FGwI
         sYDMDYtmyg42aBTDjx50qbC1RaMP7t2ZWQxRyAPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 23/43] dma: at_xdmac: fix a missing check on list iterator
Date:   Tue, 26 Apr 2022 10:21:05 +0200
Message-Id: <20220426081735.203132279@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 206680c4e46b62fd8909385e0874a36952595b85 upstream.

The bug is here:
	__func__, desc, &desc->tx_dma_desc.phys, ret, cookie, residue);

The list iterator 'desc' will point to a bogus position containing
HEAD if the list is empty or no element is found. To avoid dev_dbg()
prints a invalid address, use a new variable 'iter' as the list
iterator, while use the origin variable 'desc' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 82e2424635f4c ("dmaengine: xdmac: fix print warning on dma_addr_t variable")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327061154.4867-1-xiam0nd.tong@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1390,7 +1390,7 @@ at_xdmac_tx_status(struct dma_chan *chan
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
 	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
-	struct at_xdmac_desc	*desc, *_desc;
+	struct at_xdmac_desc	*desc, *_desc, *iter;
 	struct list_head	*descs_list;
 	enum dma_status		ret;
 	int			residue, retry;
@@ -1505,11 +1505,13 @@ at_xdmac_tx_status(struct dma_chan *chan
 	 * microblock.
 	 */
 	descs_list = &desc->descs_list;
-	list_for_each_entry_safe(desc, _desc, descs_list, desc_node) {
-		dwidth = at_xdmac_get_dwidth(desc->lld.mbr_cfg);
-		residue -= (desc->lld.mbr_ubc & 0xffffff) << dwidth;
-		if ((desc->lld.mbr_nda & 0xfffffffc) == cur_nda)
+	list_for_each_entry_safe(iter, _desc, descs_list, desc_node) {
+		dwidth = at_xdmac_get_dwidth(iter->lld.mbr_cfg);
+		residue -= (iter->lld.mbr_ubc & 0xffffff) << dwidth;
+		if ((iter->lld.mbr_nda & 0xfffffffc) == cur_nda) {
+			desc = iter;
 			break;
+		}
 	}
 	residue += cur_ubc << dwidth;
 


