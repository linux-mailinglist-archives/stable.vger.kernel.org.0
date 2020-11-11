Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF62AF1C7
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgKKNNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:13:02 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:39352 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKKNNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:13:01 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0ABDCs5q026026;
        Wed, 11 Nov 2020 08:12:54 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 34npmk9w5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 08:12:54 -0500
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 11 Nov 2020 08:12:52 -0500
Received: from localhost.localdomain (132.158.202.109) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 11 Nov 2020 08:12:52 -0500
From:   Chris Brandt <chris.brandt@renesas.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        "Jesse Pfeister" <jpfeister@fender.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode
Date:   Wed, 11 Nov 2020 08:12:09 -0500
Message-ID: <20201111131209.3977903-1-chris.brandt@renesas.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_06:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 spamscore=0 mlxlogscore=983
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110075
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Renesas R-Car and RZ/G SoCs have a firmware download mode over USB.
However, on reset a banner string is transmitted out which is not expected
to be echoed back and will corrupt the protocol.

Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/usb/class/cdc-acm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 1e7568867910..f52f1bc0559f 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1693,6 +1693,15 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x045b, 0x023c),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x0248),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
 	{ USB_DEVICE(0x0e8d, 0x0003), /* FIREFLY, MediaTek Inc; andrey.arapov@gmail.com */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
-- 
2.28.0

