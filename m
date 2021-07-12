Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4F63C5262
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbhGLHpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343915AbhGLHno (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17E061166;
        Mon, 12 Jul 2021 07:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075638;
        bh=K0RB13v0alRNHwX75C8a5XcddkCCjo9XD092qfbXoss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8O3yf2sqAK1pkVqatWMctjpEQ5Nhlkd0MmSBSM0pj0YdrLLiwQnTHRuFxbYc9egY
         mnmTgpJSmC9man7bFXtMKqEsFskkqsVM0GrkMGrUdZl98jZ9kHDOzte+xz4A21tykb
         R3AOlgJ4F4JHxJ5K6FB1Ay+4Hv6uQUSR/BtK2ji8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 301/800] media: tc358743: Fix error return code in tc358743_probe_of()
Date:   Mon, 12 Jul 2021 08:05:24 +0200
Message-Id: <20210712060957.301466817@linuxfoundation.org>
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
index 1b309bb743c7..f21da11caf22 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1974,6 +1974,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	bps_pr_lane = 2 * endpoint.link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		ret = -EINVAL;
 		goto disable_clk;
 	}
 
-- 
2.30.2



