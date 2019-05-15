Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9A41F0B7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfEOLYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731809AbfEOLY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E828D20843;
        Wed, 15 May 2019 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919467;
        bh=Z1+mqXLAirFvbmvmCUIXTQaG/lgWQ7ZQ8Dub1uR1z1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDKXR9mWumjyAG5z8Tvryq9fNzZ+lzVySv/D0HAXWZkTFOeHRBAcwQn1yneiOa7lY
         29AzZyT6n0UDE5i9SJ5xV6Dp7nV5UxFkxHgrTqX68Rs73lD/MSNmD21ipx2zv9yS8l
         OuNgThTNQO/VOCsGj/VbZVXSpfb70aOpTO9glDHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 084/113] rtlwifi: rtl8723ae: Fix missing break in switch statement
Date:   Wed, 15 May 2019 12:56:15 +0200
Message-Id: <20190515090700.019427985@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 84242b82d81c54e009a2aaa74d3d9eff70babf56 upstream.

Add missing break statement in order to prevent the code from falling
through to case 0x1025, and erroneously setting rtlhal->oem_id to
RT_CID_819X_ACER when rtlefuse->eeprom_svid is equal to 0x10EC and
none of the cases in switch (rtlefuse->eeprom_smid) match.

This bug was found thanks to the ongoing efforts to enable
-Wimplicit-fallthrough.

Fixes: 238ad2ddf34b ("rtlwifi: rtl8723ae: Clean up the hardware info routine")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1699,6 +1699,7 @@ static void _rtl8723e_read_adapter_info(
 					rtlhal->oem_id = RT_CID_819X_LENOVO;
 					break;
 				}
+				break;
 			case 0x1025:
 				rtlhal->oem_id = RT_CID_819X_ACER;
 				break;


