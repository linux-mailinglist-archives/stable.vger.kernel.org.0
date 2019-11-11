Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14255F7515
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKNgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKNgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:36:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E5072196E;
        Mon, 11 Nov 2019 13:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573479379;
        bh=JtmrcDYM1sLF0GeYS9kBuID3a5PXqXEQRlEMoUPOwZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=az1flRb1AtYPGr/t0jK1tboBT6lP8hFtb6eM/o4Mr6HzeG2N+qN+C6uOb0qUyipRt
         C4VQ70klQ8X3xMPX+nDlTMnTRiQn+OiCSNwP4l1u9Ci6pwcNHd7YCV5A5Uc6PBIAFB
         O/dilTViXsN8XwbLeDarbH4JZAOMT8iiXQhdCYVc=
Date:   Mon, 11 Nov 2019 08:36:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: cherryview: Fix irq_valid_mask
 calculation" failed to apply to 5.3-stable tree
Message-ID: <20191111133618.GT4787@sasha-vm>
References: <157345248387137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157345248387137@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:08:03AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 63bdef6cd6941917c823b9cc9aa0219d19fcb716 Mon Sep 17 00:00:00 2001
>From: Hans de Goede <hdegoede@redhat.com>
>Date: Fri, 18 Oct 2019 11:08:42 +0200
>Subject: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation
>
>Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
>GPIO translation") has made the cherryview gpio numbers sparse, to get
>a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.
>
>This has greatly simplified things, but the code setting the
>irq_valid_mask was not updated for this, so the valid mask is still in
>the old "compressed" numbering with the gaps in the pin numbers skipped,
>which is wrong as irq_valid_mask needs to be expressed in gpio numbers.
>
>This results in the following error on devices using pin 24 (0x0018) on
>the north GPIO controller as an ACPI event source:
>
>[    0.422452] cherryview-pinctrl INT33FF:01: Failed to translate GPIO to IRQ
>
>This has been reported (by email) to be happening on a Caterpillar CAT T20
>tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.
>
>This commit uses the pin number instead of the compressed index into
>community->pins to clear the correct bits in irq_valid_mask for GPIOs
>using GPEs for interrupts, fixing these errors and in case of the
>Medion Akoya e2215t also fixing the LID switch not working.
>
>Cc: stable@vger.kernel.org
>Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I've adjust the patch to work around not having 5fbe5b5883f8 ("gpio:
Initialize the irqchip valid_mask with a callback") and queued it for
5.3 and 4.19.

-- 
Thanks,
Sasha
