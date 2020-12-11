Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA662D7004
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 07:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405239AbgLKGLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 01:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404224AbgLKGLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 01:11:36 -0500
Subject: patch "USB: gadget: f_rndis: fix bitrate for SuperSpeed and above" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607667055;
        bh=PG1RpInDT9UVQ66MR/qwBpSQN0V7i5Q1Bl0yeIQqzBs=;
        h=To:From:Date:From;
        b=VCCjHK1h+waywk9MhIIDt1ewGidhNddgxsAE3cjORMd1fD/tVQNlQyp8n7DyBUX1U
         sncK2v7NGrly2R/LP4m2TwBqSkl6QkEIwMqQsN3ovcrNpuaALypJ2ftjQM+tnDZSwD
         owpG6g4XXIBlRs3d7YV58udE9xvJqkVtcQSQNWxs=
To:     willmcvicker@google.com, balbi@kernel.org, ejh@nvidia.com,
        gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 07:10:02 +0100
Message-ID: <1607667002249151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b00f444f9add39b64d1943fa75538a1ebd54a290 Mon Sep 17 00:00:00 2001
From: Will McVicker <willmcvicker@google.com>
Date: Fri, 27 Nov 2020 15:05:55 +0100
Subject: USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Align the SuperSpeed Plus bitrate for f_rndis to match f_ncm's ncm_bitrate
defined by commit 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descriptors
for CDC NCM").

Cc: Felipe Balbi <balbi@kernel.org>
Cc: EJ Hsu <ejh@nvidia.com>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_rndis.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
index 9534c8ab62a8..0739b05a0ef7 100644
--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -87,8 +87,10 @@ static inline struct f_rndis *func_to_rndis(struct usb_function *f)
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static unsigned int bitrate(struct usb_gadget *g)
 {
+	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+		return 4250000000U;
 	if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
-		return 13 * 1024 * 8 * 1000 * 8;
+		return 3750000000U;
 	else if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
 		return 13 * 512 * 8 * 1000 * 8;
 	else
-- 
2.29.2


