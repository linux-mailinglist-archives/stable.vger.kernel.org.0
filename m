Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D211CAACD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgEHMhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgEHMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9E9215A4;
        Fri,  8 May 2020 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941417;
        bh=K5TzdsmWxJBMOOlBOozO1w9/j3b1gDPq9drqvpDnfSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRDvtWZI5Wfv4QQA8OxhJ+nEADmrplkS1FpAHFcdcRqQUrkzLd2MkXUS7eTdtEWI5
         ilijjNpUAWdCTp9XrM6+4aBzeExRkrmYbSID1tupU4C9l3WrAV0RkqzbJufJoC4T48
         CTsXjQKj0J1oMcRNjLByI3hJSGNYgUffVl9UjVlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.4 008/312] usb: gadget: udc: core: dont starve DMA resources
Date:   Fri,  8 May 2020 14:29:59 +0200
Message-Id: <20200508123125.099449494@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit 23fd537c9508fb6e3b93ddf23982f51afc087781 upstream.

Always unmap all SG entries as required by DMA API

Fixes: a698908d3b3b ("usb: gadget: add generic map/unmap request utilities")
Cc: <stable@vger.kernel.org> # v3.4+
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -97,7 +97,7 @@ void usb_gadget_unmap_request(struct usb
 		return;
 
 	if (req->num_mapped_sgs) {
-		dma_unmap_sg(gadget->dev.parent, req->sg, req->num_mapped_sgs,
+		dma_unmap_sg(gadget->dev.parent, req->sg, req->num_sgs,
 				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 		req->num_mapped_sgs = 0;


