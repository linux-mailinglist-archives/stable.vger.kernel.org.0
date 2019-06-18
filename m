Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C26C4AE1E
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 00:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730989AbfFRWsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 18:48:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41815 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730341AbfFRWsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 18:48:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id s21so1203923lji.8
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 15:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codecoup-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8772S93SESJK7k4owiJBKvos4eqPSCTz+wD3Mw1imI=;
        b=mXMRsfFQJAPYdse+uAWzSKjIfN/Lz/jZT/lIjbTE6baWDexkaNIIuOuBl5NTZgUpxy
         C3WQt7J3dYeE4jKl54hdzuUMT9Ucw+GCY34uHUS5FFgDA6Tt9V3nOswYfqJSlxCBXP74
         v0JcVx6sWmNLaiC40C0PB7Aj8jCZ3tIM73oTcKWHcjkElLZ5SA4+2pXnpTNjSyaJza3Y
         o7djHoGilHU0bLCEnMpkEFSNZ6Y9qf+/ETM3ddInToNTTUIwR3v0ub44HRSYHTOK8V5b
         ygCJpQdMY5Wqx0/Nz5iGR25tUMgneIJk65pUcs4mVOda+6zflGdsIjJqVXZGb7HR0bhj
         I4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8772S93SESJK7k4owiJBKvos4eqPSCTz+wD3Mw1imI=;
        b=e67UcRy7s3p2DoHguJLNesnlgvKx3qJtfxcPLCcdgVIQubbRrxD2CpVQuIN0U7NwHJ
         PW6XG9FvLDBF9wkPDlH4h+/D01Ou/CLSLssiK8LNy5StEQhBn+cDND8z/ohJedDr9wGF
         bny753MB8Bn9mOJfU3opawOhdPlpmdIWd7qfTiDeokuNNUtebXglWNF3yS0PW8czK/n7
         SWFIvN06EmL9ZBxXolLWzkTMUddyBjQSCfzHbgM90CUMHDQ6IH4T7OwHqZ80xCmjtkbh
         UWLpU2TPo2DimwCHurKVuBps1jhG2pMiRYJ3ALqrFQgz08mYKgtkwI6o4I0NiY/KX00x
         8eUQ==
X-Gm-Message-State: APjAAAUYFzjGgTW4ID3KPWl9ngbScbBvdYeMMEQMiGXHWNugmA9xCRdj
        ebSYc8C1A6qk3F0AJ8NHCVvt3w==
X-Google-Smtp-Source: APXvYqyAjiVKxCOYRa3BP9kn0EdaEbwl1LmG/mIuTFk7SJGcqL1RixwWU93f2PljEzxkooclI8d2fQ==
X-Received: by 2002:a2e:3807:: with SMTP id f7mr24271929lja.87.1560898117578;
        Tue, 18 Jun 2019 15:48:37 -0700 (PDT)
Received: from localhost.localdomain (ftth-nat-19.ip4.greenlan.pl. [185.56.210.19])
        by smtp.gmail.com with ESMTPSA id h11sm2398837lfm.14.2019.06.18.15.48.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 15:48:36 -0700 (PDT)
From:   Szymon Janc <szymon.janc@codecoup.pl>
To:     linux-bluetooth@vger.kernel.org
Cc:     Szymon Janc <szymon.janc@codecoup.pl>,
        Maarten Fonville <maarten.fonville@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] Bluetooth: SMP: Workaround Microsoft Surface Precision Mouse bug
Date:   Wed, 19 Jun 2019 00:47:47 +0200
Message-Id: <20190618224747.446-1-szymon.janc@codecoup.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Microsoft Surface Precision Mouse provides bogus identity address when
pairing. It connects with Static Random address but provides Public
Address in SMP Identity Address Information PDU. Address has same
value but type is different. Workaround this by dropping IRK if ID
address discrepancy is detected.

> HCI Event: LE Meta Event (0x3e) plen 19
      LE Connection Complete (0x01)
        Status: Success (0x00)
        Handle: 75
        Role: Master (0x00)
        Peer address type: Random (0x01)
        Peer address: E0:52:33:93:3B:21 (Static)
        Connection interval: 50.00 msec (0x0028)
        Connection latency: 0 (0x0000)
        Supervision timeout: 420 msec (0x002a)
        Master clock accuracy: 0x00

....

> ACL Data RX: Handle 75 flags 0x02 dlen 12
      SMP: Identity Address Information (0x09) len 7
        Address type: Public (0x00)
        Address: E0:52:33:93:3B:21

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Tested-by: Maarten Fonville <maarten.fonville@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199461
Cc: stable@vger.kernel.org
---
 net/bluetooth/smp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index e68c715f8d37..d528d95a2c27 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2579,6 +2579,20 @@ static int smp_cmd_ident_addr_info(struct l2cap_conn *conn,
 		goto distribute;
 	}
 
+	/*
+	 * Drop IRK if peer is using identity address during pairing but is
+	 * providing different address as identity information.
+	 *
+	 * Microsoft Surface Precision Mouse is known to have this bug.
+	 */
+	if (hci_is_identity_address(&hcon->dst, hcon->dst_type) &&
+	    (bacmp(&info->bdaddr, &hcon->dst) ||
+	     info->addr_type != hcon->dst_type)) {
+		bt_dev_err(hcon->hdev,
+			   "ignoring IRK with invalid identity address");
+		goto distribute;
+	}
+
 	bacpy(&smp->id_addr, &info->bdaddr);
 	smp->id_addr_type = info->addr_type;
 
-- 
2.21.0

