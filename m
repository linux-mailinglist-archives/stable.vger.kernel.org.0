Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6263A6478
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhFNLZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235667AbhFNLWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE3B613DE;
        Mon, 14 Jun 2021 10:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667971;
        bh=My65Kwd5cXlKH8qkBXnqvUC7VxLOqkOtHvLz0idZcEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yj1+Y8IK8BnY9DUFIk5bIl7ECD+08Dg5NvGGFxw9mc/ijXkA7UA0FaWdRuR9e1mPu
         OslpgmWSZumsgq3N5QCraNgzQ04nhN8kAMF6IhfONRxPsMJpFEV3VZAxw1wGqG32N8
         r2UchZLB3HeL6jMW7Bd++/iAJ9A2o1WCauldqxz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 146/173] ASoC: core: Fix Null-point-dereference in fmt_single_name()
Date:   Mon, 14 Jun 2021 12:27:58 +0200
Message-Id: <20210614102703.027551716@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 41daf6ba594d55f201c50280ebcd430590441da1 upstream.

Check the return value of devm_kstrdup() in case of
Null-point-dereference.

Fixes: 45dd9943fce0 ("ASoC: core: remove artificial component and DAI name constraint")
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Link: https://lore.kernel.org/r/20210524024941.159952-1-wangkefeng.wang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2223,6 +2223,8 @@ static char *fmt_single_name(struct devi
 		return NULL;
 
 	name = devm_kstrdup(dev, devname, GFP_KERNEL);
+	if (!name)
+		return NULL;
 
 	/* are we a "%s.%d" name (platform and SPI components) */
 	found = strstr(name, dev->driver->name);


