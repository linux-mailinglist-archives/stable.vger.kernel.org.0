Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C72C9A94
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgLAI66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388042AbgLAI66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC60221FD;
        Tue,  1 Dec 2020 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813122;
        bh=tEbF9PCNWK2JOYfpN4cidgR+ttLyUUfOl1UQEYaWWU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efGlvwi4KbiYdoifLyM2F2jyWi1VukRDGY6EHpL8BLfXQ2WxK0OSWREaQvARB3plo
         lqL6rSkfAHXjsjiEsvJ7HU/EII/JsF+Q3exeQpkTOw0vzyO1eqHVTfT7qX1nfwF6r+
         ngq9ieFj+GUjgabwM9epAvK/IO7okgEDultPGgig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tosk Robot <tencent_os_robot@tencent.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/50] platform/x86: toshiba_acpi: Fix the wrong variable assignment
Date:   Tue,  1 Dec 2020 09:53:39 +0100
Message-Id: <20201201084650.007246981@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

[ Upstream commit 2a72c46ac4d665614faa25e267c3fb27fb729ed7 ]

The commit 78429e55e4057 ("platform/x86: toshiba_acpi: Clean up
variable declaration") cleans up variable declaration in
video_proc_write(). Seems it does the variable assignment in the
wrong place, this results in dead code and changes the source code
logic. Fix it by doing the assignment at the beginning of the funciton.

Fixes: 78429e55e4057 ("platform/x86: toshiba_acpi: Clean up variable declaration")
Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Link: https://lore.kernel.org/r/1606024177-16481-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 8221e000c8c23..25955b4d80b0d 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1497,7 +1497,7 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 	struct toshiba_acpi_dev *dev = PDE_DATA(file_inode(file));
 	char *buffer;
 	char *cmd;
-	int lcd_out, crt_out, tv_out;
+	int lcd_out = -1, crt_out = -1, tv_out = -1;
 	int remain = count;
 	int value;
 	int ret;
@@ -1529,7 +1529,6 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 
 	kfree(cmd);
 
-	lcd_out = crt_out = tv_out = -1;
 	ret = get_video_status(dev, &video_out);
 	if (!ret) {
 		unsigned int new_video_out = video_out;
-- 
2.27.0



