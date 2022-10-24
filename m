Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F2160A798
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbiJXMxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiJXMvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE112101C2;
        Mon, 24 Oct 2022 05:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABD8612FE;
        Mon, 24 Oct 2022 12:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8F9C433C1;
        Mon, 24 Oct 2022 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613529;
        bh=QbdfTwb918X465SnDLFPDScYTGIArpwH5oy7h7MXV6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Epd8wVYdZAH4ZD2mICilEUKvz51CoGKyG9A7BF9fGGiR7DCGFna4mhOy12HZlzr2h
         nxYb/Z/t86K0x0NeaFH3xt+lh3+f8gNPpFjTxskcT4oJNzDrRuc7mcjWZPbhmm1kas
         tbNZcngOTQhJjBXyc+qr+PAFuH0xuodvm/7eN1g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.4 172/255] powerpc/pci_dn: Add missing of_node_put()
Date:   Mon, 24 Oct 2022 13:31:22 +0200
Message-Id: <20221024113008.507791202@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 110a1fcb6c4d55144d8179983a475f17a1d6f832 ]

In pci_add_device_node_info(), use of_node_put() to drop the reference
to 'parent' returned by of_get_parent() to keep refcount balance.

Fixes: cca87d303c85 ("powerpc/pci: Refactor pci_dn")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/r/20220701131750.240170-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/pci_dn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index d876eda92609..d28433f0fc8e 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -325,6 +325,7 @@ struct pci_dn *pci_add_device_node_info(struct pci_controller *hose,
 	INIT_LIST_HEAD(&pdn->list);
 	parent = of_get_parent(dn);
 	pdn->parent = parent ? PCI_DN(parent) : NULL;
+	of_node_put(parent);
 	if (pdn->parent)
 		list_add_tail(&pdn->list, &pdn->parent->child_list);
 
-- 
2.35.1



