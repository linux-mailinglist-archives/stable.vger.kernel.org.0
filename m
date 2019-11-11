Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D017F7DB2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbfKKS6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfKKS6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE16D21655;
        Mon, 11 Nov 2019 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498683;
        bh=iskdGOMRj16nA27sT3BeXxPg/k6V0+5PheWYMiyt14I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZxKpLmBh1qahXTekAtA5JxoEQFyFIugbTY9qs9VmETElA6T7Up3GO3PUmA2iYy5i
         v4zRSTDoWYI8rOqkK028zmNDnzTzOu4Cj8s0H9bKqzTKr3bC203UFIWIdWdeKKb/DT
         0avLfgwNUHgd0SX8tmG8k913gm0dbmHOaifOqTfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 189/193] pinctrl: cherryview: Fix irq_valid_mask calculation
Date:   Mon, 11 Nov 2019 19:29:31 +0100
Message-Id: <20191111181515.033003643@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 63bdef6cd6941917c823b9cc9aa0219d19fcb716 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index bf049d1bbb87c..17a248b723b9b 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1584,7 +1584,7 @@ static int chv_gpio_probe(struct chv_pinctrl *pctrl, int irq)
 		intsel >>= CHV_PADCTRL0_INTSEL_SHIFT;
 
 		if (need_valid_mask && intsel >= community->nirqs)
-			clear_bit(i, chip->irq.valid_mask);
+			clear_bit(desc->number, chip->irq.valid_mask);
 	}
 
 	/*
-- 
2.20.1



