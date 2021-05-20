Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9C38A78A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhETKjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237349AbhETKhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02EC610A1;
        Thu, 20 May 2021 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504475;
        bh=DQsBNNtWUZXsa33j4Y8bton6tyEjC6Nndz4xV3wykVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtGWojxucK/6a+1BsqP8DuqnC3mKGv02SyR3hxA+oEZamjv0hxK1BIqX+G6xc5Lqc
         AAif2MHY+A9qtY6Y/XFtsxUEtMmrFGCbqTKwXgeWBFH1SC/SLvJvMftuSb10R0OC7d
         QMRyCI81KOwnUE+Bun6R4HwL0BtFgbR6vGTGTxk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 262/323] rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()
Date:   Thu, 20 May 2021 11:22:34 +0200
Message-Id: <20210520092129.199979195@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 7802663efe33..67711537d3ff 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -856,6 +856,7 @@ static int qcom_glink_rx_data(struct qcom_glink *glink, size_t avail)
 			dev_err(glink->dev,
 				"no intent found for channel %s intent %d",
 				channel->name, liid);
+			ret = -ENOENT;
 			goto advance_rx;
 		}
 	}
-- 
2.30.2



