Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3211FE4F2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgFRCWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbgFRBS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC2E8221F1;
        Thu, 18 Jun 2020 01:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443107;
        bh=uPBiJ4AumncjvZcxAi3pEEIlqWJqyQ0HKHJnDQw2Iqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3MglZ/Cef6ZIo4L0GAGKWafbNHgYQ8rFbqw3iRbNvARdGIdFAY1xNGbXoRcG/fby
         UY+5v6lR2DP2Q1CIK8IdJ39HyTqQPuL9g20mjEGLwd2n+bOVvaGvf9M84XdXwq3Wa2
         QpLpbcCp00Es4B7rAfGww/5086BtXZtPTItQT7zo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 085/266] staging: greybus: fix a missing-check bug in gb_lights_light_config()
Date:   Wed, 17 Jun 2020 21:13:30 -0400
Message-Id: <20200618011631.604574-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d6ba25f21d80..d2672b65c3f4 100644
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

