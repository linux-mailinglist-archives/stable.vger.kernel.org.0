Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EF838A3A7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhETJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhETJwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6101461582;
        Thu, 20 May 2021 09:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503380;
        bh=4ePEs0WA8a5cVcLLL7zTb9hlbn2sOvi0LDvS2EKiG/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtmiEsw44j0C96wx7sGssmtlPcW/AFLBNv5USwXEtHUkLHzH1eITvnfvg7FzybGwr
         miZFLawczhX8foUGnh6Fso9HxacGzeooiX0ZeR7bW5Xc5/QoX3RvTUeG2Gxwb/lwWY
         O5BaCTB/8yiJ1LrhTf7O0jxhjd/vGEwpTHDkBxzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Keyon Jie <yang.jie@intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 196/425] soundwire: stream: fix memory leak in stream config error path
Date:   Thu, 20 May 2021 11:19:25 +0200
Message-Id: <20210520092137.861833156@linuxfoundation.org>
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
index 907a548645b7..42bc701e2304 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1182,8 +1182,16 @@ int sdw_stream_add_slave(struct sdw_slave *slave,
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



