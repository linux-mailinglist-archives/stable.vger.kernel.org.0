Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41A6CA933
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbfJCQix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392151AbfJCQiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689372070B;
        Thu,  3 Oct 2019 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120731;
        bh=DrvnDd38D+DGa70iX5cHchy71qkt3OaxrJ1beFpUMik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uz87WULQDkwf1w77ErgcmgycyAEwyJHE252cyr2m4IW5opX/yU/kHemmx5VdJk6W
         rmnSYVvwHGf9WzE0YHyDROovHsYaWtrFWqsnve58e7XQnFRd1zPqASZgBJ3uQxvnS1
         XiIYJMg/XezzQKtp6iGrmf8og+p6zcs2bVbQb918=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 018/344] usbnet: ignore endpoints with invalid wMaxPacketSize
Date:   Thu,  3 Oct 2019 17:49:43 +0200
Message-Id: <20191003154541.861719752@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 8d3d7c2029c1b360f1a6b0a2fca470b57eb575c0 ]

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the drivers more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of these endpoints are used for memory allocations
and as divisors in many usbnet minidrivers. Avoiding zero is therefore
critical.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -100,6 +100,11 @@ int usbnet_get_endpoints(struct usbnet *
 			int				intr = 0;
 
 			e = alt->endpoint + ep;
+
+			/* ignore endpoints which cannot transfer data */
+			if (!usb_endpoint_maxp(&e->desc))
+				continue;
+
 			switch (e->desc.bmAttributes) {
 			case USB_ENDPOINT_XFER_INT:
 				if (!usb_endpoint_dir_in(&e->desc))


