Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407BD40E564
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348520AbhIPRLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349870AbhIPRHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107BA6058D;
        Thu, 16 Sep 2021 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810194;
        bh=kNuUBg/QNlWgTbs4CpCjDCNixvrovJ6aZHwZm0Jkq7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egteq47U5Z7MgHl5gNV8i2wLTfiehLYOCNM02EC763FaGsRc5DnVS/S60ckE304ka
         CtjbW6ft7O2YwL8+yBhVEiubaoHCdGuT9BHpjJ96tOzChNSBN5TPUtTkwLTVHnNpxy
         kMSRP00ihfhe9ovNrf8V5qlaKEpeGkMp5RrtE9Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingle Wu <jingle.wu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.14 024/432] Input: elan_i2c - reduce the resume time for controller in Whitebox
Date:   Thu, 16 Sep 2021 17:56:13 +0200
Message-Id: <20210916155811.641292658@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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


