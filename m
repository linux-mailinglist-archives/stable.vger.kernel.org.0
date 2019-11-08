Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3DEF4B37
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390114AbfKHMOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732277AbfKHLiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D42222C2;
        Fri,  8 Nov 2019 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213092;
        bh=RKL08migMu51xsRs1iJEu3044H5qvogPiaGNG3IZNGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bVa1edDji24gINGA1b1QJ2rlO4ChXRTIn6JRpLSJT7ACjjaJ9bPunX9xAAcZmHGE
         fpq6P8otlE9KwOMPTezZjuZIZh1NCpDL8cdJ9iHR7/5g7H6oIh6aBGcylEj/C8iKiy
         DaAlqb++YkLjS2NkWY2dQQZGzUAUpK1KafMxfLqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, rtc-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 017/205] rtc: sysfs: fix NULL check in rtc_add_groups()
Date:   Fri,  8 Nov 2019 06:34:44 -0500
Message-Id: <20191108113752.12502-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 777d8ae56da18fb6440acd941edb3597c1b02bf0 ]

devm_kcalloc() returns NULL, it never returns error pointers.  In the
current code we would return PTR_ERR(NULL) which is success, instead of
returning the -ENOMEM error code.

Fixes: a0a1a1ba3032 ("rtc: sysfs: facilitate attribute add to rtc device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index f1ff30ade5343..9746c32eee2eb 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -338,8 +338,8 @@ int rtc_add_groups(struct rtc_device *rtc, const struct attribute_group **grps)
 
 	new_cnt = old_cnt + add_cnt + 1;
 	groups = devm_kcalloc(&rtc->dev, new_cnt, sizeof(*groups), GFP_KERNEL);
-	if (IS_ERR_OR_NULL(groups))
-		return PTR_ERR(groups);
+	if (!groups)
+		return -ENOMEM;
 	memcpy(groups, rtc->dev.groups, old_cnt * sizeof(*groups));
 	memcpy(groups + old_cnt, grps, add_cnt * sizeof(*groups));
 	groups[old_cnt + add_cnt] = NULL;
-- 
2.20.1

