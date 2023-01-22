Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1461E676F78
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjAVPWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjAVPWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C44422794
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC97B80B25
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F950C433EF;
        Sun, 22 Jan 2023 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400901;
        bh=YF6YY0iHFdfr/hG0roWqPe4eYWlqhRj8kIVzdzc4Ql0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB4rrGnX54PYEgrHTwr/EAzMaMpJJuAo7KFwJJjyIWYdrdQUTAFGrou6WxdXkCLk8
         iw+HADjj33dFL+Z8OFGiQodyLIMFI4GHeHFHuJG6XZyGmvFaK7+3mcs8Lz+ABKBOsL
         CwLUNayChpKpYPlCda1a5ab1g4knJI1n8WeAUQY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anuradha Weeraman <anuradha@debian.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/193] net: ethernet: marvell: octeontx2: Fix uninitialized variable warning
Date:   Sun, 22 Jan 2023 16:02:15 +0100
Message-Id: <20230122150246.658257530@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Anuradha Weeraman <anuradha@debian.org>

[ Upstream commit d3805695fe1e7383517903715cefc9bbdcffdc90 ]

Fix for uninitialized variable warning.

Addresses-Coverity: ("Uninitialized scalar variable")
Signed-off-by: Anuradha Weeraman <anuradha@debian.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index fa8029a94068..eb25e458266c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -589,7 +589,7 @@ int rvu_mbox_handler_mcs_free_resources(struct rvu *rvu,
 	u16 pcifunc = req->hdr.pcifunc;
 	struct mcs_rsrc_map *map;
 	struct mcs *mcs;
-	int rc;
+	int rc = 0;
 
 	if (req->mcs_id >= rvu->mcs_blk_cnt)
 		return MCS_AF_ERR_INVALID_MCSID;
-- 
2.35.1



