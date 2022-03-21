Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DC4E2896
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348385AbiCUOAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348973AbiCUN6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4BF1717A9;
        Mon, 21 Mar 2022 06:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CED88B816D2;
        Mon, 21 Mar 2022 13:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD0C340E8;
        Mon, 21 Mar 2022 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871012;
        bh=rTpAFxWKjUXl+FS6u1hAIHGN6xs3GKhIshiVpQ53tVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Irc7t7SrXzQ0UNxCyDTNR1BQSkhPNXjy3IbFiqrI2NzqfDOboxVERMh1wCgQEUnGG
         rWbCA9JWLFmZrWADrWfqJYeF8z/NCkv9NDDLKo8BA9UaUrMjXbctUBIn6QMYJxk1PF
         eKK6F83G0WDTV7fjKHWHHqPQf29xOzYgifj7InGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/57] hv_netvsc: Add check for kvmalloc_array
Date:   Mon, 21 Mar 2022 14:52:31 +0100
Message-Id: <20220321133223.437365137@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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
index 2dff0e110c6f..f094e4bc2175 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1454,6 +1454,9 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
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



