Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7391A59DF0F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357904AbiHWLRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357323AbiHWLPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:15:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2963EB95B0;
        Tue, 23 Aug 2022 02:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 134856121F;
        Tue, 23 Aug 2022 09:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D82C433C1;
        Tue, 23 Aug 2022 09:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246331;
        bh=KTHkY+Sh3wrd/pSN6IT6Z3SVXzYTUQtNiLHtrjVgw5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSQs4UPgude+a/dHmTWG+fBjFDqJMn1BBrSnxL/SC2G/6H48wBOFnLOqhk1v/nFsb
         6dotiz/Iq1PQM6Gv/AWIiIUKBWoGB/5VPIecOY3LCMlAlx4j0EKYhPLMRpWEzYH+RL
         v9zJyrJbQ/fewRULCxhbrLq5R2pg6GKYuKPBlIXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/389] ARM: bcm: Fix refcount leak in bcm_kona_smc_init
Date:   Tue, 23 Aug 2022 10:22:34 +0200
Message-Id: <20220823080118.830754665@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 541e850a736c..9175c130967e 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -54,6 +54,7 @@ int __init bcm_kona_smc_init(void)
 		return -ENODEV;
 
 	prop_val = of_get_address(node, 0, &prop_size, NULL);
+	of_node_put(node);
 	if (!prop_val)
 		return -EINVAL;
 
-- 
2.35.1



