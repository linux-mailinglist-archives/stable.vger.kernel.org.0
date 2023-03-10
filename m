Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B56B4A1C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjCJPTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbjCJPSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:18:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148713F1AC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33414B822E3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611ABC433EF;
        Fri, 10 Mar 2023 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460979;
        bh=GyjC6RuYu+fA84S+Esm5qD9WEZ5NLZCfPGgsMUEzBrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCRLKuyq4n9PXyfGe14bblLgnWjc2X68xiGAHgG2XuX/GsIHO5VwFufeeXFdvIAYg
         XwOH+g1wCNSEc2bso4LlVrPlUv6l+PyBA0wioGu2gFCxQUaqI0pjNAuAmWHLzgoFa9
         uEfs53Tst9/wA0AdDoS2DTIZ/L1z+5SPS7qmLav8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lyude Paul <lyude@redhat.com>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.10 516/529] drm/display/dp_mst: Fix down/up message handling after sink disconnect
Date:   Fri, 10 Mar 2023 14:40:59 +0100
Message-Id: <20230310133828.733606521@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 1d082618bbf3b6755b8cc68c0a8122af2842d593 upstream.

If the sink gets disconnected during receiving a multi-packet DP MST AUX
down-reply/up-request sideband message, the state keeping track of which
packets have been received already is not reset. This results in a failed
sanity check for the subsequent message packet received after a sink is
reconnected (due to the pending message not yet completed with an
end-of-message-transfer packet), indicated by the

"sideband msg set header failed"

error.

Fix the above by resetting the up/down message reception state after a
disconnect event.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3769,6 +3769,9 @@ int drm_dp_mst_topology_mgr_set_mst(stru
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:


