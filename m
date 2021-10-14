Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11CA42DD14
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhJNPEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhJNPCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C514611AE;
        Thu, 14 Oct 2021 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223581;
        bh=gfSSvYoKamvAQoaTJ4v7jnSD7dGLcrlIf0jNkDZz3qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtswgutCUHqFFphV+2JFMzRWRHGUdrKRIMpHfv4mvveIzBsiDa5MGZIDkMMce/Dgy
         00aEc8SyOKIdw+iEcdiFyQBoEeUpgytNcsVlrz5os89Z/KBFQP1d6wNxvl917/6ebQ
         yHXJAHbtUU7tFon62bnQyuM/R85Me7Rb0+cbrVpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/22] hwmon: (ltc2947) Properly handle errors when looking for the external clock
Date:   Thu, 14 Oct 2021 16:54:18 +0200
Message-Id: <20211014145208.379721338@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 6f7d70467121f790b36af2d84bc02b5c236bf5e6 ]

The return value of devm_clk_get should in general be propagated to
upper layer. In this case the clk is optional, use the appropriate
wrapper instead of interpreting all errors as "The optional clk is not
available".

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210923201113.398932-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2947-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index bb3f7749a0b0..5423466de697 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -989,8 +989,12 @@ static int ltc2947_setup(struct ltc2947_data *st)
 		return ret;
 
 	/* check external clock presence */
-	extclk = devm_clk_get(st->dev, NULL);
-	if (!IS_ERR(extclk)) {
+	extclk = devm_clk_get_optional(st->dev, NULL);
+	if (IS_ERR(extclk))
+		return dev_err_probe(st->dev, PTR_ERR(extclk),
+				     "Failed to get external clock\n");
+
+	if (extclk) {
 		unsigned long rate_hz;
 		u8 pre = 0, div, tbctl;
 		u64 aux;
-- 
2.33.0



