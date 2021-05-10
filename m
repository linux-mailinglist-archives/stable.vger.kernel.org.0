Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0732D3783F4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhEJKsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhEJKp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FF4616EA;
        Mon, 10 May 2021 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643006;
        bh=+8Ak/gQ7R3xd2xD7Jm1k0nim9o8CSWY+VD9ZmUUgU00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPZsqKGrOFnLgPV79AHkZIC9VbhrYxz4xuIDFbbL3fD6GzhxMQ6nu3GH2lKDX6eBV
         SfLJGubaKYEBpDVgOreb1SvLnC3W9N556IWWgAsewcrzeEOp5D0VHCkkMesxWa52XO
         Nop5QP01rvJRFAvw/S7KrbwKVUBYPOgs5NQO7fIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Obeida Shamoun <oshmoun100@googlemail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/299] backlight: qcom-wled: Use sink_addr for sync toggle
Date:   Mon, 10 May 2021 12:18:56 +0200
Message-Id: <20210510102009.557708168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Obeida Shamoun <oshmoun100@googlemail.com>

[ Upstream commit cdfd4c689e2a52c313b35ddfc1852ff274f91acb ]

WLED3_SINK_REG_SYNC is, as the name implies, a sink register offset.
Therefore, use the sink address as base instead of the ctrl address.

This fixes the sync toggle on wled4, which can be observed by the fact
that adjusting brightness now works.

It has no effect on wled3 because sink and ctrl base addresses are the
same.  This allows adjusting the brightness without having to disable
then reenable the module.

Signed-off-by: Obeida Shamoun <oshmoun100@googlemail.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Kiran Gunda <kgunda@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 3bc7800eb0a9..83a187fdaa1d 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -336,13 +336,13 @@ static int wled3_sync_toggle(struct wled *wled)
 	unsigned int mask = GENMASK(wled->max_string_count - 1, 0);
 
 	rc = regmap_update_bits(wled->regmap,
-				wled->ctrl_addr + WLED3_SINK_REG_SYNC,
+				wled->sink_addr + WLED3_SINK_REG_SYNC,
 				mask, mask);
 	if (rc < 0)
 		return rc;
 
 	rc = regmap_update_bits(wled->regmap,
-				wled->ctrl_addr + WLED3_SINK_REG_SYNC,
+				wled->sink_addr + WLED3_SINK_REG_SYNC,
 				mask, WLED3_SINK_REG_SYNC_CLEAR);
 
 	return rc;
-- 
2.30.2



