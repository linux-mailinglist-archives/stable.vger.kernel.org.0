Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90E15078F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfFXKIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbfFXKH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:59 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41AF1205C9;
        Mon, 24 Jun 2019 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370878;
        bh=L1T2MkkeIFA8NIvLd4nNQys+neonGjNiK4USvJQoEm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3rmhKCASJXh04LOCVDuq3h4dqXH+Jc1EbimKY4eSt56XXe8Sv/fCsRCrqI0zalCE
         lNBRNy70EFn+GLppfxtZGByDdsMu37cKXWgn0VQiYxPTqBwzTVtn+3RLlBfmKL7dk7
         tpBnFESaqrJ80uy+6zqFfgKpY+OZlSuZf34X2LfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jjian zhou <jjian.zhou@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Yong Mao <yong.mao@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 005/121] mmc: mediatek: fix SDIO IRQ detection issue
Date:   Mon, 24 Jun 2019 17:55:37 +0800
Message-Id: <20190624092320.925025681@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jjian zhou <jjian.zhou@mediatek.com>

commit 20314ce30af197963b0c239f0952db6aaef73f99 upstream.

If cmd19 timeout or response crcerr occurs during execute_tuning(),
it need invoke msdc_reset_hw(). Otherwise SDIO IRQ can't be detected.

Signed-off-by: jjian zhou <jjian.zhou@mediatek.com>
Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Yong Mao <yong.mao@mediatek.com>
Fixes: 5215b2e952f3 ("mmc: mediatek: Add MMC_CAP_SDIO_IRQ support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1003,6 +1003,8 @@ static void msdc_request_done(struct msd
 	msdc_track_cmd_data(host, mrq->cmd, mrq->data);
 	if (mrq->data)
 		msdc_unprepare_data(host, mrq);
+	if (host->error)
+		msdc_reset_hw(host);
 	mmc_request_done(host->mmc, mrq);
 }
 


