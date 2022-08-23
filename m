Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3457059D5A0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243130AbiHWI1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244293AbiHWI0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:26:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FCE72FFB;
        Tue, 23 Aug 2022 01:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5167CE1B35;
        Tue, 23 Aug 2022 08:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFA3C433C1;
        Tue, 23 Aug 2022 08:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242453;
        bh=71pQm5UX7KUdV3OYns4yypzPi12FmpAs/Vlutlh9J9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FC2nS6fjQhptsuZbmhQYUXNumaLWcE7xU9F3yOOYZfOx1bhaVWwEqnjSegdt71cdd
         X1KjgJJR9MVKxF5hGbOkpE26mZhEQCwJoYWuO5Nu2EeJV6P/RfsPMb2e1AAVmtj6Dn
         frX3ZY1F2zooNo976NEo2JIvs853X6GLVhQxrZ9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 117/365] octeontx2-af: Fix mcam entry resource leak
Date:   Tue, 23 Aug 2022 10:00:18 +0200
Message-Id: <20220823080123.101243885@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -2564,6 +2564,12 @@ static void __rvu_flr_handler(struct rvu
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


