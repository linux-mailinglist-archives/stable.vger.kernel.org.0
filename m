Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1191819189B
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgCXSIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:08:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44553 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgCXSIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:08:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id p14so3907476lji.11
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/YxNSIqnPUr4VjEbur5ld6du3CHk+yHVEsRun2OwXw=;
        b=WzIwycBAI/Nyo5430Z+dYSHJe3138HP7s9AT/1sbgqUv8VU+d+5X8tWuSgs7Cxdimy
         RynjsTaP+nifzo2kiJGn+veNYVo3jG3zwsm2FLLx9JJ+ZnueEq0V5wbwpQjenN2k1QpU
         eDLsxL/Bn9OZoVZRae6lh4InQwVmXMVEbg3V9gT9n2AnqtPHvnzsVvmW6/Gdv0Rmi8o3
         w1JVDgL0YKsSJEif1QEzbQ7CCEFrgV35pl24DAcfKCoJOx5QZCGxDwPizzboQJGsWhu2
         UZ2a9cmvtSAaUSmc3PjW7XRQ02IanguDWkT9IHTl2qOlYJ8iRF1574mK5Ch4zF1e7YJg
         9sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/YxNSIqnPUr4VjEbur5ld6du3CHk+yHVEsRun2OwXw=;
        b=kFM2LoQqvW4BpBw45Ocv9cI5HibO3GygGNaUnt3X7c/0SZVPMrUyeG5pUEA+2JZ9ag
         USyhDzn3sTL9c+XzlOCYIXbu34IPCP7k9Jwkn8F/AVtw/HWh1ScUnjSAUgs6++o7nXwG
         frqlFImWZjt+8lIJS6nMY6xB3/B7jI1W5VqWQ8qNrGHWeOkhl6LbqMwCuaROomU7YtTq
         ytqRAPCLoIZb4MSxWrdAJdmNP/SMSffzm/rHkac5j3os595J1UJw5SIbALFGQo2BCmd9
         IfBk3oiOc0U+C6IYVxgrEaxBq2MRvWpaPZdFlvKg7mDWzRPYKmm6vLclIF8+CJwoFgLI
         gdxQ==
X-Gm-Message-State: ANhLgQ0RpLWL172ZW7Sssol1ztMnf6uhhbReTNY/cj7RwswbDLE98da+
        7Meort2xKG7i6E3ZCW6Hw5ZV0g==
X-Google-Smtp-Source: ADFU+vuKgIrcj8NzsvCDj7GQ1mhfxPF3wuWv58i9um0vFVuiWKd8MpP+JfmhjN+VWFrcHuBT1XlNQg==
X-Received: by 2002:a2e:b801:: with SMTP id u1mr17057577ljo.84.1585073289261;
        Tue, 24 Mar 2020 11:08:09 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id s10sm11029858ljp.87.2020.03.24.11.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:08:08 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.19.113 3/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
Date:   Tue, 24 Mar 2020 19:07:58 +0100
Message-Id: <20200324180800.28953-4-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180800.28953-1-ulf.hansson@linaro.org>
References: <20200324180800.28953-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 18d200460cd73636d4f20674085c39e32b4e0097 ]

The busy timeout for the CMD5 to put the eMMC into sleep state, is specific
to the card. Potentially the timeout may exceed the host->max_busy_timeout.
If that becomes the case, mmc_sleep() converts from using an R1B response
to an R1 response, as to prevent the host from doing HW busy detection.

However, it has turned out that some hosts requires an R1B response no
matter what, so let's respect that via checking MMC_CAP_NEED_RSP_BUSY. Note
that, if the R1B gets enforced, the host becomes fully responsible of
managing the needed busy timeout, in one way or the other.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200311092036.16084-1-ulf.hansson@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/mmc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index f1fe446eee66..5ca53e225382 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1901,9 +1901,12 @@ static int mmc_sleep(struct mmc_host *host)
 	 * If the max_busy_timeout of the host is specified, validate it against
 	 * the sleep cmd timeout. A failure means we need to prevent the host
 	 * from doing hw busy detection, which is done by converting to a R1
-	 * response instead of a R1B.
+	 * response instead of a R1B. Note, some hosts requires R1B, which also
+	 * means they are on their own when it comes to deal with the busy
+	 * timeout.
 	 */
-	if (host->max_busy_timeout && (timeout_ms > host->max_busy_timeout)) {
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout)) {
 		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
 	} else {
 		cmd.flags = MMC_RSP_R1B | MMC_CMD_AC;
-- 
2.20.1

