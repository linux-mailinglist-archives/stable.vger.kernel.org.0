Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA3A94E0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 23:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfIDVW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 17:22:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46709 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfIDVW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 17:22:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so82063pfg.13
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 14:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JvwLgkmmjAl628Brus4ThOE7t466M3kG5Shz3vvX9xI=;
        b=xFsLkED3YwWJ799oa/ZPkIypkSR+u/J+K+ES+ZG9ErRX9tp/WJSwlsiRHjOqWVKBC/
         yiSVBI6V/H8lvU6S3A5xGhDVugkNW5x/9UhwX6yU09iuLTDH3Epobr3yuVVALL+Ei5Ea
         5Eohcwj8bbsuoZ4cKalD+aP+AEs/WcIjshkZwEZkLPjGZ7MIcEVZkAulElE+zBwn02MI
         ypYLiNcgNnksgjrMc/eGqNxd9mBjgeKDYKeRQ0ZW3dKN3ZGL/rT3xdvFd1tx/JXwNW12
         UALpa3OTbgFEJxms5HB70VbssMEzuPHPG8aZblc7BzAr8YWfyNQr/0npREjaNsUB1mYe
         qXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JvwLgkmmjAl628Brus4ThOE7t466M3kG5Shz3vvX9xI=;
        b=uRdVCGwA+DSI/CYOFaUDOGdtxhn9mzn8MefqHwKZbDysQfGDEVija3AfLQ485sfxER
         NCVLivovlG6DNlQRpkB3/fNqHabHE0VTPboGSfviauL1aWCGJ/4YdQUPRqVnl+EgstHE
         zcxhffxkJZFIE0qt99/UXTULHCCDd8x+rQJzwhXqZFie42PZj99HrvuEZ3JAdGCcNW5l
         MI6b6awWPkyJ239iPZhW4qkS2GHZibXUXSMJP6/1hAnbOMH31jeVfAXfdJeKNaCjVRoK
         diqxOQ042R5CH7nLAT7IWAdO3DQMzfFuJEvPxMJqRgU8/Zc0YXDbeipvASIVS+hS9N7P
         0Y2g==
X-Gm-Message-State: APjAAAUJmfd72blgvu+piav3agahlAOs2FsfGB5YZB2cDzgQsgk4ScCG
        E8mbw+Z5v0yE7FzWoTMEm4MklQ==
X-Google-Smtp-Source: APXvYqxDXXyrTmUib/0fnG6GcGHc9UZ0ahc7wkm9JaUgcGRUiDHgygqusTfszzwituXj92wddxZ9vQ==
X-Received: by 2002:a63:3387:: with SMTP id z129mr149653pgz.177.1567632147070;
        Wed, 04 Sep 2019 14:22:27 -0700 (PDT)
Received: from roderick.ad.gaikai.biz ([100.42.98.196])
        by smtp.gmail.com with ESMTPSA id h186sm1505103pfb.63.2019.09.04.14.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 14:22:25 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        andreyknvl@google.com
Cc:     Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH] HID: sony: Fix memory corruption issue on cleanup.
Date:   Wed,  4 Sep 2019 14:22:11 -0700
Message-Id: <20190904212211.29832-1-roderick@gaikai.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roderick Colenbrander <roderick.colenbrander@sony.com>

The sony driver is not properly cleaning up from potential failures in
sony_input_configured. Currently it calls hid_hw_stop, while hid_connect
is still running. This is not a good idea, instead hid_hw_stop should
be moved to sony_probe. Similar changes were recently made to Logitech
drivers, which were also doing improper cleanup.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
---
 drivers/hid/hid-sony.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 31f1023214d3..09f2c617b09f 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2806,7 +2806,6 @@ static int sony_input_configured(struct hid_device *hdev,
 	sony_cancel_work_sync(sc);
 	sony_remove_dev_list(sc);
 	sony_release_device_id(sc);
-	hid_hw_stop(hdev);
 	return ret;
 }
 
@@ -2868,6 +2867,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 */
 	if (!(hdev->claimed & HID_CLAIMED_INPUT)) {
 		hid_err(hdev, "failed to claim input\n");
+		hid_hw_stop(hdev);
 		return -ENODEV;
 	}
 
-- 
2.21.0

