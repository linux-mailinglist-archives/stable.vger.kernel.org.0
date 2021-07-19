Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D813CDAEE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243730AbhGSOkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244661AbhGSOhv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 412A2610D2;
        Mon, 19 Jul 2021 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707856;
        bh=iT+OCu+mLudaldS5mJURFj9y6qPcvVsGNcC2Qd4aLZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaYd6RBnw3+YSwHghXxdvyRuKIlVEbzPJCcg5MajRE3kWCXKpkCScj8k9PovuV9V3
         WpEjB20/n1uWZADNrTTPd+egkktgprlWDIqu/wlfsrVFLA+kjJuMkNsr7eU0l3Rnsj
         xuHrH8K5d94kWb3OM0trzeJgvdZsDb6GlDoVHA1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 085/315] media: tc358743: Fix error return code in tc358743_probe_of()
Date:   Mon, 19 Jul 2021 16:49:34 +0200
Message-Id: <20210719144945.672421354@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit a6b1e7093f0a099571fc8836ab4a589633f956a8 ]

When the CSI bps per lane is not in the valid range, an appropriate error
code -EINVAL should be returned. However, we currently do not explicitly
assign this error code to 'ret'. As a result, 0 was incorrectly returned.

Fixes: 256148246852 ("[media] tc358743: support probe from device tree")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index f74c4f6814eb..b294433c8345 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1806,6 +1806,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	bps_pr_lane = 2 * endpoint->link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		ret = -EINVAL;
 		goto disable_clk;
 	}
 
-- 
2.30.2



