Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9F155D167
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiF0LuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiF0Lsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204B0BF59;
        Mon, 27 Jun 2022 04:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B217861192;
        Mon, 27 Jun 2022 11:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFED4C3411D;
        Mon, 27 Jun 2022 11:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330110;
        bh=viIllrMNqwwOM5W6eSKdS3DEUhpKz86OL8D4zf+4BfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2E4BoDJiX8qJpb265i0hmGLhkyNic70+faB43q2GtmVJX2sw8i+6kNi7GtXb2tPwJ
         JXUGWCIYso8yxuvm4Eg48b/Dx9dxsRuyG7iiWe5Ev5sdF+XkEB6X+HChbdqfbmSbJK
         ak/cuqPJrzuVZgJsu+qLNxB3lKQwADdi7Ad1q47I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 085/181] ice: ignore protocol field in GTP offload
Date:   Mon, 27 Jun 2022 13:20:58 +0200
Message-Id: <20220627111947.025128170@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit d4ea6f6373ef56d1d795a24f1f5874f4a6019199 ]

Commit 34a897758efe ("ice: Add support for inner etype in switchdev")
added the ability to match on inner ethertype. A side effect of that change
is that it is now impossible to add some filters for protocols which do not
contain inner ethtype field. tc requires the protocol field to be specified
when providing certain other options, e.g. src_ip. This is a problem in
case of GTP - when user wants to specify e.g. src_ip, they also need to
specify protocol in tc command (otherwise tc fails with: Illegal "src_ip").
Because GTP is a tunnel, the protocol field is treated as inner protocol.
GTP does not contain inner ethtype field and the filter cannot be added.

To fix this, ignore the ethertype field in case of GTP filters.

Fixes: 9a225f81f540 ("ice: Support GTP-U and GTP-C offload in switchdev")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 3acd9f921c44..734bfa121e24 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -994,7 +994,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		n_proto_key = ntohs(match.key->n_proto);
 		n_proto_mask = ntohs(match.mask->n_proto);
 
-		if (n_proto_key == ETH_P_ALL || n_proto_key == 0) {
+		if (n_proto_key == ETH_P_ALL || n_proto_key == 0 ||
+		    fltr->tunnel_type == TNL_GTPU ||
+		    fltr->tunnel_type == TNL_GTPC) {
 			n_proto_key = 0;
 			n_proto_mask = 0;
 		} else {
-- 
2.35.1



