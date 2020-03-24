Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF02719188D
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCXSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:49 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36292 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgCXSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id g12so19641862ljj.3
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jV/7nbfuaKTyqKa8OwvFG6+JXR2maNrlTVAP3xkJ9Sg=;
        b=Wz90s44MGzWvrsmz1uJcwRY+mxF8cBzMgpjGFrN9rk1gU6p+cEh3/WTyNYu8wAX6qq
         GHyWZLIRkAVWTghZx3jAnctO9lpI3+M7XwZ2IUQxuxz797B+syG6+1QXN3XzlZV2om3s
         jDeIxAgfklfEViDCFHjbR4SEaholGlgx2hFN4lYo9dBxRKcWRhObbCbrO1WDKkH+UfeH
         USXkpiCN6EisNwrJPT8xWclP3rIZxViyQCOnBVp45gBziBaOgsWOgdO/G7U+uYMXl+lH
         KxzRpnHn/4jvYlk8IIA13VAI/latgqTgnswkcAHp0ynQ7pHzibAVIKxitXlUBQUFoQUy
         qBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jV/7nbfuaKTyqKa8OwvFG6+JXR2maNrlTVAP3xkJ9Sg=;
        b=nfXkBU0KArdohXppV0fFPrYP3xUtY5fcpGMcU8IxvvxKztS6deKoQMbIpQ4I+YrP3z
         XU8/+uGBlaCqtfYKf3BKvW8CLuBzRcQmbuVmT24Ns3pGT7o5tl1O+NLVs7S1aRTE0h8T
         oAwDuoYn2k/Xv2aHGDH1Ck2cLnHHzSHZlcBO2O4lUZymb+QysbfdG9MrvI3BfWYlRF8q
         lq0z01rlsQh/OJENsydfJW4u3A9IfypcZeC/ChbmGyCD2G2fvphqNAYT+tp18BKlzFvs
         vrDnN1aicim0Eb0rB04v1UPq6vNBav7YRSkS/JPh2diHsIxkgplO3l8VvJnqm2m1IuQH
         DF7Q==
X-Gm-Message-State: ANhLgQ0QTRKrCmA9FwZ9wRpjFVdqyNoIcgwzy80cgiJ8XGR1EKDKDm1j
        +/73ZdVwxF4MwbCFPT3XDDZLYw==
X-Google-Smtp-Source: ADFU+vt4gv+yP19jGJNzIU2UapMY/Nc94lp4crc7owbZtBdlHAq8CUjoKgNdxStfdm1v4pQsJX92OA==
X-Received: by 2002:a2e:3210:: with SMTP id y16mr18008504ljy.49.1585073265680;
        Tue, 24 Mar 2020 11:07:45 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 3sm12113809ljq.18.2020.03.24.11.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:45 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 5.4.28 2/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
Date:   Tue, 24 Mar 2020 19:07:35 +0100
Message-Id: <20200324180738.28892-3-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180738.28892-1-ulf.hansson@linaro.org>
References: <20200324180738.28892-1-ulf.hansson@linaro.org>
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
index abf8f5eb0a1c..26644b7ec13e 100644
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

