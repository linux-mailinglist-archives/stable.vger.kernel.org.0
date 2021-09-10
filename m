Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC040621D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbhIJAoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhIJAUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1DA061167;
        Fri, 10 Sep 2021 00:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233167;
        bh=OFE96SrViNGgdmp3zfqPBD3pHqDhksQvjOmzGukE/FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvrJCRhhQfDfRsEYFoKFdVcDkGW6M9s56kHSCzyKod+1YsoeieHYQvblyVXumtqbT
         EbpYAYrBvQIoSGQV6ftap5I9JQGR0yXAKYYa85kT2J+7yZydvaifNF6e6DIs6tuZOX
         Swo//S89MTIn51mFKd1NrhyI4w6KsLyVuqVzOqkRiCE2SQQ2VJDQup6m5+8Z3zrstg
         Tpkdx9KNKHp8LouSMNZMLm/kn0kVlKoaHsq2wL8MQ5wn6Y66Qga50J1wM0m1UfTcPa
         W2BauEmX/DG3H30nK4uwVZIq3A72rowdYDd0k3K1Qo3aw43Oyig97VZpOZ9nlPWWWw
         WGFV0r47GzCmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 47/88] HID: thrustmaster: Fix memory leaks in probe
Date:   Thu,  9 Sep 2021 20:17:39 -0400
Message-Id: <20210910001820.174272-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index f643b1cb112d..eede9d676bd4 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -335,11 +335,14 @@ static int thrustmaster_probe(struct hid_device *hdev, const struct hid_device_i
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

