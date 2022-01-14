Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383B248E592
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiANITL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiANISq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B16FC06175A;
        Fri, 14 Jan 2022 00:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1052B82434;
        Fri, 14 Jan 2022 08:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94DAC36AE9;
        Fri, 14 Jan 2022 08:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148323;
        bh=g57pxS2bCc3tWqe1XaCKL+bvkppkDCofhbjkD5BZP84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ta1xrm+NStlhhzbkKPqZNvH4Q3gwvb6885QcoCr/YYW0axvcnx7fAKw3lkhWxELnP
         X9qpS5epQ1QDiRYxY5DyXAjTzgPKvxP7Ea3z2LSNOsb6TQe8d9Q2StnP3UKvsPjvQK
         j0SqBeKXDGQ2tFqjZrirvEdFL13R0X8nFebvEhkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 08/25] Bluetooth: bfusb: fix division by zero in send path
Date:   Fri, 14 Jan 2022 09:16:16 +0100
Message-Id: <20220114081542.976713193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b5e6fa7a12572c82f1e7f2f51fbb02a322291291 upstream.

Add the missing bulk-out endpoint sanity check to probe() to avoid
division by zero in bfusb_send_frame() in case a malicious device has
broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/bfusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -628,6 +628,9 @@ static int bfusb_probe(struct usb_interf
 	data->bulk_out_ep   = bulk_out_ep->desc.bEndpointAddress;
 	data->bulk_pkt_size = le16_to_cpu(bulk_out_ep->desc.wMaxPacketSize);
 
+	if (!data->bulk_pkt_size)
+		goto done;
+
 	rwlock_init(&data->lock);
 
 	data->reassembly = NULL;


