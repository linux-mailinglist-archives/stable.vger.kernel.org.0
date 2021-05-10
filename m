Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE23785C7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhEJLBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234614AbhEJK4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353456199D;
        Mon, 10 May 2021 10:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643659;
        bh=evRa31w1g5GCBFrZGTvLbvg4VGdra5QJX+sMYnmOADo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp4r68o15fdwDOZ4FxQIc4VGiNRVkDrewQfL4TBp/GjLFU0H8f6OgAWiO0umdZI+t
         lQx9GoSY2kslI7A5X30xK+7ep+zDz002QsKi0KGrN1SH6Vz0jOp5vGMvm++NWg1AII
         fauSOeh+OAyWhrUeafaULHTuf4LDvrE4kK/g0uPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Angela Czubak <acz@semihalf.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 106/342] resource: Prevent irqresource_disabled() from erasing flags
Date:   Mon, 10 May 2021 12:18:16 +0200
Message-Id: <20210510102013.600066650@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angela Czubak <acz@semihalf.com>

[ Upstream commit d08a745729646f407277e904b02991458f20d261 ]

Some Chromebooks use hard-coded interrupts in their ACPI tables.
This is an excerpt as dumped on Relm:

...
            Name (_HID, "ELAN0001")  // _HID: Hardware ID
            Name (_DDN, "Elan Touchscreen ")  // _DDN: DOS Device Name
            Name (_UID, 0x05)  // _UID: Unique ID
            Name (ISTP, Zero)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (BUF0, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0010, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.I2C1",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveLow, Exclusive, ,, )
                    {
                        0x000000B8,
                    }
                })
                Return (BUF0) /* \_SB_.I2C1.ETSA._CRS.BUF0 */
            }
...

This interrupt is hard-coded to 0xB8 = 184 which is too high to be mapped
to IO-APIC, so no triggering information is propagated as acpi_register_gsi()
fails and irqresource_disabled() is issued, which leads to erasing triggering
and polarity information.

Do not overwrite flags as it leads to erasing triggering and polarity
information which might be useful in case of hard-coded interrupts.
This way the information can be read later on even though mapping to
APIC domain failed.

Signed-off-by: Angela Czubak <acz@semihalf.com>
[ rjw: Changelog rearrangement ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ioport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index fe48b7840665..b53cb1a5b819 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -331,7 +331,7 @@ static inline void irqresource_disabled(struct resource *res, u32 irq)
 {
 	res->start = irq;
 	res->end = irq;
-	res->flags = IORESOURCE_IRQ | IORESOURCE_DISABLED | IORESOURCE_UNSET;
+	res->flags |= IORESOURCE_IRQ | IORESOURCE_DISABLED | IORESOURCE_UNSET;
 }
 
 #ifdef CONFIG_IO_STRICT_DEVMEM
-- 
2.30.2



