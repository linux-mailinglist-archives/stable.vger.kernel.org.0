Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCCE19189A
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgCXSIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:08:10 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35967 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgCXSIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:08:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id s1so14033836lfd.3
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vy0uyy35QNpejtYD8qe9CDDYciuKj7VGVF2mU0OiMZs=;
        b=glVXZKRQdT0CXTjE2q/fj8TR19MdtGbZbi5RntaucgoFDQPU9Nzez6Z7Eqi9XxbpnT
         v1w9zxF/BdGLA8zwpsJD+vqaahkmcR9rIe7CMV3WjKn0hPBrug6x8jnoCJENcsvrJHuq
         PB3qx9ikGrgbsGlUfTWYzXvEFJOzTvhM/uDztt4zPISUQ5FQ08188T63ppuaJUv6hsf/
         IwIyjQfrtScTCktOdHkC4h5ijZjB6yPBuIJu+X9RwOp2zaBBnSJ+NG7U2w/Ly9t5bJzY
         urhgRaq5T4FnEPdvfzeSxvnStuBMmJOfkK29yUIm6hKhbpIgbj0P+774g2Bf/wufs19p
         LjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vy0uyy35QNpejtYD8qe9CDDYciuKj7VGVF2mU0OiMZs=;
        b=ZEBi5nbinTdQbHsOZZmZ0quGuxBas2JW7tdm9DNK8bKBRm4dPnzw7c4fv+T0oZg0WG
         tWk9j3xftojqJz+sTi4ozNoRffaEwZZrYC1J0W8zwKvZ9nfKrpQY2fSi2MdVVQmszrPY
         e6z8QjkJnsRVAtEdgHl+8McNCQOZlNekV76nCsIzEdy6MT7nHk9Uh7F/symYuiNAyVnQ
         QZBRuJ59Lv1Gz+ziAC1II+GnobnUFxV5Z7bfIGVTQBIQAWxr9zh7ykzSKXlu/eQyUDu/
         vmvjqgdTNA1Pb7Pr4mBB+rl9S/FmH8f2ehFDzvJSEuI2MWYEpY2dlwWprJePl3Yexfon
         chJw==
X-Gm-Message-State: ANhLgQ0/P9I6NeUOs9Gw71raLQQm02oETRmqxvWBNq+hNO2DjshPZ1uv
        L1sIKlKB0OCiRaaPagohPxZTNA==
X-Google-Smtp-Source: ADFU+vv5Vne+R/AEBwzTXBWCEPinvro0MlDIH4orKlxDvpFc2ATn+mnt2jhgUKdZCOPE5HWcx+n0zw==
X-Received: by 2002:ac2:4a88:: with SMTP id l8mr7201139lfp.138.1585073287419;
        Tue, 24 Mar 2020 11:08:07 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id s10sm11029858ljp.87.2020.03.24.11.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:08:06 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 4.19.113 2/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
Date:   Tue, 24 Mar 2020 19:07:57 +0100
Message-Id: <20200324180800.28953-3-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180800.28953-1-ulf.hansson@linaro.org>
References: <20200324180800.28953-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/mmc/core/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 0a74785e575b..56f7f3600469 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2043,8 +2043,11 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
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

