Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D35592160
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbiHNPgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbiHNPft (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7B21D316;
        Sun, 14 Aug 2022 08:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A97EB80B27;
        Sun, 14 Aug 2022 15:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45947C433D7;
        Sun, 14 Aug 2022 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491070;
        bh=0LLFBfOKHFPod6bxQlh8610jSWOZ/Fs0Wgi1kYBiWWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuWRmyqlXwSomOybSKOh5Lwjoy1582G7l04/6rGY2a3YNPmh5Q+2K+6H3vv++S58L
         t1PkjWbsK2PFN33DUI4LX9UpS5p42ZSaocZmOtQ2NbsB7XbU5zLTTN9yxTfbX73QmV
         Gvzg82TWF/zS8yNV+Hj3oc6Q8WJITDN08nQ/BXmr292mObaFLBuYZUenfoTJJHCepS
         66uSAKJbiQKsmv1GBEDTGYqZfJEjRJc1/aYAyOVe9xV3IlSqus3ITZ2iLzApTBOlXX
         Q2RZYstgnOKyQAi+2IL2f0L2Td6ZFFLZKKSSQubKWFvujJzd4oc/k71iNM7ewRSwWE
         4D7R0EVVNb1AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 16/56] usb: host: ohci-ppc-of: Fix refcount leak bug
Date:   Sun, 14 Aug 2022 11:29:46 -0400
Message-Id: <20220814153026.2377377-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 40a959d7042bb7711e404ad2318b30e9f92c6b9b ]

In ohci_hcd_ppc_of_probe(), of_find_compatible_node() will return
a node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220617034637.4003115-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-ppc-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 45f7cceb6df3..98e46725999e 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -169,6 +169,7 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
 				release_mem_region(res.start, 0x4);
 		} else
 			pr_debug("%s: cannot get ehci offset from fdt\n", __FILE__);
+		of_node_put(np);
 	}
 
 	irq_dispose_mapping(irq);
-- 
2.35.1

