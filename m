Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B50359DF4E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358719AbiHWL5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359101AbiHWL4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054917DF4C;
        Tue, 23 Aug 2022 02:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B95260F85;
        Tue, 23 Aug 2022 09:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83240C433C1;
        Tue, 23 Aug 2022 09:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247214;
        bh=0LLFBfOKHFPod6bxQlh8610jSWOZ/Fs0Wgi1kYBiWWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoOuNNbLdWURfSDcugxv/+SaXmUeLUdGVrlbx5GAukIzgQG4sPA6MGXHyBMZH57PW
         Ljm/sBOuTfffFmaHhDT9ceu3qVoJ27tu5teEoRPqt13D49ryuJrdDY3umeUTVLQswO
         rBGFmgJGoD3m4VBA4d1EFVs+LmrUBhNK/NptBRxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Liang He <windhl@126.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 354/389] usb: host: ohci-ppc-of: Fix refcount leak bug
Date:   Tue, 23 Aug 2022 10:27:12 +0200
Message-Id: <20220823080130.341726434@linuxfoundation.org>
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



