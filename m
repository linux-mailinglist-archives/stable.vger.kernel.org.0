Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB60A676E37
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjAVPIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjAVPIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683011C30E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0536A60C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17579C433EF;
        Sun, 22 Jan 2023 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400092;
        bh=BycfUCkr70YMcdcGzwP9H86Hq+WAaqFDIhXf6Nx2CDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Erc/kS5c3gSkVNWC5cVW28tE8EDRBV3/lL+TTh69Mjc78URlFQRaL1GPkMIjpQ/Mj
         il4FotJNWJ2DkhXA10qKjAeMXvHk7iDXHZFxkJdiIYMXQAUt6WNV4nkuHDxPb9CSKN
         1RTvoT4LysswSe+v16MXBJEhUucfh3I52DTBQboM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 07/37] xhci-pci: set the dma max_seg_size
Date:   Sun, 22 Jan 2023 16:04:04 +0100
Message-Id: <20230122150219.888877618@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
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
@@ -378,6 +378,8 @@ static int xhci_pci_probe(struct pci_dev
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:


