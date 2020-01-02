Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C2512ECC0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgABWV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgABWV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:21:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEA032253D;
        Thu,  2 Jan 2020 22:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003687;
        bh=L1eRcQZCIbPpjbfa3ub2lWJDnPPPqYK93Pv7mxJolxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNC3DJ8DpVF8AzOnDooiJIYKr3JDWPp3WuaKCC+OFVx3LyuMhOQXmK7U1c17GSlJ1
         TUsdviE4cFp4Ptwaa/LhtnaZ+sNOmJaYoyOAhD+5JZo5r/aWooLpdv7IOz+U/GRSFD
         n10R+xNS8l/yH69cdrl4V4bWrggFu9bm7Eeor7yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bla=C5=BE=20Hrastnik?= <blaz@mxxn.io>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/114] HID: Improve Windows Precision Touchpad detection.
Date:   Thu,  2 Jan 2020 23:07:01 +0100
Message-Id: <20200102220034.018208756@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Blaž Hrastnik <blaz@mxxn.io>

[ Upstream commit 2dbc6f113acd74c66b04bf49fb027efd830b1c5a ]

Per Microsoft spec, usage 0xC5 (page 0xFF) returns a blob containing
data used to verify the touchpad as a Windows Precision Touchpad.

   0x85, REPORTID_PTPHQA,    //    REPORT_ID (PTPHQA)
    0x09, 0xC5,              //    USAGE (Vendor Usage 0xC5)
    0x15, 0x00,              //    LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,        //    LOGICAL_MAXIMUM (0xff)
    0x75, 0x08,              //    REPORT_SIZE (8)
    0x96, 0x00, 0x01,        //    REPORT_COUNT (0x100 (256))
    0xb1, 0x02,              //    FEATURE (Data,Var,Abs)

However, some devices, namely Microsoft's Surface line of products
instead implement a "segmented device certification report" (usage 0xC6)
which returns the same report, but in smaller chunks.

    0x06, 0x00, 0xff,        //     USAGE_PAGE (Vendor Defined)
    0x85, REPORTID_PTPHQA,   //     REPORT_ID (PTPHQA)
    0x09, 0xC6,              //     USAGE (Vendor usage for segment #)
    0x25, 0x08,              //     LOGICAL_MAXIMUM (8)
    0x75, 0x08,              //     REPORT_SIZE (8)
    0x95, 0x01,              //     REPORT_COUNT (1)
    0xb1, 0x02,              //     FEATURE (Data,Var,Abs)
    0x09, 0xC7,              //     USAGE (Vendor Usage)
    0x26, 0xff, 0x00,        //     LOGICAL_MAXIMUM (0xff)
    0x95, 0x20,              //     REPORT_COUNT (32)
    0xb1, 0x02,              //     FEATURE (Data,Var,Abs)

By expanding Win8 touchpad detection to also look for the segmented
report, all Surface touchpads are now properly recognized by
hid-multitouch.

Signed-off-by: Blaž Hrastnik <blaz@mxxn.io>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index b0c8fae7f903..3a359716fb38 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -780,6 +780,10 @@ static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
 	if (usage == 0xff0000c5 && parser->global.report_count == 256 &&
 	    parser->global.report_size == 8)
 		parser->scan_flags |= HID_SCAN_FLAG_MT_WIN_8;
+
+	if (usage == 0xff0000c6 && parser->global.report_count == 1 &&
+	    parser->global.report_size == 8)
+		parser->scan_flags |= HID_SCAN_FLAG_MT_WIN_8;
 }
 
 static void hid_scan_collection(struct hid_parser *parser, unsigned type)
-- 
2.20.1



