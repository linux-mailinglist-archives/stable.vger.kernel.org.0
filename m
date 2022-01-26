Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4325949C9EB
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiAZMnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:43:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiAZMnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:43:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602CA61A18
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 12:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BE9C340E3;
        Wed, 26 Jan 2022 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643200987;
        bh=Hk6vN2X9B9qCnKVIb9Op5Jr47OqxVH5ftKw5dRautPo=;
        h=Subject:To:From:Date:From;
        b=oWWRUMumF+PXRFM6NbrZswvBRZi3IgbrBZ2RJJPwNifuY9Z/+3vWOoQx3NVENCW8D
         OCqFopQ6j9MRKqOuJPeTiFqTrnuFGG+iMK3d4ESznhgGhmCDBFDRme1gKCqZB6YN+V
         VMf1n8x8hWg/rTn/hfENOcDUjyo3ZJXm51kuSuwU=
Subject: patch "usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS" added to usb-linus
To:     quic_pkondeti@quicinc.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 13:43:05 +0100
Message-ID: <164320098569227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 904edf8aeb459697129be5fde847e2a502f41fd9 Mon Sep 17 00:00:00 2001
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Date: Sat, 22 Jan 2022 08:33:22 +0530
Subject: usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Currently when gadget enumerates in super speed plus, the isoc
endpoint request buffer size is not calculated correctly. Fix
this by checking the gadget speed against USB_SPEED_SUPER_PLUS
and update the request buffer size.

Fixes: 90c4d05780d4 ("usb: fix various gadgets null ptr deref on 10gbps cabling.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Link: https://lore.kernel.org/r/1642820602-20619-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_sourcesink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_sourcesink.c b/drivers/usb/gadget/function/f_sourcesink.c
index 1abf08e5164a..6803cd60cc6d 100644
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -584,6 +584,7 @@ static int source_sink_start_ep(struct f_sourcesink *ss, bool is_in,
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *
-- 
2.35.0


