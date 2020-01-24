Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65660147B0C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgAXJk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgAXJkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:24 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CCF208C4;
        Fri, 24 Jan 2020 09:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858824;
        bh=BIPbnlO9fACMo7/V30+Oas84K0C6QSVwu8VSeWhTK3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ca1pr1bUbRmQs+5rBlGVlBDYhKPGcNCGAigR6DebDpxFZfrG47gBPZT29IxVQW2bt
         FS3GuMPr7M2zFjPqaPMasfG1yByavyT4VVJrrwBBYAAyLfhgFlKAjSSj1u00dEALod
         /SZk070UzLF6EkYiCgrtfNO0GqrOKQTe/I+XjPFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/102] drm/panfrost: Add missing check for pfdev->regulator
Date:   Fri, 24 Jan 2020 10:30:52 +0100
Message-Id: <20200124092814.017324612@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 52282163dfa651849e905886845bcf6850dd83c2 ]

When modifying panfrost_devfreq_target() to support a device without a
regulator defined I missed the check on the error path. Let's add it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: e21dd290881b ("drm/panfrost: Enable devfreq to work without regulator")
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190822093218.26014-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 12ff77dacc954..c1eb8cfe6aeb3 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -53,8 +53,10 @@ static int panfrost_devfreq_target(struct device *dev, unsigned long *freq,
 	if (err) {
 		dev_err(dev, "Cannot set frequency %lu (%d)\n", target_rate,
 			err);
-		regulator_set_voltage(pfdev->regulator, pfdev->devfreq.cur_volt,
-				      pfdev->devfreq.cur_volt);
+		if (pfdev->regulator)
+			regulator_set_voltage(pfdev->regulator,
+					      pfdev->devfreq.cur_volt,
+					      pfdev->devfreq.cur_volt);
 		return err;
 	}
 
-- 
2.20.1



