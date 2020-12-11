Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525452D7007
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 07:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgLKGME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 01:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404659AbgLKGLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 01:11:52 -0500
Subject: patch "usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607667071;
        bh=ceGgnbD/471e7M7J91aUSqVEpeLiTUOUTL12QCSkzWc=;
        h=To:From:Date:From;
        b=epsHnC7KnTSZfoEJlO+a3sK0A/9sjFaAqD8zbXXojFIAlM381rDL2tdrtqgqWSeq5
         e2kBNwcxAhYXXEIcUqKJFeZfdW1mRiomEOiGoppTfTeviU+Ikp/F8WAwSSBZR5uc9M
         D+xhpLB2swjVumX+nkI6L65bXOoMlR3E4ou8NP80=
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 07:10:05 +0100
Message-ID: <160766700524103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a353397b0d5dfa3c99b372505db3378fc919c6c6 Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Tue, 27 Oct 2020 16:07:31 -0700
Subject: usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

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
---
 drivers/usb/gadget/function/f_fs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 8f5ceacdc5f1..78c003fb05fd 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1330,6 +1330,7 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
+		case USB_SPEED_SUPER_PLUS:
 			desc_idx = 2;
 			break;
 		case USB_SPEED_HIGH:
@@ -3176,7 +3177,8 @@ static int _ffs_func_bind(struct usb_configuration *c,
 	}
 
 	if (likely(super)) {
-		func->function.ss_descriptors = vla_ptr(vlabuf, d, ss_descs);
+		func->function.ss_descriptors = func->function.ssp_descriptors =
+			vla_ptr(vlabuf, d, ss_descs);
 		ss_len = ffs_do_descs(ffs->ss_descs_count,
 				vla_ptr(vlabuf, d, raw_descs) + fs_len + hs_len,
 				d_raw_descs__sz - fs_len - hs_len,
@@ -3586,6 +3588,7 @@ static void ffs_func_unbind(struct usb_configuration *c,
 	func->function.fs_descriptors = NULL;
 	func->function.hs_descriptors = NULL;
 	func->function.ss_descriptors = NULL;
+	func->function.ssp_descriptors = NULL;
 	func->interfaces_nums = NULL;
 
 	ffs_event_add(ffs, FUNCTIONFS_UNBIND);
-- 
2.29.2


