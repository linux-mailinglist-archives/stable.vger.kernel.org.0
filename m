Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E232600C6
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgIGQe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730746AbgIGQeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C9C21D7D;
        Mon,  7 Sep 2020 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496451;
        bh=Cez5YrJMd+kRD6GKDOhBagZay32pDINJhG2yn//Ywjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDKWCeMr4Ap5xJFa5UT4D7lKqKQ4Xs1UA5w1TxwbFkB1n8ZYPzk41K2wEr+R0QekX
         wIphsmO+pAnNnSCgrE+VBwUZZsyw84T5mBAiaKa9q23mST2X6pGINsTa4Lgy9oVpB9
         FZLD77UoiTvj0UMIyXr7cu5eA50z8acsaHIzjR/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/43] HID: elan: Fix memleak in elan_input_configured
Date:   Mon,  7 Sep 2020 12:33:19 -0400
Message-Id: <20200907163329.1280888-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit b7429ea53d6c0936a0f10a5d64164f0aea440143 ]

When input_mt_init_slots() fails, input should be freed
to prevent memleak. When input_register_device() fails,
we should call input_mt_destroy_slots() to free memory
allocated by input_mt_init_slots().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-elan.c b/drivers/hid/hid-elan.c
index 45c4f888b7c4e..dae193749d443 100644
--- a/drivers/hid/hid-elan.c
+++ b/drivers/hid/hid-elan.c
@@ -188,6 +188,7 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	ret = input_mt_init_slots(input, ELAN_MAX_FINGERS, INPUT_MT_POINTER);
 	if (ret) {
 		hid_err(hdev, "Failed to init elan MT slots: %d\n", ret);
+		input_free_device(input);
 		return ret;
 	}
 
@@ -198,6 +199,7 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	if (ret) {
 		hid_err(hdev, "Failed to register elan input device: %d\n",
 			ret);
+		input_mt_destroy_slots(input);
 		input_free_device(input);
 		return ret;
 	}
-- 
2.25.1

