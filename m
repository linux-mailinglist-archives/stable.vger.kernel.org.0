Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C357110188E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfKSFZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfKSFZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:25:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1426421783;
        Tue, 19 Nov 2019 05:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141118;
        bh=RKL08migMu51xsRs1iJEu3044H5qvogPiaGNG3IZNGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWohNOj76Uepl8AIZRnbT9o6sH08OiiohYEWTiWP7LNpZ8ukwIpdRel5w22fXZn6k
         aY1e+ffdR8KfIDr+7UJyOAoOPuoCZyEDaUgoek8UXRk0k4qzyfl09EmdJAOhJGwSqr
         3QS1FZPdMYJZcJvHhZ7GLHEr+9fnhXqUhG32ak5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/422] rtc: sysfs: fix NULL check in rtc_add_groups()
Date:   Tue, 19 Nov 2019 06:14:06 +0100
Message-Id: <20191119051403.030227968@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



