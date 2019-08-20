Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2D9610F
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfHTNpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbfHTNm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:59 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E26230F2;
        Tue, 20 Aug 2019 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308578;
        bh=UqPLbRUjKob2xRECZCZzqGiSacjK3QK0Y260YxC6SuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTkJ4kWbrAa4WIU4AEhAnI6RPVU9OT7PrccZYQ75PV10i55X9c/VfAMB17KBrxKgQ
         STtOpesVq/Q5h2Fa6Q7nIB/8IG4McwaJX5HOkou5Ypz2wp3qFozhif/wK23neKko0l
         94zA+ohsXDuOKCti69v4kBhvNHdfK/hFGbC44YWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 03/12] auxdisplay: panel: need to delete scan_timer when misc_register fails in panel_attach
Date:   Tue, 20 Aug 2019 09:42:44 -0400
Message-Id: <20190820134253.11562-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134253.11562-1-sashal@kernel.org>
References: <20190820134253.11562-1-sashal@kernel.org>
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
index 6911acd896d93..e30953ceb7dfd 100644
--- a/drivers/auxdisplay/panel.c
+++ b/drivers/auxdisplay/panel.c
@@ -1622,6 +1622,8 @@ static void panel_attach(struct parport *port)
 	return;
 
 err_lcd_unreg:
+	if (scan_timer.function)
+		del_timer_sync(&scan_timer);
 	if (lcd.enabled)
 		charlcd_unregister(lcd.charlcd);
 err_unreg_device:
-- 
2.20.1

