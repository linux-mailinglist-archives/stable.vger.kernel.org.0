Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED4DEEE7
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfJUOJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:09:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:11004 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfJUOJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 10:09:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 07:09:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="209449417"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 21 Oct 2019 07:09:51 -0700
Received: by lahna (sSMTP sendmail emulation); Mon, 21 Oct 2019 17:09:51 +0300
Date:   Mon, 21 Oct 2019 17:09:51 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation
Message-ID: <20191021140951.GN2819@lahna.fi.intel.com>
References: <20191018090842.11189-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018090842.11189-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 11:08:42AM +0200, Hans de Goede wrote:
> Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
> GPIO translation") has made the cherryview gpio numbers sparse, to get
> a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.
> 
> This has greatly simplified things, but the code setting the
> irq_valid_mask was not updated for this, so the valid mask is still in
> the old "compressed" numbering with the gaps in the pin numbers skipped,
> which is wrong as irq_valid_mask needs to be expressed in gpio numbers.
> 
> This results in the following error on devices using pin 24 (0x0018) on
> the north GPIO controller as an ACPI event source:
> 
> [    0.422452] cherryview-pinctrl INT33FF:01: Failed to translate GPIO to IRQ
> 
> This has been reported (by email) to be happening on a Caterpillar CAT T20
> tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.
> 
> This commit uses the pin number instead of the compressed index into
> community->pins to clear the correct bits in irq_valid_mask for GPIOs
> using GPEs for interrupts, fixing these errors and in case of the
> Medion Akoya e2215t also fixing the LID switch not working.
> 
> Cc: stable@vger.kernel.org
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Applied to intel.git/fixes, thanks!
