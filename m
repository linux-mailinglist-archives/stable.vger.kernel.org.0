Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6640788E50
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfHJUxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53872 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-000534-W9; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003YJ-MF; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        "Peter Meerwald-Stadler" <pmeerw@pmeerw.net>,
        "Jean-Francois Dagenais" <jeff.dagenais@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.848644193@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 011/157] iio: dac: mcp4725: add missing powerdown
 bits in store eeprom
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>

commit 06003531502d06bc89d32528f6ec96bf978790f9 upstream.

When issuing the write DAC register and write eeprom command, the two
powerdown bits (PD0 and PD1) are assumed by the chip to be present in
the bytes sent. Leaving them at 0 implies "powerdown disabled" which is
a different state that the current one. By adding the current state of
the powerdown in the i2c write, the chip will correctly power-on exactly
like as it is at the moment of store_eeprom call.

This is documented in MCP4725's datasheet, FIGURE 6-2: "Write Commands
for DAC Input Register and EEPROM" and MCP4726's datasheet, FIGURE 6-3:
"Write All Memory Command".

Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Acked-by: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/dac/mcp4725.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/mcp4725.c
+++ b/drivers/iio/dac/mcp4725.c
@@ -86,6 +86,7 @@ static ssize_t mcp4725_store_eeprom(stru
 		return 0;
 
 	inoutbuf[0] = 0x60; /* write EEPROM */
+	inoutbuf[0] |= data->powerdown ? ((data->powerdown_mode + 1) << 1) : 0;
 	inoutbuf[1] = data->dac_value >> 4;
 	inoutbuf[2] = (data->dac_value & 0xf) << 4;
 

