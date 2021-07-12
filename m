Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714703C5585
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhGLIKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353730AbhGLICs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B8461CFE;
        Mon, 12 Jul 2021 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076617;
        bh=x3X8Qd2GQ7oKmQkuJSd/9owtp2AJ54zXV29Fyj9r1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghl0bGX3fbKch/+Jf1ykta82y2XLRQ5mea+j6eLJExTpwNjnZrYqUCAo8JMJJEh40
         3exPlGaQPOKpxFWIJvVXAnSipZoIfWos+EXe0sTPup+7p82uDaH/Sn+ltv7nTE0eEB
         DwKkg0597Ddrno3D5Adgkd9pZQFCUXifqSEdGJRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junhao He <hejunhao2@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 720/800] coresight: core: Fix use of uninitialized pointer
Date:   Mon, 12 Jul 2021 08:12:23 +0200
Message-Id: <20210712061043.337746564@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junhao He <hejunhao2@hisilicon.com>

[ Upstream commit d777a8991847729ec4e2a13fcad58c2b00bb19dc ]

Currently the pointer "sink" might be checked before initialized. Fix
this by initializing this pointer.

Link: https://lore.kernel.org/r/1620912469-52222-2-git-send-email-liuqi115@huawei.com
Fixes: 6d578258b955 ("coresight: Make sysfs functional on topologies with per core sink")
Signed-off-by: Junhao He <hejunhao2@hisilicon.com>
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210614175901.532683-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 6c68d34d956e..4ddf3d233844 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -608,7 +608,7 @@ static struct coresight_device *
 coresight_find_enabled_sink(struct coresight_device *csdev)
 {
 	int i;
-	struct coresight_device *sink;
+	struct coresight_device *sink = NULL;
 
 	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-- 
2.30.2



