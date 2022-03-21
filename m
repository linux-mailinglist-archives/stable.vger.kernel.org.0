Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269D84E293F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348780AbiCUOEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349157AbiCUODY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9D0179429;
        Mon, 21 Mar 2022 07:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E1461316;
        Mon, 21 Mar 2022 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4A3C340F5;
        Mon, 21 Mar 2022 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871212;
        bh=h3qbwoc/zH8vYH6OoEHkqCy8EwZ8+5z/AcfDyae0prU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPKeYGROLZaqvnxXcwJUF8zThxRLeBibCZJN4oLS+D7hD5c80EdjcZKrg6t2kllS7
         di6GeyY1+3YMjxMjqoWtG+yUVPt9LnniXg71wAV35giNtrp8wqhzPJsCMK1Y1QuZg1
         cr0xFgSduybKccQMZKeZ6iug8lE6+h9YJS4JKgRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/32] hv_netvsc: Add check for kvmalloc_array
Date:   Mon, 21 Mar 2022 14:52:50 +0100
Message-Id: <20220321133220.975960878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 886e44c9298a6b428ae046e2fa092ca52e822e6a ]

As the potential failure of the kvmalloc_array(),
it should be better to check and restore the 'data'
if fails in order to avoid the dereference of the
NULL pointer.

Fixes: 6ae746711263 ("hv_netvsc: Add per-cpu ethtool stats for netvsc")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220314020125.2365084-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..bdfcf75f0827 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1586,6 +1586,9 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 	pcpu_sum = kvmalloc_array(num_possible_cpus(),
 				  sizeof(struct netvsc_ethtool_pcpu_stats),
 				  GFP_KERNEL);
+	if (!pcpu_sum)
+		return;
+
 	netvsc_get_pcpu_stats(dev, pcpu_sum);
 	for_each_present_cpu(cpu) {
 		struct netvsc_ethtool_pcpu_stats *this_sum = &pcpu_sum[cpu];
-- 
2.34.1



