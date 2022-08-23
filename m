Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7259D961
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbiHWJxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241181AbiHWJvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21DE9F1A4;
        Tue, 23 Aug 2022 01:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D55F2614E9;
        Tue, 23 Aug 2022 08:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB3BC433C1;
        Tue, 23 Aug 2022 08:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244329;
        bh=AOk+oevlxIEWe26QrP0aZwFVPDWgUz50rIsB56MoIl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP0TJXniWO+nAodBRPqbOs070VEu0Y11MsqFDSPlXEsXwV0z4ueSi0lHaLbGgOJD9
         54ijxR6t6zhXhs5l/qiGUqES2dr13H3nOucxjoUIQHuFrAat2FQQJm30goUole71r1
         nwGoWwD9B5rvbLBTnYEosU/d4H6ylOKXyAJ3WDy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 074/244] octeontx2-af: Fix key checking for source mac
Date:   Tue, 23 Aug 2022 10:23:53 +0200
Message-Id: <20220823080101.530596409@linuxfoundation.org>
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

commit c3c290276927a3ae79342a4e17ec0500c138c63a upstream.

Given a field with its location/offset in input packet,
the key checking logic verifies whether extracting the
field can be supported or not based on the mkex profile
loaded in hardware. This logic is wrong wrt source mac
and this patch fixes that.

Fixes: 9b179a960a96 ("octeontx2-af: Generate key field bit mask from KEX profile")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -445,7 +445,8 @@ do {									       \
 	NPC_SCAN_HDR(NPC_VLAN_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 2, 2);
 	NPC_SCAN_HDR(NPC_VLAN_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 2, 2);
 	NPC_SCAN_HDR(NPC_DMAC, NPC_LID_LA, la_ltype, la_start, 6);
-	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start, 6);
+	/* SMAC follows the DMAC(which is 6 bytes) */
+	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start + 6, 6);
 	/* PF_FUNC is 2 bytes at 0th byte of NPC_LT_LA_IH_NIX_ETHER */
 	NPC_SCAN_HDR(NPC_PF_FUNC, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 0, 2);
 }


