Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFE205FD1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391784AbgFWUgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391778AbgFWUga (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:36:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B87B20781;
        Tue, 23 Jun 2020 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944590;
        bh=GQpq5PSM1CJd3KQdWyoslefYy7Sg5Ub3MKIpGf6V8mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uyq+NwgqAqSfVukNh+NSuH78Pbfs47wJkpHyhCULwkEsk5InxnYg9sBKDVFbOtYVf
         18n8M1Mautg+sIUR0CJ+/Jl5N6KH/ErZr+0q1jezIcph1V102DducrPO7a0dc8OZTD
         ltzufu2r5IF7phfL4+J/+SL3iZKIYCO5guJCzGMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/206] staging: greybus: fix a missing-check bug in gb_lights_light_config()
Date:   Tue, 23 Jun 2020 21:56:16 +0200
Message-Id: <20200623195319.346074031@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 9bb086e5ba9495ac150fbbcc5c8c2bccc06261dd ]

In gb_lights_light_config(), 'light->name' is allocated by kstrndup().
It returns NULL when fails, add check for it.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Link: https://lore.kernel.org/r/20200401030017.100274-1-chenzhou10@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/light.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index 40680eaf3974f..db06cd544af58 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1028,7 +1028,8 @@ static int gb_lights_light_config(struct gb_lights *glights, u8 id)
 
 	light->channels_count = conf.channel_count;
 	light->name = kstrndup(conf.name, NAMES_MAX, GFP_KERNEL);
-
+	if (!light->name)
+		return -ENOMEM;
 	light->channels = kcalloc(light->channels_count,
 				  sizeof(struct gb_channel), GFP_KERNEL);
 	if (!light->channels)
-- 
2.25.1



