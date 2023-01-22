Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6718676F87
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjAVPWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjAVPWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CB022A31
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F54760C6C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9D4C4339B;
        Sun, 22 Jan 2023 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400942;
        bh=2/VxAlbDBkwroZULXPCKWS/TCjOshSK7oQu0RH2N018=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXvD/raGVtKGrM58HWdq2hwjv+g2SsIi9SuxetzUX4RgMOFP/7zXaWtE8pq8MWf5C
         gRyNoAd9vhv+BpC1jjbGcRZvwUy2iD0UE5AHalGqbOhnjQ3JFWxj0sfvWlRcaAayV4
         aCEIpiOE15OXWUZJainVmc3ZUCovP2MHtuwI6lfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 050/193] xhci-pci: set the dma max_seg_size
Date:   Sun, 22 Jan 2023 16:02:59 +0100
Message-Id: <20230122150248.640386551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit 93915a4170e9defd56a767a18e6c4076f3d18609 upstream.

Allow devices to have dma operations beyond 64K, and avoid warnings such
as:

xhci_hcd 0000:00:14.0: mapping sg segment longer than device claims to support [len=98304] [max=65536]

Cc: stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -455,6 +455,8 @@ static int xhci_pci_probe(struct pci_dev
 	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:


