Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D50A3C4FD8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343591AbhGLH2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245452AbhGLH1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C04611BF;
        Mon, 12 Jul 2021 07:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074591;
        bh=iJzKwjzh9rWYDoYu5t7VonAlp1L7w4O+asusWmMiZ5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRfuoqVjJDjgPCOk6ErAAYVEF6K5vrhL+je9DS1WJ2HNWuwhE0HVH11Fcja03fxGd
         stOcyxqhBKkOJfl6tgaOZkJxI+Q0D3ank4kElufm4RfRVxsh5DcPHGlE8vvFYEgXzf
         AxIta/6rgvpog/3aeqHlvAK4OmgXS+27RZRUaFhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junhao He <hejunhao2@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 624/700] coresight: core: Fix use of uninitialized pointer
Date:   Mon, 12 Jul 2021 08:11:47 +0200
Message-Id: <20210712061042.206636676@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 0062c8935653..237a8c0d6c24 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -595,7 +595,7 @@ static struct coresight_device *
 coresight_find_enabled_sink(struct coresight_device *csdev)
 {
 	int i;
-	struct coresight_device *sink;
+	struct coresight_device *sink = NULL;
 
 	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-- 
2.30.2



