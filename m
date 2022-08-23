Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC8E59E37B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiHWMWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356909AbiHWMVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:21:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5944174353;
        Tue, 23 Aug 2022 02:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA931CE1B58;
        Tue, 23 Aug 2022 09:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E31C433D7;
        Tue, 23 Aug 2022 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247764;
        bh=0LLFBfOKHFPod6bxQlh8610jSWOZ/Fs0Wgi1kYBiWWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFnzRLl66/ORGQVQwOz+hYp5PvxyanGIhywxccFmMB9ZAlvvtJbHIFBb7932GCWLp
         Jm2nQSDAuqMGmpysBcbx0KLhdRN3mvGYOjZjBYFnZm3RfYZBKjfWhBB43p1Et4Iu9/
         PWZMMf7ogd8voTMJx4uKRTqxthSNmFFYJrK4MtWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Liang He <windhl@126.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/158] usb: host: ohci-ppc-of: Fix refcount leak bug
Date:   Tue, 23 Aug 2022 10:27:21 +0200
Message-Id: <20220823080050.366332656@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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



