Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8D5408D7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347650AbiFGSCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349300AbiFGR7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9126E122967;
        Tue,  7 Jun 2022 10:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D92B60BC6;
        Tue,  7 Jun 2022 17:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78696C34115;
        Tue,  7 Jun 2022 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623703;
        bh=UY9S+VuGqXcFpdEttQ2qEq4LET/6/O6BZwZargR5xLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KHJQs2eHmAcjjxPAb4w0NJQ/jpPnKcaxKHPFaVhQwSJ6Gfc9IIub6ccsTlHmg4RC
         5fOGGwKnNu1lSCZ8HzuGIN3FKg/NjRfYKGZUe/0tGV8DQW7kvSZF0QrKNEJFJtmPcS
         MwcKLa3VOAPshaoA1kMUNmqXxL6c+0KLWuQ/8UTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haowen Bai <baihaowen@meizu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/667] sfc: ef10: Fix assigning negative value to unsigned variable
Date:   Tue,  7 Jun 2022 18:55:26 +0200
Message-Id: <20220607164936.643418607@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit b8ff3395fbdf3b79a99d0ef410fc34c51044121e ]

fix warning reported by smatch:
251 drivers/net/ethernet/sfc/ef10.c:2259 efx_ef10_tx_tso_desc()
warn: assigning (-208) to unsigned variable 'ip_tot_len'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/1649640757-30041-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index f5a4d8f4fd11..c1cd1c97f09d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2256,7 +2256,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	 * guaranteed to satisfy the second as we only attempt TSO if
 	 * inner_network_header <= 208.
 	 */
-	ip_tot_len = -EFX_TSO2_MAX_HDRLEN;
+	ip_tot_len = 0x10000 - EFX_TSO2_MAX_HDRLEN;
 	EFX_WARN_ON_ONCE_PARANOID(mss + EFX_TSO2_MAX_HDRLEN +
 				  (tcp->doff << 2u) > ip_tot_len);
 
-- 
2.35.1



