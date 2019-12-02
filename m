Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7633310E8EB
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfLBKbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39042 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLBKbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so40393564wrt.6
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Iqx8Ht1ZGNVIIH/KCqKXiFs77tmuv1VNOT/G4PBiB98=;
        b=AYCVz9Mj70QL0XbsrsU/JZy34sTyR0ekP5Owc8uPqLyT+CYPQasAotsQWiaT/fX6I9
         hAD6QOIx1piv6xTI9FEJ2JIaKoEo4W4VeLK1HARFUAzJlmBAlb+n4yXeJPIA1OiE0KKx
         1yYdP5/K5WRk19VajM3TAKH2aJljY2hJS4J5WWVAiwISc8L03WXsKYAor/to6gpYXC1b
         7260MTEmcZWR9EBHsxfb0Ps3y7OosFoy9JyUmqynwGGtVIG3gJOTYhD4TBziQB1nt8qR
         vWxGJ4oPUZBKbkpJ2PZYiOHYgrC6y92KjhrkSeK8UbIuS/5QYM4KWDxxhahItsxV5fDI
         Nd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iqx8Ht1ZGNVIIH/KCqKXiFs77tmuv1VNOT/G4PBiB98=;
        b=sqlIvjZJjvOvdmnPLTkwi01asNbKBWwN4IbGGyjzsXgOHxEFaHzzWQJ4SZCFsRjMp2
         WStIQR+8xLliUvSeHsgAK7Srw7EvFQtOduhsCp1EixUB6I3/qOIAyFmuIypLGNq6fN7f
         Clr2/Gbt0PvtM3DzChJd/TDqxzSC+ubDm2+rceP7w0+pCLQwkcBTTJg5jZbCLOwvyysm
         gFUtN5+WFxMcXOz/sXBpC7+SsHV3ZgVTRXUeZbBAPgWiZjncaq4Exn32l3OweQ12k5Df
         yLbP6Srb7eVWsZLlEwPvTylJQ4zYD8+CqJTF8YZ3IpdwfhdB5WDcknbOKaopSU2IC4fs
         qNcw==
X-Gm-Message-State: APjAAAWrl5AfZn0uh0Yp/JaXygTCjdGKDT68CSOmGoNmzBtDY5IiO9ay
        2bZNNFPCFTMPcQo1VLp0KepRvLxqvwo=
X-Google-Smtp-Source: APXvYqxW0Bx75OZxb0mKRlOzinefKdtjv5v08ARwWOK+YJWgPl8Itlbe0iv7MFhNldrDbfj1/cy5WA==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr24599819wru.6.1575282680736;
        Mon, 02 Dec 2019 02:31:20 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:20 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 12/15] net: macb driver, check for SKBTX_HW_TSTAMP
Date:   Mon,  2 Dec 2019 10:30:47 +0000
Message-Id: <20191202103050.2668-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Thomas <pthomas8589@gmail.com>

[ Upstream commit a62520473f15750cd1432d36b377a06cd7cff8d2 ]

Make sure SKBTX_HW_TSTAMP (i.e. SOF_TIMESTAMPING_TX_HARDWARE) has been
enabled for this skb. It does fix the issue where normal socks that
aren't expecting a timestamp will not wake up on select, but when a
user does want a SOF_TIMESTAMPING_TX_HARDWARE it does work.

Signed-off-by: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d98077ab306b..005fee2dd0e6 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -860,7 +860,9 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (gem_ptp_do_txstamp(queue, skb, desc) == 0) {
+				if (unlikely(skb_shinfo(skb)->tx_flags &
+					     SKBTX_HW_TSTAMP) &&
+				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
 					/* skb now belongs to timestamp buffer
 					 * and will be removed later
 					 */
-- 
2.24.0

