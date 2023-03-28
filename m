Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78136CC472
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbjC1PFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjC1PFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD63E079
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B81B8CE1D9A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4190C4339B;
        Tue, 28 Mar 2023 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015793;
        bh=8NN38rp18l8sW/u16ly69ADMI68JSc09ycDwXeOKiMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqcGh0wzkx+Nb6YlsT+HGNt80eBtAWLulCWiXszgk4929foRn1xxqPkyl6wBSO8YL
         tAouP6pcwB2jRPGxdjy7D6lFFdltfX89tPaQzhUGIBlJBaltE7PUtk8uuBdEfLug8l
         qcPrrnfnSrMsuNYpyv2iB8kchU5sZgB8ZJssmfOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.1 176/224] usb: cdns3: Fix issue with using incorrect PCI device function
Date:   Tue, 28 Mar 2023 16:42:52 +0200
Message-Id: <20230328142624.727048685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 


