Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390BD38A4C2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhETKJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234962AbhETKHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01BD860240;
        Thu, 20 May 2021 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503694;
        bh=XEPPqUppLSubaFZoMudnOxtDnTqzOGcyIWwgCIS6aKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9bTcSJiTt/OjmBUMaDZqUYNny5dbzS8/bvvrzOHcB1uTROtx/4r+dRci1zRqm/qA
         pzI5D7l0K7XBF57JwU72Sw6P3KM9UKAVSYWWkd6EsSr48U+sdY3RHM3uPbzYhV4i+4
         XP0KUBOhBR5Lm98V/PN6ERKikW54xdvm96Et8a5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 338/425] rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()
Date:   Thu, 20 May 2021 11:21:47 +0200
Message-Id: <20210520092142.527353817@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 26594c6bbb60c6bc87e3762a86ceece57d164c66 ]

When idr_find() returns NULL to intent, no error return code of
qcom_glink_rx_data() is assigned.
To fix this bug, ret is assigned with -ENOENT in this case.

Fixes: 64f95f87920d ("rpmsg: glink: Use the local intents when receiving data")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20210306133624.17237-1-baijiaju1990@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index a755f85686e5..8fa0f0eaaf43 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -857,6 +857,7 @@ static int qcom_glink_rx_data(struct qcom_glink *glink, size_t avail)
 			dev_err(glink->dev,
 				"no intent found for channel %s intent %d",
 				channel->name, liid);
+			ret = -ENOENT;
 			goto advance_rx;
 		}
 	}
-- 
2.30.2



