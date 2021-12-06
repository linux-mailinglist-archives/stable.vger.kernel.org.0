Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2D8469BD4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359129AbhLFPRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34382 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346705AbhLFPOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53BF16134A;
        Mon,  6 Dec 2021 15:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B78C341C5;
        Mon,  6 Dec 2021 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803437;
        bh=Ore5wlezD3yV5BIeDNVWyozbTsqKcJmLOke6XWdvMf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXU7MKm5Wiy5nlqc9wyLcm7mY5GOf3czylEmWjR4yTJH8xX5s7t7tQSVazOm5vrHv
         QNzvCIyPH52zbceyp+qaw7BnghfjahJh375p5Ix3WC9V7A49F52RQqvJFNGFUAVCJ6
         2L/mf5tJ8Y/OLPqU2vROWdxHk4AsqNEvcT/ARPDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ole Ernst <olebowle@gmx.com>
Subject: [PATCH 4.19 41/48] USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub
Date:   Mon,  6 Dec 2021 15:56:58 +0100
Message-Id: <20211206145550.241157017@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ole Ernst <olebowle@gmx.com>

commit d2a004037c3c6afd36d40c384d2905f47cd51c57 upstream.

This is another branded 8153 device that doesn't work well with LPM:
r8152 2-2.1:1.0 enp0s13f0u2u1: Stop submitting intr, status -71

Disable LPM to resolve the issue.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211127090546.52072-1-olebowle@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -435,6 +435,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0x721e), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },


