Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5EB24AAE7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgHTAGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgHTADz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:03:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDEF21775;
        Thu, 20 Aug 2020 00:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881835;
        bh=lw1yL5+D0GFS7k/22hM9f0lnHRnDEgM0C2akrp065PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYZJtHWHi3a3qGb8bI0ETDleH/SxRcQOjc8EMfVx+2hCp8QeL6Xmhxc317FTriLms
         wZCvtluoCMZhSxnmeo0XbdFkOgpkI9/T8vOFkn0ot//GspC72eWR146lXSnaNMFLpt
         GijgnQINZGPN+eYtvyQiEQ5aoDqD6YwkK3h+NfTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/11] Input: psmouse - add a newline when printing 'proto' by sysfs
Date:   Wed, 19 Aug 2020 20:03:41 -0400
Message-Id: <20200820000348.215911-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000348.215911-1-sashal@kernel.org>
References: <20200820000348.215911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 4aec14de3a15cf9789a0e19c847f164776f49473 ]

When I cat parameter 'proto' by sysfs, it displays as follows. It's
better to add a newline for easy reading.

root@syzkaller:~# cat /sys/module/psmouse/parameters/proto
autoroot@syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20200720073846.120724-1-wangxiongfeng2@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/psmouse-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 5cbf17aa84439..597ecae02c405 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1909,7 +1909,7 @@ static int psmouse_get_maxproto(char *buffer, const struct kernel_param *kp)
 {
 	int type = *((unsigned int *)kp->arg);
 
-	return sprintf(buffer, "%s", psmouse_protocol_by_type(type)->name);
+	return sprintf(buffer, "%s\n", psmouse_protocol_by_type(type)->name);
 }
 
 static int __init psmouse_init(void)
-- 
2.25.1

