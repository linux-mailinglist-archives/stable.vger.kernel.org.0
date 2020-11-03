Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210902A56C9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbgKCVao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731057AbgKCU55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A0B22226;
        Tue,  3 Nov 2020 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437076;
        bh=71ZehZ3+PO2T+WEyXk27DSKW9Y8mJr4AEfNFxJE53Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGvc9otgtd8sBVIBZjUykw1J5I0oIZhU/yroxTzqLL4KlOe2ObrtzzpFsNW7OlTVb
         KhnTBNIdWd2cLmqDvXEaqZhRBo0/mJRsZjezYmGcPAlGEwJtlDh0xa8f04BcTtj2Os
         HBIe7OT/OIpr3bAoyfqXL08HcWqOzd2Q/pxW7Fdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 136/214] usb: dwc3: gadget: Check MPS of the request length
Date:   Tue,  3 Nov 2020 21:36:24 +0100
Message-Id: <20201103203303.582071131@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit ca3df3468eec87f6374662f7de425bc44c3810c1 upstream.

When preparing for SG, not all the entries are prepared at once. When
resume, don't use the remaining request length to calculate for MPS
alignment. Use the entire request->length to do that.

Cc: stable@vger.kernel.org
Fixes: 5d187c0454ef ("usb: dwc3: gadget: Don't setup more than requested")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1057,6 +1057,8 @@ static void dwc3_prepare_one_trb_sg(stru
 	struct scatterlist *s;
 	int		i;
 	unsigned int length = req->request.length;
+	unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
+	unsigned int rem = length % maxp;
 	unsigned int remaining = req->request.num_mapped_sgs
 		- req->num_queued_sgs;
 
@@ -1068,8 +1070,6 @@ static void dwc3_prepare_one_trb_sg(stru
 		length -= sg_dma_len(s);
 
 	for_each_sg(sg, s, remaining, i) {
-		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
-		unsigned int rem = length % maxp;
 		unsigned int trb_length;
 		unsigned chain = true;
 


