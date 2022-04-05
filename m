Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CEB4F30B6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbiDEIoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241240AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729E95FE7;
        Tue,  5 Apr 2022 01:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F9B260FF5;
        Tue,  5 Apr 2022 08:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2066AC385A2;
        Tue,  5 Apr 2022 08:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147415;
        bh=W5KT8gJMhEm4bt1ufYnqIkD9RSkVG+G0ErDT+4VMW4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01F8xcqDx6AMbu6X9FjLNf8QKXt2HzY7JGVgxG5rnQLinwpW93e6lbk5K/JHYRg9l
         pFtwpZ9Zotm0+9eumjqlOXO20MQ2ZHHuh+D4y+HtxZe8+PcldTz8Lye8QlMLccQR1R
         WD9zOyRLq5mpFgaf0pTqfDMTfs+/1kwcrqrmj7yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.17 1115/1126] ice: xsk: Fix indexing in ice_tx_xsk_pool()
Date:   Tue,  5 Apr 2022 09:31:02 +0200
Message-Id: <20220405070440.159433907@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 1ac2524de7b366633fc336db6c94062768d0ab03 upstream.

Ice driver tries to always create XDP rings array to be
num_possible_cpus() sized, regardless of user's queue count setting that
can be changed via ethtool -L for example.

Currently, ice_tx_xsk_pool() calculates the qid by decrementing the
ring->q_index by the count of XDP queues, but ring->q_index is set to 'i
+ vsi->alloc_txq'.

When user did ethtool -L $IFACE combined 1, alloc_txq is 1, but
vsi->num_xdp_txq is still num_possible_cpus(). Then, ice_tx_xsk_pool()
will do OOB access and in the final result ring would not get xsk_pool
pointer assigned. Then, each ice_xsk_wakeup() call will fail with error
and it will not be possible to get into NAPI and do the processing from
driver side.

Fix this by decrementing vsi->alloc_txq instead of vsi->num_xdp_txq from
ring-q_index in ice_tx_xsk_pool() so the calculation is reflected to the
setting of ring->q_index.

Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220328142123.170157-5-maciej.fijalkowski@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -712,7 +712,7 @@ static inline struct xsk_buff_pool *ice_
 	struct ice_vsi *vsi = ring->vsi;
 	u16 qid;
 
-	qid = ring->q_index - vsi->num_xdp_txq;
+	qid = ring->q_index - vsi->alloc_txq;
 
 	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;


