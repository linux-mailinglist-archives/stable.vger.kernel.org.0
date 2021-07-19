Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7283CD959
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhGSO2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243567AbhGSO1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D7E6113E;
        Mon, 19 Jul 2021 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707241;
        bh=/+zANuZD7GSycPJuIsy/hZVkRkb/BLayizqF8RYNenQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEgkJ6FVi0BFv2G/clAMyTvXgHPVnsIZ/7MmC+FJvmGlCS6yLuIclWXAQURMjSKC9
         o74gREt57ypCLR3Nt7+u9K+okZZtdGoQoBE0lk0zJQ8y1Eq52r+Bb4nA9jAL1lzgn0
         JKl4S1RCwOoDHcWDCA2KG3DIhbL8/xnohbVkJ9KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/245] media: tc358743: Fix error return code in tc358743_probe_of()
Date:   Mon, 19 Jul 2021 16:50:07 +0200
Message-Id: <20210719144942.507369080@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 3e47b432d0f4..c799071be66f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1763,6 +1763,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	bps_pr_lane = 2 * endpoint->link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		ret = -EINVAL;
 		goto disable_clk;
 	}
 
-- 
2.30.2



