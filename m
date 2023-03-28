Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCC56CC541
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjC1PNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjC1PMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173EB10272
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF28261864
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C0FC43446;
        Tue, 28 Mar 2023 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016241;
        bh=8NN38rp18l8sW/u16ly69ADMI68JSc09ycDwXeOKiMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzSp15/YzO3J4YBI9EzBi+doZ3eQiZPQBfdpN8+ZuJKFP5XPX7lmjQEk2lhA6G4Wf
         bGUFSJ6Zgv/zPZB8/uKqIi2AUlZb6keRIXR2WvDy2QDhUu+0P17L3RFe5vqd0L3AVY
         K+TyfhJRAC51WYUfxqpCQeFztKPlXBe9gTDExwTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 116/146] usb: cdns3: Fix issue with using incorrect PCI device function
Date:   Tue, 28 Mar 2023 16:43:25 +0200
Message-Id: <20230328142607.486401872@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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
 drivers/usb/cdns3/cdns3-pci-wrap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 


