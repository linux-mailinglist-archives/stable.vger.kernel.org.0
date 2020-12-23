Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0F2E2049
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgLWSGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 13:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLWSGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 13:06:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DECC061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 10:05:35 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id n7so91344pgg.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 10:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sRmO1ouBuD9DaFoTCCJHHG9gde2RqfgzZ4W9UJlsBxE=;
        b=BCu9Zajcyh1WyJiomavi7N+3Pde0AKuvY1OlX2KnA7S5TGWRe1o9ASvZkWBDacs85J
         SW8Rfvkb+qRfYlbOH9W3/akBCpNC+L7SF1ECyLYxjtn5KAw1Wc5IoB0RCq9h86pXMjUp
         rLpOaP5d+bsXmw7JjntLSRlWvOdQrpoUd6/Ws7L5CtPJVQZYP/0eRwaJR/B2UvSJRWRw
         mjN/jwLSN21rQLJeiWnjS9p9n23/ZMjcJ9WkPScZdr9NNU6cGYO+siBmmUAO/1UgVtiM
         YTTmkuVeZ50v61qWyVFVFDmmxqk0YKXXn+VgoAw925hbDmDuT+d0CMZVR71G79xU3ZAt
         Xjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sRmO1ouBuD9DaFoTCCJHHG9gde2RqfgzZ4W9UJlsBxE=;
        b=MURUhY/DgCchzLoirPySFiUSW3Kkwe7EOlRidECeeuLDsGbkMNTRxD+BHM7PDG1xV4
         rqSW0QuHtgW86t8tMmJefB31ve3M4pT70HW2QAs56fN12Q4x3A0a9cgUXFtznN9EnYbV
         cyauoz+GXOZnL1b0RJ0a2IX7QLkE7JT8BbvAmnEkkTfr/uoZyQh7GjChlzbEcYd4CuAX
         xABvS7N0lF532RWhwHX1yIm2aHZ0o25TTsC8+VdYgyYi4TDuZ2d7d/oi6wma854pg0j8
         Db4Uw84GRulUvMDrJ6TTf7nbDILRhVYyQzoUEjCLBshtugifbxUrOidcza4IU2XemUeP
         gq9A==
X-Gm-Message-State: AOAM531/PvNYyXV0R4Pvwa5hbvOzv+oe99rIanHVk4+R7yjPGlD9dyeS
        lwLx1mhEY/W229Y5Przz1wi5rlqm+f7VwH4=
X-Google-Smtp-Source: ABdhPJyZD9D7PuIPRfat1VNi1FiXznOZl2OJOvYUXrLxvu7qHJ7tU0/L7FV+0CcSboZSrWam9hFelw==
X-Received: by 2002:a62:ae0c:0:b029:1a5:819d:9ac5 with SMTP id q12-20020a62ae0c0000b02901a5819d9ac5mr2931228pff.26.1608746734934;
        Wed, 23 Dec 2020 10:05:34 -0800 (PST)
Received: from localhost.localdomain (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id r67sm24240994pfc.82.2020.12.23.10.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 10:05:34 -0800 (PST)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     gregkh@linuxfoundation.org, marcel@holtmann.org
Cc:     stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH 4.14 4.9 4.4-stable] Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()
Date:   Wed, 23 Dec 2020 13:04:46 -0500
Message-Id: <20201223180446.17207-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f7e0e8b2f1b0a09b527885babda3e912ba820798 upstream.

`num_reports` is not being properly checked. A malformed event packet with
a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
of bounds. Fix it.

Backporting notes:
  - Rebased on linux-4.14.y, commit 3f2ecb86cb90 ("Linux 4.14.212")
  - Retested by syzbot

Cc: stable@vger.kernel.org
Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/hci_event.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ba12bf8de826..0db218b14bf3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5141,20 +5141,18 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
 	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
 
-	hci_dev_lock(hdev);
+	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
+		return;
 
-	while (num_reports--) {
-		struct hci_ev_le_direct_adv_info *ev = ptr;
+	hci_dev_lock(hdev);
 
+	for (; num_reports; num_reports--, ev++)
 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 				   ev->bdaddr_type, &ev->direct_addr,
 				   ev->direct_addr_type, ev->rssi, NULL, 0);
 
-		ptr += sizeof(*ev);
-	}
-
 	hci_dev_unlock(hdev);
 }
 
-- 
2.25.1

