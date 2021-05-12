Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8789A37CC3D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhELQng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243018AbhELQg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B761A61979;
        Wed, 12 May 2021 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835223;
        bh=n1ZiqqtT1iykW2ruKwqfJSGv+fpU1zzut2Bj0uNJCTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIKR9iMPJSIGPm7SH2OLL6VpjDiNl8rnQa7GJMQeqr6ddNKQFnCRP11T5xLGtfAgk
         TKBYJ3cVrzaV666OBXfxGr5coAXv7oN6bUNHW/nB3ro+DnwViGj2FMDwSHulB51kP9
         4sIc1b9BmYiq0b9zIC3lx6iRKS2S11Ag84sa7arA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Keyon Jie <yang.jie@intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 256/677] soundwire: stream: fix memory leak in stream config error path
Date:   Wed, 12 May 2021 16:45:02 +0200
Message-Id: <20210512144845.742381160@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit 48f17f96a81763c7c8bf5500460a359b9939359f ]

When stream config is failed, master runtime will release all
slave runtime in the slave_rt_list, but slave runtime is not
added to the list at this time. This patch frees slave runtime
in the config error path to fix the memory leak.

Fixes: 89e590535f32 ("soundwire: Add support for SoundWire stream management")
Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Keyon Jie <yang.jie@intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210331004610.12242-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index 1099b5d1262b..a418c3c7001c 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1375,8 +1375,16 @@ int sdw_stream_add_slave(struct sdw_slave *slave,
 	}
 
 	ret = sdw_config_stream(&slave->dev, stream, stream_config, true);
-	if (ret)
+	if (ret) {
+		/*
+		 * sdw_release_master_stream will release s_rt in slave_rt_list in
+		 * stream_error case, but s_rt is only added to slave_rt_list
+		 * when sdw_config_stream is successful, so free s_rt explicitly
+		 * when sdw_config_stream is failed.
+		 */
+		kfree(s_rt);
 		goto stream_error;
+	}
 
 	list_add_tail(&s_rt->m_rt_node, &m_rt->slave_rt_list);
 
-- 
2.30.2



