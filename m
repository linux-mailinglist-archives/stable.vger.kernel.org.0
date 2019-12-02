Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C23110E82A
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfLBKED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36525 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfLBKED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so16575321wma.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5ZVa6kq1mJCk2ugA3PttYrwn9cQp3DBRKWj2cZpAQC4=;
        b=r59hMrsFxVfzeFoTz55x4dEZj/jaxCJ6PqtUrFgBI+Thwk+qA96TIB/fDPS+MshGcJ
         yHBCKM6lZcVaS9DpjZ6/6RYFfBD8cPvQnrJaPKtlkUWRBsCdHve7S0szJupAd6drknA0
         So4K7p1mgWucq1tDg3+phTF27WpmySKSCQYRD8kaqoL7UbCVOpB6cvHoWCRfXF7RCbMQ
         vVKClLa0p2Uor9lJJKVuNw6bL6Esjq4ctNCJizp5ExG89EzEFSwJbmSh8au/L4jkv228
         xm4WsEF2cm+/r2kRf0WHBatanLa2TLg87wO33cCUITqIeMRO/UlxigWPTYVbpNCIzGJi
         wkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ZVa6kq1mJCk2ugA3PttYrwn9cQp3DBRKWj2cZpAQC4=;
        b=Fy2+F4/y6BFYVSbHSgK9MmlPry1t8olByqXSVrVUi79Pbm0BdwY0pnhHCU2oNux5hX
         W9VjEbuIPoOpCnGt8WG7HYUl3d7yU8xXoGewZPNRbvM9fVRzDMfXP3k+mlUfRDpA3H0N
         G3Yhy6+9nNqQS7hA/bdEZNhb79WBHucm8FYIp5zq+355Xn8cNmYfaiEuAtckZ14yQjJ4
         OLYlmozpZfCc4pX6vPP1UjMKZD0a8eJSV2lOWfnfDFslOZyIMoxBsxPWOzuSrflamanD
         /hZgGuXgELxk6HO6mbBgJjBpgeM6OTPp6AkwL4/zQKfsjHgarQ4ZLCZBQ3XhRTumVakX
         qlOg==
X-Gm-Message-State: APjAAAUz63e/BXdFsRY9GMu76cGq4H9i+nmFGhB98iHGIn5zTDIYscGw
        JrZOxwPBGPhJ9oleWhhHLD/lGAC7YLQ=
X-Google-Smtp-Source: APXvYqwJiYaZucUMtM53bVJ/ZYIiuujIwZQG+uBYt7zrbdIQ6k3V51jmt2DFuCrVjj2yiBqbklFwuw==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr15275918wml.172.1575281040806;
        Mon, 02 Dec 2019 02:04:00 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:59 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 11/14] net: macb driver, check for SKBTX_HW_TSTAMP
Date:   Mon,  2 Dec 2019 10:03:09 +0000
Message-Id: <20191202100312.1397-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index bc9ab227d055..5aff1b460151 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -852,7 +852,9 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 
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

