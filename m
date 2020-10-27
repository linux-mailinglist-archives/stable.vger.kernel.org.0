Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C719029C0FC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818006AbgJ0RQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781667AbgJ0O4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF87722202;
        Tue, 27 Oct 2020 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810561;
        bh=8dWP46Q/wDUBmxbTdzmA+KEgGq9L6z/3idnfwPc+sEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIXCDEBdIX9WdaJGysGm9aH9lxNrz7OReqY8nbIw0Cyog0kuIvdfPVGCls7me008S
         zUItHnkuRCUd2yHglaP39MZg7/Z2LYyUEGt24Ni87oZi7v7gragpS559puMDUBKXU/
         I6l/8UtlfqWDQQJQTCIDLPzgVDMpWCSXq/2X53EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 141/633] media: camss: Fix a reference count leak.
Date:   Tue, 27 Oct 2020 14:48:04 +0100
Message-Id: <20201027135529.301708465@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit d0675b67b42eb4f1a840d1513b5b00f78312f833 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
PM runtime put is not called in error handling paths.
Thus call pm_runtime_put_sync() if pm_runtime_get_sync() fails.

Fixes: 02afa816dbbf ("media: camss: Add basic runtime PM support")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 008afb85023be..3c5b9082ad723 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -176,8 +176,10 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 		int ret;
 
 		ret = pm_runtime_get_sync(dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
 			return ret;
+		}
 
 		ret = csiphy_set_clock_rates(csiphy);
 		if (ret < 0) {
-- 
2.25.1



