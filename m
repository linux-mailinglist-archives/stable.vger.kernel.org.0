Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25F559D98D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbiHWJvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351767AbiHWJux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330606E2D9;
        Tue, 23 Aug 2022 01:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21796150F;
        Tue, 23 Aug 2022 08:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E5C433D6;
        Tue, 23 Aug 2022 08:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244323;
        bh=Gw5twUXOvoHjEK0G5Er3C/B887fyZ4ZMAvf9n6M7dVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrHjzJiOp3cZtALkR8wFf1/y8sdIK786jbtLvuhAIchgvUla5bxn0AGvWK7KIeged
         Wx9I08omfe70GXHk78ZOhFkhm+v2x96J27jqVyciR+8Etuaj4tHNd8oeVLdF7LLR0+
         /GXIIn/yP6418hQ1T9AU/7hro8pF0xr0hGOdyBmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 073/244] octeontx2-af: Fix mcam entry resource leak
Date:   Tue, 23 Aug 2022 10:23:52 +0200
Message-Id: <20220823080101.496529284@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

commit 3f8fe40ab7730cf8eb6f8b8ff412012f7f6f8f48 upstream.

The teardown sequence in FLR handler returns if no NIX LF
is attached to PF/VF because it indicates that graceful
shutdown of resources already happened. But there is a
chance of all allocated MCAM entries not being freed by
PF/VF. Hence free mcam entries even in case of detached LF.

Fixes: c554f9c1574e ("octeontx2-af: Teardown NPA, NIX LF upon receiving FLR")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |    6 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2504,6 +2504,12 @@ static void __rvu_flr_handler(struct rvu
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+	/* In scenarios where PF/VF drivers detach NIXLF without freeing MCAM
+	 * entries, check and free the MCAM entries explicitly to avoid leak.
+	 * Since LF is detached use LF number as -1.
+	 */
+	rvu_npc_free_mcam_entries(rvu, pcifunc, -1);
+
 	mutex_unlock(&rvu->flr_lock);
 }
 
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1096,6 +1096,9 @@ static void npc_enadis_default_entries(s
 
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	npc_enadis_default_entries(rvu, pcifunc, nixlf, false);
 
 	/* Delete multicast and promisc MCAM entries */
@@ -1107,6 +1110,9 @@ void rvu_npc_disable_default_entries(str
 
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
 	 * in set_rx_mode mbox handler.
 	 */


