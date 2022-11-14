Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD84C627EF7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiKNMx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbiKNMx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7418167C6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 543B961154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEC8C433C1;
        Mon, 14 Nov 2022 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430435;
        bh=GhzLSSC35EB6UI8NYCP4ZuJIUXjmSvdhVUAqNnH1OkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQM4dHcOaNemQ6btgerSkBwTFcLVrosV3mo0WQwRanVJD/Xj3xcciTtnT/vy2zEpG
         PnDl4+LJ/Ega0lDA2r8/3O/aPYEDHBlyA8QqOkWGcT+CzDJPCFLNOOgdceWpwKLvBL
         qAEhHwpEims/L5xC9LhxBpRnfLOeQAFaWPXJRweg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/131] macsec: clear encryption keys from the stack after setting up offload
Date:   Mon, 14 Nov 2022 13:44:56 +0100
Message-Id: <20221114124449.826666025@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit aaab73f8fba4fd38f4d2617440d541a1c334e819 ]

macsec_add_rxsa and macsec_add_txsa copy the key to an on-stack
offloading context to pass it to the drivers, but leaves it there when
it's done. Clear it with memzero_explicit as soon as it's not needed
anymore.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index af9b5eaf5b94..4811bd1f3d74 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1820,6 +1820,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -2062,6 +2063,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
-- 
2.35.1



