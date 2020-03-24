Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5543191878
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCXSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:06 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37780 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgCXSHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:06 -0400
Received: by mail-lj1-f195.google.com with SMTP id r24so19697926ljd.4
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvF8ZHqHncSrlilA+ZOuPkJJR+jnp9zcVFv/87o5LaA=;
        b=oK1mzPqfkxG/iI7JuTymhz8PwdWqxx+e7x0Jqu9BHN8pgSeEh45sB+tqc+dlKIJTmG
         sk8XCKxhW5qzM5V4oHS5C5JEA0bBjvnSWVYMvK/93WwrGfLPha32t1yQq1SG6HznyZnV
         mPQJ17ERFSlNPAtu6c1KFdJ0vSzhSp3rdV7rSsQsPNz+sj7xIw3wzV2vnxExyFytnAVN
         KLVDtc81LqNc9JKMczR3pZs5FpNW60muKtRc+V3mN29HPpSwSxNfbARpcpzZkCNDSKMy
         WdcQB9aM1If7ayqZXCks+ykKcqbvlvGkDt2BzsOdscnWZOvmZ9kAMBvpdLZ154LOKbYz
         xZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvF8ZHqHncSrlilA+ZOuPkJJR+jnp9zcVFv/87o5LaA=;
        b=i3Eyz/mVNKHkir0QkF7jFX3feFaLEzMjkDqzOWirFpBoK8qlVCOMAGyCGZqbyAXC/X
         Uo3A9uk3uciYCmwpmlfu4OC1mLBTevI0EUaNXxHvMIp+Ko54E85ebl19OSx0jeNFJnqY
         kEAKPzvF9kiExw7D2Fi8N8+3Ef8FX0pRJrKaUJVukOwQ38v1T30/U1Ha+qWY1v+kWEgb
         2D21nltQ6d6VF4WMoZUGPvHXR8LpT+am0/8x4bck0Msu59XeOVUwQ79JUmuUMhVu54AL
         TDgYACg9qopb1vOU30B05i+PlLuo9pEBsx0cTKk69LWBEy//RQrMhrlCpUt1sOiRwMiL
         boBQ==
X-Gm-Message-State: ANhLgQ2WeH8t6oLXX6k1ck+Q+jMkox24+f2E2pfIqPwEitTwfazQKXgd
        NbhXsw2qAf7DA4mHSQdvJGlS1A==
X-Google-Smtp-Source: ADFU+vuj6+OEplFWywKu8+N/4cJzYyfPXNEg64BZexka+oV9s8DhnK0JoBBEXqnwk0u9zvcy23pWig==
X-Received: by 2002:a2e:9c4:: with SMTP id 187mr18342643ljj.89.1585073224123;
        Tue, 24 Mar 2020 11:07:04 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:03 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.5.12 3/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
Date:   Tue, 24 Mar 2020 19:06:48 +0100
Message-Id: <20200324180650.28819-4-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
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
index f6912ded652d..de14b5845f52 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1910,9 +1910,12 @@ static int mmc_sleep(struct mmc_host *host)
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

