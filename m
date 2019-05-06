Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C76014F49
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfEFOfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfEFOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1171214AE;
        Mon,  6 May 2019 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153331;
        bh=/CtsiC3QKIiq+eFj1WiGdmRM56VbB/uKlEKnvHHzNXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOj8bBXfKPGT7Mwtry1ykmmQJcDceyZeIzNZ0bPxKTcYFKYskkRl8Y5xH42re7p7b
         Iejjsx5KX2JDpcHk1KB2oG5tRi9l1jKIuBSr6C8uoBlHlaoIZQrLDB0EWpqOibEiFc
         1K6+h977BhlOLWQ3ygPrk44MBRh63ukn7w44Be1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jiri Kosina <jkosina@suse.cz>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 027/122] HID: logitech: check the return value of create_singlethread_workqueue
Date:   Mon,  6 May 2019 16:31:25 +0200
Message-Id: <20190506143057.185665784@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6c44b15e1c9076d925d5236ddadf1318b0a25ce2 ]

create_singlethread_workqueue may fail and return NULL. The fix checks if it is
NULL to avoid NULL pointer dereference.  Also, the fix moves the call of
create_singlethread_workqueue earlier to avoid resource-release issues.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index f040c8a7f9a9..199cc256e9d9 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2111,6 +2111,13 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
 		kfree(data);
 		return -ENOMEM;
 	}
+	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
+	if (!data->wq) {
+		kfree(data->effect_ids);
+		kfree(data);
+		return -ENOMEM;
+	}
+
 	data->hidpp = hidpp;
 	data->feature_index = feature_index;
 	data->version = version;
@@ -2155,7 +2162,6 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
 	/* ignore boost value at response.fap.params[2] */
 
 	/* init the hardware command queue */
-	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
 	atomic_set(&data->workqueue_size, 0);
 
 	/* initialize with zero autocenter to get wheel in usable state */
-- 
2.20.1



