Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0CD22F118
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgG0O3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732009AbgG0OXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C552070A;
        Mon, 27 Jul 2020 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859785;
        bh=CNA2UcGDHuCk9lpCPB6VSEaq6G3lroCk8+yxTtXAEhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1pa5/nvBoIR4ZFwjh5B1Az1PQRbAM/kOAXxBnzs7myPrXHTn7DhL1nMq8izyjfPd
         TOam1KQm4mwyUD4dqEOYSu0iiR8jdJAytIOH0qmsZ112oJqnITpo7RCDvhAC2A9Jas
         7aPL9W1nbcJC8nmoF/whm5V97ukdw+lrnVW9Vg3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>,
        Siarhei Vishniakou <svv@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/179] HID: steam: fixes race in handling device list.
Date:   Mon, 27 Jul 2020 16:04:39 +0200
Message-Id: <20200727134937.717489856@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>

[ Upstream commit 2d3f53a80e4eed078669853a178ed96d88f74143 ]

Using uhid and KASAN this driver crashed because it was getting
several connection events where it only expected one. Then the
device was added several times to the static device list and it got
corrupted.

This patch checks if the device is already in the list before adding
it.

Signed-off-by: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
Tested-by: Siarhei Vishniakou <svv@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 6286204d4c560..a3b151b29bd71 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -526,7 +526,8 @@ static int steam_register(struct steam_device *steam)
 			steam_battery_register(steam);
 
 		mutex_lock(&steam_devices_lock);
-		list_add(&steam->list, &steam_devices);
+		if (list_empty(&steam->list))
+			list_add(&steam->list, &steam_devices);
 		mutex_unlock(&steam_devices_lock);
 	}
 
@@ -552,7 +553,7 @@ static void steam_unregister(struct steam_device *steam)
 		hid_info(steam->hdev, "Steam Controller '%s' disconnected",
 				steam->serial_no);
 		mutex_lock(&steam_devices_lock);
-		list_del(&steam->list);
+		list_del_init(&steam->list);
 		mutex_unlock(&steam_devices_lock);
 		steam->serial_no[0] = 0;
 	}
@@ -738,6 +739,7 @@ static int steam_probe(struct hid_device *hdev,
 	mutex_init(&steam->mutex);
 	steam->quirks = id->driver_data;
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
+	INIT_LIST_HEAD(&steam->list);
 
 	steam->client_hdev = steam_create_client_hid(hdev);
 	if (IS_ERR(steam->client_hdev)) {
-- 
2.25.1



