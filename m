Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C197F6E65
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfKKGIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:08:07 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45675 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbfKKGIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:08:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 10B8B57F;
        Mon, 11 Nov 2019 01:08:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WS6mFP
        i3EW5i+tysy36e7flpNy9IXcF8gMbBDPxEwwc=; b=cEuHhIt3ffALqQzzhWC68s
        0cQmZm4/d3FRZ2CjaFSYAq96/kR9pXK7xDV23ZecwdQopV1GihFCaf03UTu4ZDMY
        cQPpm4UjQ0vCY/KrZJ4Vw1zulVA9tFkKsijsiHhpqbslRejz2mEafNSzRIqvg/iK
        VcV7/9YvNLkZkx5/OD713ri2DTTvRuRxnIbKnM7OdPMa/+ei/fxtMMNIvghyvcJD
        ZgYatQZPXLWhwcW6e3LvpG/yRqFK/PvmYGgs8qJZfmiCuZQQwMY4n/2VugBQ3zYZ
        wfec5dEt0UUvWJ61M4r7gfTEkzbnnCyc2WRTQUFi9MGvb7ueE8La47USLqTXaqjQ
        ==
X-ME-Sender: <xms:xfrIXagPm-mAkbDSa-mKkfqZr-HryMl0RLWaTxfMc4N5UVFJdvajqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xfrIXb8YLyJu5Fd6CAaBB72RMC6lvf5v3hZE0vhXYetourGgvrr6Uw>
    <xmx:xfrIXSYpCi97X71J1pFkhyrQrOmX_gPnfTj-Ap2btQCfFkNV91-jEA>
    <xmx:xfrIXRtz1biRL1567p_q3d9YzeloE6y7UNMnztsubP2dJH2jNfDiBw>
    <xmx:xfrIXeu-gFKQomsqerAPDXu_t3k75tSHttQc7d8gr4tHmDfZAvyLtg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF545306005C;
        Mon, 11 Nov 2019 01:08:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation" failed to apply to 5.3-stable tree
To:     hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:08:03 +0100
Message-ID: <157345248387137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63bdef6cd6941917c823b9cc9aa0219d19fcb716 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 18 Oct 2019 11:08:42 +0200
Subject: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation

Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
GPIO translation") has made the cherryview gpio numbers sparse, to get
a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.

This has greatly simplified things, but the code setting the
irq_valid_mask was not updated for this, so the valid mask is still in
the old "compressed" numbering with the gaps in the pin numbers skipped,
which is wrong as irq_valid_mask needs to be expressed in gpio numbers.

This results in the following error on devices using pin 24 (0x0018) on
the north GPIO controller as an ACPI event source:

[    0.422452] cherryview-pinctrl INT33FF:01: Failed to translate GPIO to IRQ

This has been reported (by email) to be happening on a Caterpillar CAT T20
tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.

This commit uses the pin number instead of the compressed index into
community->pins to clear the correct bits in irq_valid_mask for GPIOs
using GPEs for interrupts, fixing these errors and in case of the
Medion Akoya e2215t also fixing the LID switch not working.

Cc: stable@vger.kernel.org
Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index c6251eac8946..c31266e70559 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1559,7 +1559,7 @@ static void chv_init_irq_valid_mask(struct gpio_chip *chip,
 		intsel >>= CHV_PADCTRL0_INTSEL_SHIFT;
 
 		if (intsel >= community->nirqs)
-			clear_bit(i, valid_mask);
+			clear_bit(desc->number, valid_mask);
 	}
 }
 

