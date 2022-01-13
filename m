Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB348D923
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 14:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiAMNhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 08:37:51 -0500
Received: from mail-ma1ind01olkn0170.outbound.protection.outlook.com ([104.47.100.170]:63456
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235345AbiAMNhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 08:37:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBAeUdS/uA8B+39r2uxuqZfxFugFV2r/GjyJ3e9OyKGv2LrRTkdd3IUB3RdeHtDoTFz4iwgMNdVuFsF3SQzRuPn7u1jGmF8v12YNyO7MYYo1LK0NtMXslu0ASrl0LFUySG2XPQ44h3zbEXzAYZiPQ2orlf3K94lxlzg1td1pUirAGv2SULeKy5DgsIohUdZT5lx8r2Tm9/JH2gmu9PedLP8aWAo7EiDqr119zWdmI4gP68VvGcYV2T+NwxyUuO1toPQBqxzl4N+SZ2MnO2CW6zhH0eGeN8E/NJGvgfTTrvXdZNsQTj+nOauwLhbYPhq5pO0DteXRoolRYqduP/vBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjRTOs6TNBG9R2gRraVkipqtQbq76OtNN9Wigt09oL8=;
 b=A903uOaQ2ItnHkmkCunJT73RoteOLGL8FR7tPEky2k2s0GRACr5YoHG0+yEG5YcvXPk3DSof/F0zbdDZPH0bCVeQtuq4QO481Z7tQrjL489Rn5N9diwSha4tKiZfwEaT/yhiSDUwtW0VqBq00soiOGX+qsm2uCX5KarujHfGKY7UKcKFehjglwtLInf86XHn/xpoEcTLY6rVv3xdkTKrwGz4QgJPuf1+FrrcWGgUqeizLtZKYs663UfskIJmUKudvzqhDSxabXP9z4bnav9YKX02p2ClwmM0YMe6x3W2TBf0k3xiYoqkrigHfkqXtFCr44ZfshXPEUdDChRH/2Jovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjRTOs6TNBG9R2gRraVkipqtQbq76OtNN9Wigt09oL8=;
 b=ULzFTrH1+yoSFSWr+kmuWdRDe2znoob9WRbwi+XmXvq6EYRbLC9l5cNDrPSZuoy8enmERUAsid6VcKYLtPBAOBTL1LOo1k45DPazeXRarFKVw6cUdUm+JAgffUoyXQTRAGjxuekdiGbXNdMKxlXXGpvU1Je+S1CF4LK5bj1UtbcE5NsylHXoaoes7thqHqr7jiRYi00kg1nLdllqhb+q4luVSD1rD8PIFnQkAnpV0asKYwfjpgg/dbxkfTuJWwJxD7YI6RAfl9mBEBilga++S5jlMgbp10o3bA/IsFZ/uej7xaTCbKlMBDlPTtBrKlcO9KJXxn8HKBtAnk6MthXF3g==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB7269.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:90::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 13:37:42 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 13:37:42 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Orlando Chamberlain <redecorating@protonmail.com>
Subject: [PATCH][BACKPORT] mfd: intel-lpss-pci: Fix clock speed for 38a8 UART
Thread-Topic: [PATCH][BACKPORT] mfd: intel-lpss-pci: Fix clock speed for 38a8
 UART
Thread-Index: AQHYCIK9jlt27qJoI0mqWJ5Kp9VhxA==
Date:   Thu, 13 Jan 2022 13:37:42 +0000
Message-ID: <BCA770B8-D7E8-4810-A7CD-FE178C550209@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [EPlq1RzzHw6hqF2eUIID3EF+bEyEDVqYLCWpdvds22w+i0fgHqjUA4nMg3uCpHyX]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e9d999-e4a6-4e3f-ed4e-08d9d699e01e
x-ms-traffictypediagnostic: PN3PR01MB7269:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YyXGrbC+adMjxDDmy+y5bzriSeIXTBLjlqKyJywcbAcLEBRS8WKnxYFCfCv4+ocC8WVH5NVCapeFji+JaE1PGkxw+wENK6FIoqjmgIJuOYacCkCD8WMZnsH8eFcKXDfQOkIhTGS1ef3CRrKfw6pRGi5KTmFEW59IJcsiywKPUsWODDBqSwuPa+f9ETHpXdlC1jPXdXJvm7uDWPhIb7kjnQsBIUfLVu9hFlDH8DRUMv/kmS2/pV4Kw8Ph1xjSvL90MqAitKBq3Vth/Y9AFEplTWoF8ZBF5g8SGRZrC705Md2QCdfstKZ2U2CGfrk3E7Mpt2EM6P/Q16qnV76XEJxLj8zhAXP9MzO2UN0qNXl1EslzSyxyK4c9e7FzBT8A7vCqiP/ZBCmanBSAyOm1E1KwAuljBCHIS7TvdzZKwNIWpSm5epNX5rccR86ot6tXqKrUnCYqUz+KU++9ZyVAQwbgB39pXfcg8M62Wc6XRxK0PDDNqjvKt5PmiJdeam17H+ZQwguZZvZ/CXxWXeSxNYjVL/9ICM4jj5VsVbCtnRamh2RC5nzWzYhVCYccCEu2/rRou6h8Xp+PWk41/lw8gimx2d2kuP31/uQJCB3QI9Srt70EUQYOHTmiKo2pxvrBLLu5
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pnUroX7ZvFrjOrjnSGvzox0rjbol+tzSIlFMwTDk+KvO7eXFbIi1AWKa3GL0?=
 =?us-ascii?Q?In22+ujommQoGT6YU1QoxYSNTPvajolXQ0brvuKpCoFxzrlodNPq3zWbThy9?=
 =?us-ascii?Q?pZAeF9KGSOmjcM8wTR3lI+XtBcv2D+JLOC1dZHjuvjV4CVJpfeIutt3lOPoU?=
 =?us-ascii?Q?2cIH43XsCV9jkdR+m0bQE66TTJ7QQk0lS2hY+KGgrFxpEHQmxdCJHQ00rBXP?=
 =?us-ascii?Q?Ltud0YHwo1W+b25Y2zJznlI7IzLqs5Vrn35OIwcWl6rNC6H0wEbXbppwu6sW?=
 =?us-ascii?Q?DRqpY8AwaK+0oCHtewVCMbydk/Xqm0Zj5J+9x0b58XJZTAG4wdOd6KZivjP3?=
 =?us-ascii?Q?L2G08ex8vVb4TXrB9AB5u0Um1KRQv3698aMGTshpmXSxAVjeS1Sda3sVSu72?=
 =?us-ascii?Q?dz85w6ydsuPuNccrcLufid6ZTk+x9zIU+PPain4wzA1bHH2Lo4MkVRUu6B8w?=
 =?us-ascii?Q?JOgHFO6idJJFCAZ78p3aLSQ305Sk+Yqh5Jl1vNG33i6CFrxrP3Kudf3aWNSQ?=
 =?us-ascii?Q?2cm/RY790x4ueJVPWORkf3QXdnOWCtKox6ik+DFBapEcDL+yMROkAggjWK2w?=
 =?us-ascii?Q?lWj+h6DWPvfkx5JU5ugfB+AP9cNRDCwd/l5TniU5gLT2MWBGMbFTiyljI6vm?=
 =?us-ascii?Q?DJKke/AOm2POR3Y7qkCUu/BkutAZ5K0b+EHw1/b067vc8yqQh+WAW5E1EU2u?=
 =?us-ascii?Q?a8hlfCPYgprTcj8kAlD/gVTKZN6MCrSFCwsupV3ItEkTCwiiY8KqBLRhmNaF?=
 =?us-ascii?Q?6XqToYc8dMPvGGEaYGwAZ0NBrajWd0HV0XxKEaU9wuU2+hloBfz/jxmDRiBr?=
 =?us-ascii?Q?+UQQbIoF4jLZicAbirN/bUvK3av/Q9ASxdhy+WjFW/mJ1R0jdIt+AHrWzNmH?=
 =?us-ascii?Q?Nkh6zkwWdvWncOUeedBX+UEN+XWW/epni7u6wOc3sdtG20ZgNE0dk5V9juDt?=
 =?us-ascii?Q?HDvP/d4Q/n36BQ4JGG/n03rSAaUalWRi6RXcz/fYkfAShJjEG8D5wiTvlvyc?=
 =?us-ascii?Q?7JQSUuKt0gv4p7XsusqqQalZyw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20C07A35F5015F448E0D3B471FAFB5B8@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e9d999-e4a6-4e3f-ed4e-08d9d699e01e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 13:37:42.6735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7269
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following patch was proposed as a fix for 5.16 when it was in beta stag=
e but still hasn't been applied to stable 5.16 yet. Thus I am sending it to=
 queue up

commit 9651cf2cb14726c785240e9dc01b274a68e9959e upstream

From: Orlando Chamberlain <redecorating@protonmail.com>

This device is found in the MacBookPro16,2, and as the MacBookPro16,1 is
from the same generation of MacBooks and has a UART with bxt_uart_info,
it was incorrectly assumed that the MacBookPro16,2's UART would have the
same info.

This led to the wrong clock speed being used, and the Bluetooth
controller exposed by the UART receiving and sending random data, which
was incorrectly assumed to be an issue with the Bluetooth stuff, not an
error with the UART side of things.

Changing the info to spt_uart_info changes the clock speed and makes it
send and receive data correctly.

Fixes: ddb1ada ("mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N UART=
")
Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211124091846.11114-1-redecorating@protonm=
ail.com
---
 drivers/mfd/intel-lpss-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 9700e5acd0cd2d..a59aa147959b3e 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -254,7 +254,7 @@ static const struct pci_device_id intel_lpss_pci_ids[] =
=3D {
 	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
 	/* ICL-N */
-	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&spt_uart_info },
 	/* TGL-H */
 	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },=
