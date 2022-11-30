Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B063DE9D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiK3Siz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiK3Siy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:38:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A433B8DBF7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63879B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC67EC433D6;
        Wed, 30 Nov 2022 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833531;
        bh=HQwCJLIpa+UTjRE/4mBilibo/hWHMgGAAJkS4/0TCXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXcvpK47cduPSRoXqSlwWiC7iXPgP0qAiARssdmQPhjCp0JIgQoDxuZQGWmKX0zyC
         CMjSzmvhUShzH09t2oDUKozANR5+dW0NdRkZOj1O48XBv3g44POTq7FBu4p49uCEwd
         Ato2xSCpn5Zg4WiT5oJOzfzPHGB8lE8e4jiIcZ+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/206] octeontx2-pf: Add check for devm_kcalloc
Date:   Wed, 30 Nov 2022 19:23:02 +0100
Message-Id: <20221130180536.351863253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit cd07eadd5147ffdae11b6fd28b77a3872f2a2484 ]

As the devm_kcalloc may return NULL pointer,
it should be better to add check for the return
value, as same as the others.

Fixes: e8e095b3b370 ("octeontx2-af: cn10k: Bandwidth profiles config support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20221122055449.31247-1-jiasheng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 603361c94786..09892703cfd4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4832,6 +4832,8 @@ static int nix_setup_ipolicers(struct rvu *rvu,
 		ipolicer->ref_count = devm_kcalloc(rvu->dev,
 						   ipolicer->band_prof.max,
 						   sizeof(u16), GFP_KERNEL);
+		if (!ipolicer->ref_count)
+			return -ENOMEM;
 	}
 
 	/* Set policer timeunit to 2us ie  (19 + 1) * 100 nsec = 2us */
-- 
2.35.1



