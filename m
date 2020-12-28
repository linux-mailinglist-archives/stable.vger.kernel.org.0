Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44F2E4101
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403829AbgL1PBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440221AbgL1ONh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF2920791;
        Mon, 28 Dec 2020 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164777;
        bh=2j4BhcXHV6IIMii6oXSicMpmDyOckZyxCkkJqERhhq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tyvt21mgNSOdEk4AKew1REjXXjWbcfzProv8tVG7oXw177kEMhtBowglX3POuXtCt
         E3Zwpv7VIx+rwZbNYKhLWRlj6tMkX0zq6j+aQgppP/jauTn2m8D4Ne7wd+xYkyBh8r
         YLNzZEhmnS80MUWAIwgPs5viy1N4pSor4O1XjVrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/717] media: tvp5150: Fix wrong return value of tvp5150_parse_dt()
Date:   Mon, 28 Dec 2020 13:44:35 +0100
Message-Id: <20201228125034.289135128@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit eb08c48132a1f594478ab9fa2b6ee646c3513a49 ]

If of_graph_get_endpoint_by_regs() return NULL, it will return 0 rather
than an errno, because we doesn't initialize the return value.

Fixes: 0556f1d580d4 ("media: tvp5150: add input source selection of_graph support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tvp5150.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 7d9401219a3ac..3b3221fd3fe8f 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -2082,6 +2082,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 
 	ep_np = of_graph_get_endpoint_by_regs(np, TVP5150_PAD_VID_OUT, 0);
 	if (!ep_np) {
+		ret = -EINVAL;
 		dev_err(dev, "Error no output endpoint available\n");
 		goto err_free;
 	}
-- 
2.27.0



