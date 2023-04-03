Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2F6D478A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjDCOVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjDCOVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F502CAF8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C0A61D16
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67528C433EF;
        Mon,  3 Apr 2023 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531622;
        bh=IR+Ms+D06BRkpRSxbupCvNJAIWUjyGRDhjJ6KeZWrfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1ulF+cZARUSx7gPxjdVUa7RiQJi7Q3c1PI1AugVFr3XhJZ6VBSDufdPDv1YWPx9d
         zlC+/tEaYjj6tvt4CUS3BmD84xejEmSXSxxcCmqCGbF1j6B6d5dUnafv59MCF2OP1e
         EoZumc71sZlcfI2pb7scQikCWqhWirkjDFu6DMoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.4 048/104] usb: cdns3: Fix issue with using incorrect PCI device function
Date:   Mon,  3 Apr 2023 16:08:40 +0200
Message-Id: <20230403140406.253676583@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 1272fd652a226ccb34e9f47371b6121948048438 upstream.

PCI based platform can have more than two PCI functions.
USBSS PCI Glue driver during initialization should
consider only DRD/HOST/DEVICE PCI functions and
all other should be ignored. This patch adds additional
condition which causes that only DRD and HOST/DEVICE
function will be accepted.

cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230308124427.311245-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-pci-wrap.c b/drivers/usb/cdns3/cdns3-pci-wrap.c
index deeea618ba33..1f6320d98a76 100644
--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_fun(struct pci_dev *pdev)
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 
-- 
2.40.0



