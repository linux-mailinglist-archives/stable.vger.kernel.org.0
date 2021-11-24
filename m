Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3229745BBE9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbhKXMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244145AbhKXMXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B1461057;
        Wed, 24 Nov 2021 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756034;
        bh=ivg2Xhd8htgta8PZ6DSn+eKqtKtOPPpkReiTN/UBQl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrJQ1yiUheWt5RV2yrEQIvGgYyPm9FarXMHMCrtcMohh6G63eCOGmP42fS4KzSyrN
         rlPBtW4Wp5go7Or+XXrbHsxRUIuiIlMugZ8lvvc9I5wnQbkQ5yoBivtA8v6jPhDiuS
         xQlS6vnwt3+284QLkcN+Klemsc/WSUdG+tdeJBgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 146/207] ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses
Date:   Wed, 24 Nov 2021 12:56:57 +0100
Message-Id: <20211124115708.747033191@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 009a789443fe4c8e6b1ecb7c16b4865c026184cd ]

The handling of PMIC register reads through writing 0 to address 4
of the OpRegion is wrong. Instead of returning the read value
through the value64, which is a no-op for function == ACPI_WRITE calls,
store the value and then on a subsequent function == ACPI_READ with
address == 3 (the address for the value field of the OpRegion)
return the stored value.

This has been tested on a Xiaomi Mi Pad 2 and makes the ACPI battery dev
there mostly functional (unfortunately there are still other issues).

Here are the SET() / GET() functions of the PMIC ACPI device,
which use this OpRegion, which clearly show the new behavior to
be correct:

OperationRegion (REGS, 0x8F, Zero, 0x50)
Field (REGS, ByteAcc, NoLock, Preserve)
{
    CLNT,   8,
    SA,     8,
    OFF,    8,
    VAL,    8,
    RWM,    8
}

Method (GET, 3, Serialized)
{
    If ((AVBE == One))
    {
        CLNT = Arg0
        SA = Arg1
        OFF = Arg2
        RWM = Zero
        If ((AVBG == One))
        {
            GPRW = Zero
        }
    }

    Return (VAL) /* \_SB_.PCI0.I2C7.PMI5.VAL_ */
}

Method (SET, 4, Serialized)
{
    If ((AVBE == One))
    {
        CLNT = Arg0
        SA = Arg1
        OFF = Arg2
        VAL = Arg3
        RWM = One
        If ((AVBG == One))
        {
            GPRW = One
        }
    }
}

Fixes: 0afa877a5650 ("ACPI / PMIC: intel: add REGS operation region support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pmic/intel_pmic.c | 51 +++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/pmic/intel_pmic.c b/drivers/acpi/pmic/intel_pmic.c
index ca18e0d23df97..db63d3463617a 100644
--- a/drivers/acpi/pmic/intel_pmic.c
+++ b/drivers/acpi/pmic/intel_pmic.c
@@ -216,31 +216,36 @@ static acpi_status intel_pmic_regs_handler(u32 function,
 		void *handler_context, void *region_context)
 {
 	struct intel_pmic_opregion *opregion = region_context;
-	int result = 0;
+	int result = -EINVAL;
+
+	if (function == ACPI_WRITE) {
+		switch (address) {
+		case 0:
+			return AE_OK;
+		case 1:
+			opregion->ctx.addr |= (*value64 & 0xff) << 8;
+			return AE_OK;
+		case 2:
+			opregion->ctx.addr |= *value64 & 0xff;
+			return AE_OK;
+		case 3:
+			opregion->ctx.val = *value64 & 0xff;
+			return AE_OK;
+		case 4:
+			if (*value64) {
+				result = regmap_write(opregion->regmap, opregion->ctx.addr,
+						      opregion->ctx.val);
+			} else {
+				result = regmap_read(opregion->regmap, opregion->ctx.addr,
+						     &opregion->ctx.val);
+			}
+			opregion->ctx.addr = 0;
+		}
+	}
 
-	switch (address) {
-	case 0:
-		return AE_OK;
-	case 1:
-		opregion->ctx.addr |= (*value64 & 0xff) << 8;
+	if (function == ACPI_READ && address == 3) {
+		*value64 = opregion->ctx.val;
 		return AE_OK;
-	case 2:
-		opregion->ctx.addr |= *value64 & 0xff;
-		return AE_OK;
-	case 3:
-		opregion->ctx.val = *value64 & 0xff;
-		return AE_OK;
-	case 4:
-		if (*value64) {
-			result = regmap_write(opregion->regmap, opregion->ctx.addr,
-					      opregion->ctx.val);
-		} else {
-			result = regmap_read(opregion->regmap, opregion->ctx.addr,
-					     &opregion->ctx.val);
-			if (result == 0)
-				*value64 = opregion->ctx.val;
-		}
-		memset(&opregion->ctx, 0x00, sizeof(opregion->ctx));
 	}
 
 	if (result < 0) {
-- 
2.33.0



