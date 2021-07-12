Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589C33C4B37
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240719AbhGLG4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240268AbhGLGxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F3C610FA;
        Mon, 12 Jul 2021 06:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072652;
        bh=loDQPu41upbNyd/M1wRxS7wDQIvxt3E2AB3KhwPdteY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvpOQg8OuGLLIsK/E5ABmlSsWZfmq5p9Dz1r3L4+VIRqVpV5dnXZqxBVK1Tr7wk8r
         ggQPylIi5pHMKUaXJR3eqw4YXaVfNxfqgLlG3DKrm1tfbP3zbvO09JCMETv4E1uwj6
         s3ll87xqDglN7IY1uNql80jSzQGvBJ3fTvT9NOSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junhao He <hejunhao2@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 526/593] coresight: core: Fix use of uninitialized pointer
Date:   Mon, 12 Jul 2021 08:11:26 +0200
Message-Id: <20210712060950.999434227@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index cc9e8025c533..b2088d2d386a 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -581,7 +581,7 @@ static struct coresight_device *
 coresight_find_enabled_sink(struct coresight_device *csdev)
 {
 	int i;
-	struct coresight_device *sink;
+	struct coresight_device *sink = NULL;
 
 	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-- 
2.30.2



