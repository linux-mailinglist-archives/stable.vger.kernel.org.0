Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403C02E3C8E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437292AbgL1OEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437290AbgL1OEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C532063A;
        Mon, 28 Dec 2020 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164211;
        bh=oF4XxR/L5dzqgVJ61UhkynEJ9IH3369GEhn3/lLo8vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsUuPljk2ky66+6eymTDQ5ySQCu3YDgWd4IwY2WGEar8gsjW9zrwUMYi73AAkkAsT
         jqYXOYzDuM4gPlck0QA0x6TTisG3b+kUmfX7/qyakIdjWAEj/QX3xGS3MJ9+Q4oeHK
         +4vzbnTBdbvOzzZy2HgB+pHrk7feaBQGl7IPwo8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/717] ASoC: arizona: Fix a wrong free in wm8997_probe
Date:   Mon, 28 Dec 2020 13:41:38 +0100
Message-Id: <20201228125025.765928127@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 5e7aace13df24ff72511f29c14ebbfe638ef733c ]

In the normal path, we should not free the arizona,
we should return immediately. It will be free when
call remove operation.

Fixes: 31833ead95c2c ("ASoC: arizona: Move request of speaker IRQs into bus probe")
Reported-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20201111130923.220186-2-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8997.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 37e4bb3dbd8a9..229f2986cd96b 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1177,6 +1177,8 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	return ret;
+
 err_spk_irqs:
 	arizona_free_spk_irqs(arizona);
 
-- 
2.27.0



