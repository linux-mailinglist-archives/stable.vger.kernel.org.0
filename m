Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840025053D8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbiDRNBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiDRM6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2610A24F30;
        Mon, 18 Apr 2022 05:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F90FCE10AF;
        Mon, 18 Apr 2022 12:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C12C385A1;
        Mon, 18 Apr 2022 12:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285514;
        bh=JQnow2SOT802oNKrq1lbJ5cGXDWXQkeciol61Csm9AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FH2w2omKBKUH9XGk2a4iH1XxIBrvv14eNjqAimMuQbXjPtnCbVM9kvgJL7LFd3+Yg
         HDxe6+M91eZKeBvbkL3gVliVW4wi5u9nvcDh493IdN0UMt9i91jgl2ellz7TP+BRbD
         qphU7e3OaGgMAkNHgL/L7sRyoqHhJPRG9f72Y1Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/105] net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"
Date:   Mon, 18 Apr 2022 14:12:43 +0200
Message-Id: <20220418121147.644952639@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 2df3fc4a84e917a422935cc5bae18f43f9955d31 ]

It turns out after digging deeper into this bug, that it was being
triggered by GCC12 failing to call the bcmgenet_enable_dma()
routine. Given that a gcc12 fix has been merged [1] and the genet
driver now works properly when built with gcc12, this commit should
be reverted.

[1]
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105160
https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=aabb9a261ef060cf24fd626713f1d7d9df81aa57

Fixes: 8d3ea3d402db ("net: bcmgenet: Use stronger register read/writes to assure ordering")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220412210420.1129430-1-jeremy.linton@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 7dcd5613ee56..a2062144d7ca 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -76,7 +76,7 @@ static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		__raw_writel(value, offset);
 	else
-		writel(value, offset);
+		writel_relaxed(value, offset);
 }
 
 static inline u32 bcmgenet_readl(void __iomem *offset)
@@ -84,7 +84,7 @@ static inline u32 bcmgenet_readl(void __iomem *offset)
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		return __raw_readl(offset);
 	else
-		return readl(offset);
+		return readl_relaxed(offset);
 }
 
 static inline void dmadesc_set_length_status(struct bcmgenet_priv *priv,
-- 
2.35.1



