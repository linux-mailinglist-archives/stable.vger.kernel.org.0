Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903F32E688D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgL1NBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729528AbgL1NAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1552A22583;
        Mon, 28 Dec 2020 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160406;
        bh=lLyxgcPt9F8rPa/YebkBCTauAUTHPvX84Z7WFjxvB/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4ipM92qRtA7dTcvnIfj+JEAVnfm7SqmFXT98c4ECz83nZnDJ+7bUyd0s3S1kC71q
         sWpe3UZ8ADmYF2+B4sCKbO1T7dBz1cen5IYJelI/h4ocu3yFgJM7uqE/04cGruMuDJ
         4nh5LL63wBoprNfCno0eQAHLMGHUwS5mceVeN79o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 4.9 040/175] usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus
Date:   Mon, 28 Dec 2020 13:48:13 +0100
Message-Id: <20201228124855.191101535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit a353397b0d5dfa3c99b372505db3378fc919c6c6 upstream.

In many cases a function that supports SuperSpeed can very well
operate in SuperSpeedPlus, if a gadget controller supports it,
as the endpoint descriptors (and companion descriptors) are
generally identical and can be re-used. This is true for two
commonly used functions: Android's ADB and MTP. So we can simply
assign the usb_function's ssp_descriptors array to point to its
ss_descriptors, if available. Similarly, we need to allow an
epfile's ioctl for FUNCTIONFS_ENDPOINT_DESC to correctly
return the corresponding SuperSpeed endpoint descriptor in case
the connected speed is SuperSpeedPlus as well.

The only exception is if a function wants to implement an
Isochronous endpoint capable of transferring more than 48KB per
service interval when operating at greater than USB 3.1 Gen1
speed, in which case it would require an additional SuperSpeedPlus
Isochronous Endpoint Companion descriptor to be returned as part
of the Configuration Descriptor. Support for that would need
to be separately added to the userspace-facing FunctionFS API
which may not be a trivial task--likely a new descriptor format
(v3?) may need to be devised to allow for separate SS and SSP
descriptors to be supplied.

Signed-off-by: Jack Pham <jackp@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201027230731.9073-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1228,6 +1228,7 @@ static long ffs_epfile_ioctl(struct file
 
 			switch (epfile->ffs->gadget->speed) {
 			case USB_SPEED_SUPER:
+			case USB_SPEED_SUPER_PLUS:
 				desc_idx = 2;
 				break;
 			case USB_SPEED_HIGH:
@@ -3067,7 +3068,8 @@ static int _ffs_func_bind(struct usb_con
 	}
 
 	if (likely(super)) {
-		func->function.ss_descriptors = vla_ptr(vlabuf, d, ss_descs);
+		func->function.ss_descriptors = func->function.ssp_descriptors =
+			vla_ptr(vlabuf, d, ss_descs);
 		ss_len = ffs_do_descs(ffs->ss_descs_count,
 				vla_ptr(vlabuf, d, raw_descs) + fs_len + hs_len,
 				d_raw_descs__sz - fs_len - hs_len,
@@ -3507,6 +3509,7 @@ static void ffs_func_unbind(struct usb_c
 	func->function.fs_descriptors = NULL;
 	func->function.hs_descriptors = NULL;
 	func->function.ss_descriptors = NULL;
+	func->function.ssp_descriptors = NULL;
 	func->interfaces_nums = NULL;
 
 	ffs_event_add(ffs, FUNCTIONFS_UNBIND);


