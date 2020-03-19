Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657D718B65C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgCSN0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgCSN0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A4C20CC7;
        Thu, 19 Mar 2020 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624365;
        bh=pedXLTfJpQVGrJP7cjM0hvFmyCL6sf5H6VR6PRA7Ru4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFXmW0vrkNQknJrum9j/+ZG88wQ8RErHW6y9V1Y8ddJzyj4eJIIr+aW53/r/xNapU
         lqxH7EcNvOlI8hG/LiGXZWL54xsPN423WmjZ2gPFcPq3Swoq84Vhf4J6iRM1z0eQRL
         83RMssfWjosq/BormVF3LhEwJWTTvkDQZxuM3+Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 08/65] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
Date:   Thu, 19 Mar 2020 14:03:50 +0100
Message-Id: <20200319123928.860588815@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 43cc64e5221cc6741252b64bc4531dd1eefb733d ]

The busy timeout that is computed for each erase/trim/discard operation,
can become quite long and may thus exceed the host->max_busy_timeout. If
that becomes the case, mmc_do_erase() converts from using an R1B response
to an R1 response, as to prevent the host from doing HW busy detection.

However, it has turned out that some hosts requires an R1B response no
matter what, so let's respect that via checking MMC_CAP_NEED_RSP_BUSY. Note
that, if the R1B gets enforced, the host becomes fully responsible of
managing the needed busy timeout, in one way or the other.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index abf8f5eb0a1c8..26644b7ec13e3 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1732,8 +1732,11 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	 * the erase operation does not exceed the max_busy_timeout, we should
 	 * use R1B response. Or we need to prevent the host from doing hw busy
 	 * detection, which is done by converting to a R1 response instead.
+	 * Note, some hosts requires R1B, which also means they are on their own
+	 * when it comes to deal with the busy timeout.
 	 */
-	if (card->host->max_busy_timeout &&
+	if (!(card->host->caps & MMC_CAP_NEED_RSP_BUSY) &&
+	    card->host->max_busy_timeout &&
 	    busy_timeout > card->host->max_busy_timeout) {
 		cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
 	} else {
-- 
2.20.1



