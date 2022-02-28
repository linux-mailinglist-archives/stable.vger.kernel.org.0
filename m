Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D14C7603
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiB1R7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiB1R4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:56:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AC9546BA;
        Mon, 28 Feb 2022 09:44:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4477760A37;
        Mon, 28 Feb 2022 17:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58510C340E7;
        Mon, 28 Feb 2022 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070283;
        bh=K9tql5DE+JX3H7amGKNF26rUuAB9hl4GAusaWoARLts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eP5fZwR15MeulroG8iaU2Twh8VYRWpf6MurTk+Nj8esgh6ctnlVqamGMsOVH7VFg/
         Ucar4EC6aRWCYMRdlqY/A5U7H7MraqxP7QX8H57c1DS1RfjKVy2TIgMMQwZDTvGNSa
         n4lRt4rRn2SfUkQ9MyUchIJFye/tqxpwTx4LDKC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.16 051/164] ice: fix setting l4 port flag when adding filter
Date:   Mon, 28 Feb 2022 18:23:33 +0100
Message-Id: <20220228172404.822334067@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

commit 932645c298c41aad64ef13016ff4c2034eef5aed upstream.

Accidentally filter flag for none encapsulated l4 port field is always
set. Even if user wants to add encapsulated l4 port field.

Remove this unnecessary flag setting.

Fixes: 9e300987d4a81 ("ice: VXLAN and Geneve TC support")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -711,7 +711,7 @@ ice_tc_set_port(struct flow_match_ports
 			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT;
 		else
 			fltr->flags |= ICE_TC_FLWR_FIELD_DEST_L4_PORT;
-		fltr->flags |= ICE_TC_FLWR_FIELD_DEST_L4_PORT;
+
 		headers->l4_key.dst_port = match.key->dst;
 		headers->l4_mask.dst_port = match.mask->dst;
 	}
@@ -720,7 +720,7 @@ ice_tc_set_port(struct flow_match_ports
 			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_SRC_L4_PORT;
 		else
 			fltr->flags |= ICE_TC_FLWR_FIELD_SRC_L4_PORT;
-		fltr->flags |= ICE_TC_FLWR_FIELD_SRC_L4_PORT;
+
 		headers->l4_key.src_port = match.key->src;
 		headers->l4_mask.src_port = match.mask->src;
 	}


