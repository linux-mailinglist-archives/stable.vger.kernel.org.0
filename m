Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38255936EA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbiHOSgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbiHOSgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:36:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F2F3B960;
        Mon, 15 Aug 2022 11:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2029DB80F99;
        Mon, 15 Aug 2022 18:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E422C433C1;
        Mon, 15 Aug 2022 18:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587773;
        bh=4za+avW1T/NnoFjLu6YyZVhW3X3P6uxrYzP7gGEKha0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3uShlJNexBGSpRt1BD8sqKfWIkQwVmzN2sfDzvCf0oVADWeGcsXIeTiFw8btRSMR
         M1nhzsBf81vXlq2KBO5oKck/Cf4v2yZDs7Fg6Uo6Km4CyWcyvGBfKtOJ3KMpBtJftf
         p1ZXcmuIUMEm5OTVX4tKmgpxVBqD8/9bFEphxN+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/779] ARM: bcm: Fix refcount leak in bcm_kona_smc_init
Date:   Mon, 15 Aug 2022 19:56:43 +0200
Message-Id: <20220815180344.152497709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit cb23389a2458c2e4bfd6c86a513cbbe1c4d35e76 ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: b8eb35fd594a ("ARM: bcm281xx: Add L2 cache enable code")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index 43829e49ad93..347bfb7f03e2 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -52,6 +52,7 @@ int __init bcm_kona_smc_init(void)
 		return -ENODEV;
 
 	prop_val = of_get_address(node, 0, &prop_size, NULL);
+	of_node_put(node);
 	if (!prop_val)
 		return -EINVAL;
 
-- 
2.35.1



