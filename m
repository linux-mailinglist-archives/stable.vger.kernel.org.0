Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE140E171
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241504AbhIPQag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241579AbhIPQ1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195C0615E1;
        Thu, 16 Sep 2021 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809061;
        bh=kNuUBg/QNlWgTbs4CpCjDCNixvrovJ6aZHwZm0Jkq7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eO+zHvIuu+PaVdFwqF3BHQDQsSypAvmpBIB9xdEFbzgd3OBvLb3D1lQ457OBxkgx
         bQ4Pu3t/Ay+UfZCk+5dvfkM7/mAb/xeFMdIVKcMWdhIBKjNtDyWh8L044C5cgDKt4H
         EgNaKCPyTwgijL3CnEN4u4hM6UrnyphdMwlD9hlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingle Wu <jingle.wu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.13 017/380] Input: elan_i2c - reduce the resume time for controller in Whitebox
Date:   Thu, 16 Sep 2021 17:56:14 +0200
Message-Id: <20210916155804.557445533@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jingle.wu <jingle.wu@emc.com.tw>

commit d198b8273e3006818ea287a93eb4d8fd2543e512 upstream.

Similar to controllers found Voxel, Delbin, Magpie and Bobba, the one found
in Whitebox does not need to be reset after issuing power-on command, and
skipping reset saves resume time.

Signed-off-by: Jingle Wu <jingle.wu@emc.com.tw>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210907012924.11391-1-jingle.wu@emc.com.tw
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c.h      |    3 ++-
 drivers/input/mouse/elan_i2c_core.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -55,8 +55,9 @@
 #define ETP_FW_PAGE_SIZE_512	512
 #define ETP_FW_SIGNATURE_SIZE	6
 
-#define ETP_PRODUCT_ID_DELBIN	0x00C2
+#define ETP_PRODUCT_ID_WHITEBOX	0x00B8
 #define ETP_PRODUCT_ID_VOXEL	0x00BF
+#define ETP_PRODUCT_ID_DELBIN	0x00C2
 #define ETP_PRODUCT_ID_MAGPIE	0x0120
 #define ETP_PRODUCT_ID_BOBBA	0x0121
 
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -105,6 +105,7 @@ static u32 elan_i2c_lookup_quirks(u16 ic
 		u32 quirks;
 	} elan_i2c_quirks[] = {
 		{ 0x0D, ETP_PRODUCT_ID_DELBIN, ETP_QUIRK_QUICK_WAKEUP },
+		{ 0x0D, ETP_PRODUCT_ID_WHITEBOX, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x10, ETP_PRODUCT_ID_VOXEL, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x14, ETP_PRODUCT_ID_MAGPIE, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x14, ETP_PRODUCT_ID_BOBBA, ETP_QUIRK_QUICK_WAKEUP },


