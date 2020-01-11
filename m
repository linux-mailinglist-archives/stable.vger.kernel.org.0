Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C24137D83
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgAKJ6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:58:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgAKJ6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:58:36 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC7320848;
        Sat, 11 Jan 2020 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736715;
        bh=/2gfM4wNvqp7PBRIwfz3c8HJet+zs0Kt0tSU9okw12E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly1mGannJrqcjDPCB7bwQIvQOvhKy11brwVYtXLQTPLuJj+JbLvmYVu9Vztfvsu2W
         ycs0+tXOlNxE5Hsa/Qs+zRzIgPdJ5S3rduNpqil/EojsAosCp6Z1jqawWyS8v8TMwr
         0X8CyAe+d+IX64fPRMs5J5uxLt2aiNG0Yz/Ml040=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/91] PM / devfreq: Dont fail devfreq_dev_release if not in list
Date:   Sat, 11 Jan 2020 10:48:54 +0100
Message-Id: <20200111094844.984016422@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 42a6b25e67df6ee6675e8d1eaf18065bd73328ba ]

Right now devfreq_dev_release will print a warning and abort the rest of
the cleanup if the devfreq instance is not part of the global
devfreq_list. But this is a valid scenario, for example it can happen if
the governor can't be found or on any other init error that happens
after device_register.

Initialize devfreq->node to an empty list head in devfreq_add_device so
that list_del becomes a safe noop inside devfreq_dev_release and we can
continue the rest of the cleanup.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index df62e38de5f5..fb696957eb21 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -482,11 +482,6 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
 static void _remove_devfreq(struct devfreq *devfreq)
 {
 	mutex_lock(&devfreq_list_lock);
-	if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
-		mutex_unlock(&devfreq_list_lock);
-		dev_warn(&devfreq->dev, "releasing devfreq which doesn't exist\n");
-		return;
-	}
 	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
@@ -558,6 +553,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->dev.parent = dev;
 	devfreq->dev.class = devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
+	INIT_LIST_HEAD(&devfreq->node);
 	devfreq->profile = profile;
 	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
 	devfreq->previous_freq = profile->initial_freq;
-- 
2.20.1



