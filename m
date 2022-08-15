Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DFA593717
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245339AbiHOTHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245595AbiHOTFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:05:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF684E63F;
        Mon, 15 Aug 2022 11:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CA41B81072;
        Mon, 15 Aug 2022 18:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77FEC433C1;
        Mon, 15 Aug 2022 18:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588473;
        bh=0e2tt6DrrV1ZWC1oY7l9p4t3b8AMy0FXCj2qQ2cAlz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yn0NA9uHvjU7UbjePtyKQhCWqzQoRSmaV9HT2hO8WJ6FOdY+3tJcH5jUOKnvUM17i
         N0bG/BAlxqC4RTqL9UH9u1VTCyLHdvkDXHZqx9s86JCr6FHyYzyhgwjLZhKuDYl2uV
         EPXKkVNNb24NB0krCzWvRzHRzWMwfHfm0HfvQp/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/779] usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe
Date:   Mon, 15 Aug 2022 20:00:58 +0200
Message-Id: <20220815180354.963152535@linuxfoundation.org>
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

[ Upstream commit b5c5b13cb45e2c88181308186b0001992cb41954 ]

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 796bcae7361c ("USB: powerpc: Workaround for the PPC440EPX USBH_23 errata [take 3]")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220602110849.58549-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-ppc-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 6bbaee74f7e7..28a19693c19f 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -148,6 +148,7 @@ static int ehci_hcd_ppc_of_probe(struct platform_device *op)
 		} else {
 			ehci->has_amcc_usb23 = 1;
 		}
+		of_node_put(np);
 	}
 
 	if (of_get_property(dn, "big-endian", NULL)) {
-- 
2.35.1



