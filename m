Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BF249896D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343614AbiAXS4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:56:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53486 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiAXSyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01E0461527;
        Mon, 24 Jan 2022 18:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA68C36AF7;
        Mon, 24 Jan 2022 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050456;
        bh=CBPENbkco7iWTiGBptNuAshMijpXyfLZVEct9/ZpMIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7QRquwEqiVPF6369KP6Xxyjs3aQtSTTTo69uiUsHLuiZeVSqQ4sehOR5oFZ+piAm
         Tnf4y2Xi9/7f9ZB+qlsqlCG2XRwn8jxfz1i4SnKjtkzfqRqpFweIJd14DYJtZ8fdV6
         I1IKFHHzdfUYH94Duo3WcpSiMltPkV3xgXhmpXq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.9 001/157] Bluetooth: bfusb: fix division by zero in send path
Date:   Mon, 24 Jan 2022 19:41:31 +0100
Message-Id: <20220124183932.834484960@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -644,6 +644,9 @@ static int bfusb_probe(struct usb_interf
 	data->bulk_out_ep   = bulk_out_ep->desc.bEndpointAddress;
 	data->bulk_pkt_size = le16_to_cpu(bulk_out_ep->desc.wMaxPacketSize);
 
+	if (!data->bulk_pkt_size)
+		goto done;
+
 	rwlock_init(&data->lock);
 
 	data->reassembly = NULL;


