Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588E02259D8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGTIS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 04:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgGTIS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 04:18:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0053222B4D;
        Mon, 20 Jul 2020 08:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595233138;
        bh=agmIxEyajAvx2y7Anp813adb0UBcZv5WFzepIH8fziw=;
        h=Subject:To:From:Date:From;
        b=pMrFX1vqu+04kCOpkoJjo69x4xDzp5izzU3WWOXzNZdtcQ3NZUUHPRs2hOSj6+7jJ
         L5+URKsiIkDqlLstLwQMKLUuyQdZNpwVvlwAGRtT6rus/zc5zEUj7AL2hxiw5MdApQ
         37JX3WpbxKS2nJIY6eIbBZhWdBDKSCI/71N+BRwo=
Subject: patch "staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 10:19:09 +0200
Message-ID: <1595233149101145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f07804ec77d77f8a9dcf570a24154e17747bc82f Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Fri, 17 Jul 2020 15:52:54 +0100
Subject: staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support

`ni6527_intr_insn_config()` processes `INSN_CONFIG` comedi instructions
for the "interrupt" subdevice.  When `data[0]` is
`INSN_CONFIG_DIGITAL_TRIG` it is configuring the digital trigger.  When
`data[2]` is `COMEDI_DIGITAL_TRIG_ENABLE_EDGES` it is configuring rising
and falling edge detection for the digital trigger, using a base channel
number (or shift amount) in `data[3]`, a rising edge bitmask in
`data[4]` and falling edge bitmask in `data[5]`.

If the base channel number (shift amount) is greater than or equal to
the number of channels (24) of the digital input subdevice, there are no
changes to the rising and falling edges, so the mask of channels to be
changed can be set to 0, otherwise the mask of channels to be changed,
and the rising and falling edge bitmasks are shifted by the base channel
number before calling `ni6527_set_edge_detection()` to change the
appropriate registers.  Unfortunately, the code is comparing the base
channel (shift amount) to the interrupt subdevice's number of channels
(1) instead of the digital input subdevice's number of channels (24).
Fix it by comparing to 32 because all shift amounts for an `unsigned
int` must be less than that and everything from bit 24 upwards is
ignored by `ni6527_set_edge_detection()` anyway.

Fixes: 110f9e687c1a8 ("staging: comedi: ni_6527: support INSN_CONFIG_DIGITAL_TRIG")
Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_6527.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 4d1eccb5041d..4518c2680b7c 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -332,7 +332,7 @@ static int ni6527_intr_insn_config(struct comedi_device *dev,
 		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
 			/* check shift amount */
 			shift = data[3];
-			if (shift >= s->n_chan) {
+			if (shift >= 32) {
 				mask = 0;
 				rising = 0;
 				falling = 0;
-- 
2.27.0


