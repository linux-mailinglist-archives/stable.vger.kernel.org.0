Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19A137882D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhEJLUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233738AbhEJLJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73FBC6162A;
        Mon, 10 May 2021 11:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644688;
        bh=x6jVmx/J4JbZxJEqdMS3ZvsZJnhcow14iSOsNtD298I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp9EVh6snPBzF4umBaPPbLbaWb/36tF3VWTkcw4C7VgfdOIVdgnJ04Zbm7uvqhmxo
         tBl9au7ik837t1ch6/TKWd6+B2JPFNWIaDT28odDOvK5aSYrErGkyKJqnw1+FgoA+N
         Alvn3dBnXjSzTp2MhlTywRFPxFGSiqnehHLmnP88=
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
Subject: [PATCH 5.12 182/384] backlight: qcom-wled: Use sink_addr for sync toggle
Date:   Mon, 10 May 2021 12:19:31 +0200
Message-Id: <20210510102020.891787445@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 091f07e7c145..fc8b443d10fd 100644
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



