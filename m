Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713A3406170
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhIJAmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhIJASn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D59A611C2;
        Fri, 10 Sep 2021 00:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233032;
        bh=EBKRkFeXmpsBAyqMWL8YMuJwzysuEp6koplyXOSW8iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoEQQmMbS6CgzkiYqQJHwyuqCgoThdBhHjeqBdd7DJ50/dA2hyb6g4XORVBI8YALm
         +VV/b3fu75Y0VjDWM4kMcu/g8VmyIIfwqd35HqMxlDLL5nn7iefWUXLbbCtwWEgfuI
         ts9/pFG2l4qRlRVcBt0VPBoo55g3924//RgUcmnz3z+VjBrb+SOoBZy8kCz3AiAVpG
         1RxnOzv5PAZwQmXNx9Z2d1cbrINsyTMUuazGGo7KwenKI94F7vvzy+Up9MYMRgUTBy
         STPL8S1Bbzj9OLD/vVeDZNMXERh2FYnjlJHAwaR4iYtp4dl8W/pl+VN71bpgHMLO6x
         O6moBSB3CuRJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 53/99] HID: thrustmaster: Fix memory leaks in probe
Date:   Thu,  9 Sep 2021 20:15:12 -0400
Message-Id: <20210910001558.173296-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit d0f1d5ae23803bd82647a337fa508fa8615defc5 ]

When thrustmaster_probe() handles errors of usb_submit_urb() it does not
free allocated resources and fails. The patch fixes that.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index cdc7d82ae9ed..e94d3409fd10 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -336,11 +336,14 @@ static int thrustmaster_probe(struct hid_device *hdev, const struct hid_device_i
 	);
 
 	ret = usb_submit_urb(tm_wheel->urb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		hid_err(hdev, "Error %d while submitting the URB. I am unable to initialize this wheel...\n", ret);
+		goto error6;
+	}
 
 	return ret;
 
+error6: kfree(tm_wheel->change_request);
 error5: kfree(tm_wheel->response);
 error4: kfree(tm_wheel->model_request);
 error3: usb_free_urb(tm_wheel->urb);
-- 
2.30.2

