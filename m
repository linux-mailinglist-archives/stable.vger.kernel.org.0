Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66874FD0EF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350767AbiDLG4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351403AbiDLGxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B703BA5D;
        Mon, 11 Apr 2022 23:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EAA60A6A;
        Tue, 12 Apr 2022 06:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D14CC385A6;
        Tue, 12 Apr 2022 06:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745627;
        bh=ceuZB43P3gznOIMJ1ac94fowj66kFvngyDn8duaS0J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrTzcxH5CKA6A9Ml5j0v1IgvXVs7iMYvk8NDAmRUJJNlDPKzSHBh3J7A8B9Ze3F7X
         ePkVX7DkoZFsmVL29alNCnhEGDkmLGOHW5wTZFmBLxucqzo3FhkA7Gf2FA2L3klcal
         lioooI1zbALkpGYdUhVSGVsPedwwbsulzkUeBYKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/171] qede: confirm skb is allocated before using
Date:   Tue, 12 Apr 2022 08:30:13 +0200
Message-Id: <20220412062931.415031684@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit 4e910dbe36508654a896d5735b318c0b88172570 ]

qede_build_skb() assumes build_skb() always works and goes straight
to skb_reserve(). However, build_skb() can fail under memory pressure.
This results in a kernel panic because the skb to reserve is NULL.

Add a check in case build_skb() failed to allocate and return NULL.

The NULL return is handled correctly in callers to qede_build_skb().

Fixes: 8a8633978b842 ("qede: Add build_skb() support.")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 21c906200e79..d210632676d3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -752,6 +752,9 @@ qede_build_skb(struct qede_rx_queue *rxq,
 	buf = page_address(bd->data) + bd->page_offset;
 	skb = build_skb(buf, rxq->rx_buf_seg_size);
 
+	if (unlikely(!skb))
+		return NULL;
+
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
 
-- 
2.35.1



