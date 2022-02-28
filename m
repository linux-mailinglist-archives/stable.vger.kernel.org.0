Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D774C750E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbiB1Ruk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbiB1Rtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:49:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C40A27A4;
        Mon, 28 Feb 2022 09:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E3FE6153C;
        Mon, 28 Feb 2022 17:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C58C340E7;
        Mon, 28 Feb 2022 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069940;
        bh=lVHnA//5woBoMJ5L8fgPW5iSU8JhzmkqiRQTv0NQwlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlPGv5T9ZmRJO3U2yX1LWgyX6ePHtUPO/mqfkVcCgenRHqbapXhV8U+qtIaDLznhk
         I3sjUUazJ1jr9ePMcfPNPTVaZK3w48msR2iP7+dcIFjm0BckO7oKESprV+4zXk+pRV
         TT1FTpMz5U5qJn+akqRwYVPYbR74vo1ZbNn7HyRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 067/139] net: ll_temac: check the return value of devm_kmalloc()
Date:   Mon, 28 Feb 2022 18:24:01 +0100
Message-Id: <20220228172354.744362737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

commit b352c3465bb808ab700d03f5bac2f7a6f37c5350 upstream.

devm_kmalloc() returns a pointer to allocated memory on success, NULL
on failure. While lp->indirect_lock is allocated by devm_kmalloc()
without proper check. It is better to check the value of it to
prevent potential wrong memory access.

Fixes: f14f5c11f051 ("net: ll_temac: Support indirect_mutex share within TEMAC IP")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1427,6 +1427,8 @@ static int temac_probe(struct platform_d
 		lp->indirect_lock = devm_kmalloc(&pdev->dev,
 						 sizeof(*lp->indirect_lock),
 						 GFP_KERNEL);
+		if (!lp->indirect_lock)
+			return -ENOMEM;
 		spin_lock_init(lp->indirect_lock);
 	}
 


