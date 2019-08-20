Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A2D9606B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfHTNkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfHTNkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:52 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E229C22DA9;
        Tue, 20 Aug 2019 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308451;
        bh=cxEIDZ6qlo3uS0oJ/qRrvlXUZgnglqFYn8m0C6igJEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9mnMeCxK1YhOv252Kp0SMCANjS4xU7yI36m+X6tSfdlvaAIv5I9jvpH05zQd0NlV
         ZfXwtXQcgn5Vln55JJZvvWE2WtgfRK4e7AceaBUYwK+G8eF5wpSPOYuRXDPC+pmVsZ
         Myr8IyK8chFnsfkEi80rl4j46Roj28rJr6brQGBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 21/44] auxdisplay: panel: need to delete scan_timer when misc_register fails in panel_attach
Date:   Tue, 20 Aug 2019 09:40:05 -0400
Message-Id: <20190820134028.10829-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit b33d567560c1aadf3033290d74d4fd67af47aa61 ]

In panel_attach, if misc_register fails, we need to delete scan_timer,
which was setup in keypad_init->init_scan_timer.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/panel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/auxdisplay/panel.c b/drivers/auxdisplay/panel.c
index e06de63497cf8..e6bd727da503a 100644
--- a/drivers/auxdisplay/panel.c
+++ b/drivers/auxdisplay/panel.c
@@ -1617,6 +1617,8 @@ static void panel_attach(struct parport *port)
 	return;
 
 err_lcd_unreg:
+	if (scan_timer.function)
+		del_timer_sync(&scan_timer);
 	if (lcd.enabled)
 		charlcd_unregister(lcd.charlcd);
 err_unreg_device:
-- 
2.20.1

