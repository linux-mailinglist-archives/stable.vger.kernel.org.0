Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731CE206453
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgFWVTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389874AbgFWUYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:24:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295962073E;
        Tue, 23 Jun 2020 20:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943873;
        bh=7e30EfUiSxO/sFuvj8K/fgjGMIOHz30SAJcVZVXkjhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X/cT2CLA9JWlyufgjrcU6ZK5EeTWj2Zr1tgez5B5FCSJOou00WWnCzyV6w7KQrhM
         hQR0aW+8xKbqlzTWa7hQVnNLDvbfbbHcD8rf9jeHzOXxh7Gflj11xT0MB3ArZiO49w
         IEkL42e9P8RWUsGIuFMG6f9D23xuy9zZJ/+sYm04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/314] staging: greybus: fix a missing-check bug in gb_lights_light_config()
Date:   Tue, 23 Jun 2020 21:54:39 +0200
Message-Id: <20200623195342.876247014@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index d6ba25f21d807..d2672b65c3f49 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1026,7 +1026,8 @@ static int gb_lights_light_config(struct gb_lights *glights, u8 id)
 
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



