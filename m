Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6690D1332E6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgAGVOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729623AbgAGVJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A89C20678;
        Tue,  7 Jan 2020 21:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431359;
        bh=T4grm+Gyf6a3qOJuSCD/teJxU1kaNU2T/rbqhPvUWUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKpIUxy5sntGWWEnFKIgYy+OY7k9t3fo1D2lP6/9RHXsLAe2KKFFVPP3SHOGVIPqm
         VkO8wkoHSa8H4hq4AyxMGsiLUbPMCrW/1Xo1DAw25osiNYcAOj2SuEG5arucE8L4gJ
         +edMAXJKyxwC9pOjFWdERUnkMaPjNSsifhjYk358=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/74] PM / devfreq: Dont fail devfreq_dev_release if not in list
Date:   Tue,  7 Jan 2020 21:54:28 +0100
Message-Id: <20200107205137.793147905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
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
index dc9c0032c97b..7b510ef1d0dd 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -484,11 +484,6 @@ static void devfreq_dev_release(struct device *dev)
 	struct devfreq *devfreq = to_devfreq(dev);
 
 	mutex_lock(&devfreq_list_lock);
-	if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
-		mutex_unlock(&devfreq_list_lock);
-		dev_warn(&devfreq->dev, "releasing devfreq which doesn't exist\n");
-		return;
-	}
 	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
@@ -547,6 +542,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->dev.parent = dev;
 	devfreq->dev.class = devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
+	INIT_LIST_HEAD(&devfreq->node);
 	devfreq->profile = profile;
 	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
 	devfreq->previous_freq = profile->initial_freq;
-- 
2.20.1



