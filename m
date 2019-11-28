Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940A410CE7D
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 19:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfK1SYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 13:24:43 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37275 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1SYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 13:24:43 -0500
Received: by mail-lj1-f194.google.com with SMTP id u17so2029261lja.4;
        Thu, 28 Nov 2019 10:24:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++fr2irPtIHzb3D2aK7SmOZd1oRSgJeu/nXnMOMaZ3Y=;
        b=pRxsRl2ZLi4epkNifiUSVR8pEOyXwX1WmsJHrO9XCXeAaVWe++GqzX6HFwhCJDTy6V
         /nFgWgsMNYoVe4d99jt9nta9gv13xL6MxgHw1QBi5Jyum1nrjZFfieMcOI+dDUov6mAb
         TNU1Ncx4ax2ijKYDTaDuipbRiE56s+M/i7r9xjuPpThgDn4G4NIS2qw8IowejrhWU8yB
         gfMvCJftccMmMM6w5YIKR4ZVjXJuUkFsZjODVkBVWRpzuP/DsIfR5Jg9AzA8UpRZbM5u
         t737BHPcW2uXY0Kqdq4i88r0RrMvDqWRTjZD4bxxPhLGGCmUlVAkJ9WM0b8T8Eyskpv2
         mutg==
X-Gm-Message-State: APjAAAW0jhjagfTmmfgDDYpu0TUNs6rv9eZIIY47YebyNA/x+u1hB1bt
        UY4e8O0CYKVbRA854rq4u6E=
X-Google-Smtp-Source: APXvYqxCIuCGnMbisCv+anAiHCumcyWZp1jEOHberaOJFCNbtaOm/QQxqVUXaIF5C+68Wfl0SPCp0g==
X-Received: by 2002:a2e:910b:: with SMTP id m11mr10635547ljg.213.1574965480607;
        Thu, 28 Nov 2019 10:24:40 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id a12sm4261166ljk.48.2019.11.28.10.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 10:24:39 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaOT2-0005hW-AA; Thu, 28 Nov 2019 19:24:40 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH] Bluetooth: btusb: fix non-atomic allocation in completion handler
Date:   Thu, 28 Nov 2019 19:24:27 +0100
Message-Id: <20191128182427.21873-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB completion handlers are called in atomic context and must
specifically not allocate memory using GFP_KERNEL.

Fixes: a1c49c434e15 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
Cc: stable <stable@vger.kernel.org>     # 5.3
Cc: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 70e385987d41..b6bf5c195d94 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2602,7 +2602,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		 * and being processed the events from there then.
 		 */
 		if (test_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags)) {
-			data->evt_skb = skb_clone(skb, GFP_KERNEL);
+			data->evt_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!data->evt_skb)
 				goto err_out;
 		}
-- 
2.24.0

