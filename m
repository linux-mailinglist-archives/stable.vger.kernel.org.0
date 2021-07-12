Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEE43C454C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhGLGZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234439AbhGLGYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FE261158;
        Mon, 12 Jul 2021 06:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070827;
        bh=zLF8kdhC88xF/0xeiYo4eqhyTH8GkUmWJAYOwLEiL8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJatkjuoIQNEJliP5RCHT3nV5TtIqWpKqdaSC7i7Taedw28hEfZjbzP8PMXtb+u2T
         6itvOuJQaem12sBYLJIeyv/Yg2Kn625vNaUzqrR38rr7/P5FIJ35uywUIsCGTb323G
         cUjafAuP95B1wo8svzVXCrzfyIScdcnKSXu8hNtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/348] media: tc358743: Fix error return code in tc358743_probe_of()
Date:   Mon, 12 Jul 2021 08:08:59 +0200
Message-Id: <20210712060721.624829705@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 114c084c4aec..76c443067ec2 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1973,6 +1973,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	bps_pr_lane = 2 * endpoint.link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		ret = -EINVAL;
 		goto disable_clk;
 	}
 
-- 
2.30.2



