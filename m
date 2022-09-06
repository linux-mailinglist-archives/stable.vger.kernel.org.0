Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80B55AECEA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbiIFOC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiIFOBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE992720;
        Tue,  6 Sep 2022 06:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C6DA6154A;
        Tue,  6 Sep 2022 13:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CF5C433D6;
        Tue,  6 Sep 2022 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471793;
        bh=8qNxysi4JFpH/cVZhgEkyhnyAzErsC9knToOeJgwz7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2d9XwENVjIj7QqT5byz4F5H0eybsiemT/yPNeS5+fFX+lKLzUPqCCZUeTK7nN/iEx
         +PaMcuI5JQ2brvB3OzkbRWJvBH3At0XYaj0Qu8Ie+n/c0PRXSU9fYWrG57oc5bij/K
         b0KqWfluBdy1HEXVvv2OF6jYzb+GEa/DYlEas8lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casper Andersson <casper.casan@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 033/155] net: sparx5: fix handling uneven length packets in manual extraction
Date:   Tue,  6 Sep 2022 15:29:41 +0200
Message-Id: <20220906132830.825331642@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit 7498a457ecf7ff2c4d379360aa8f24566bb1543e ]

Packets that are not of length divisible by 4 (e.g. 77, 78, 79) would
have the checksum included up to next multiple of 4 (a 77 bytes packet
would have 3 bytes of ethernet checksum included). The check for the
value expects it in host (Little) endian.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220825084955.684637-1-casper.casan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 304f84aadc36b..21844beba72df 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -113,6 +113,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 			/* This assumes STATUS_WORD_POS == 1, Status
 			 * just after last data
 			 */
+			if (!byte_swap)
+				val = ntohl((__force __be32)val);
 			byte_cnt -= (4 - XTR_VALID_BYTES(val));
 			eof_flag = true;
 			break;
-- 
2.35.1



