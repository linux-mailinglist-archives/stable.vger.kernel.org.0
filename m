Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE5191875
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgCXSHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:03 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40251 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgCXSHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id 19so19597166ljj.7
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d70w+xNz4UWAEzx/SWZLFiI5SjHc8+R+STsNWkc4DPs=;
        b=t0KXcl/brHITxzzFUDmtZc21KdD0VOObPPDPiq+Taz+Ohr4xksVD72xqP8yxIb8oX9
         r+1Ais/VoziMVUH/nr2VF96kOqUsuMcB9PVloxyloqniTdlQb1mleHc/XoRKeLmSpzyb
         5oV+yW54Q0Rm/JI5Np1OCDd6xZAi/4dLyhhtYy2zuW8E0eWmp+9EQfdPgFdzKCY/qsXb
         NwEC3D/dWsNiDduQxP9LrCWZN2+vwW6k8/oRkRykWJcZxdgBx2vYrmFwnv4HbJAZSDB8
         xxROupG55qnRG9M4zYncYSLSPFneS/BEJ639q+XTdQeOmH8o3jN8AZDEKTu5ZhxOgUgx
         pfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d70w+xNz4UWAEzx/SWZLFiI5SjHc8+R+STsNWkc4DPs=;
        b=Z2ZTukQ8BzYTbIRuhZE97vZjhqOSzBEiwAgT9utVQxdG6qmELs/QlAREcRcWe+hBdd
         VVNcbHpoJbhefz0dNHPuLsKBnPLlO4eNPWOZ0OEhIgMplwF8fLIPupZm98Xk4mnaLrIv
         KOzuZLL2yULpR1B6KNtT1d7BEeLGP7XwlNa6ngEI/J2x//GLZn8ecnc4f0Ml6ojm+wFL
         RWPmhzpWaIJ3n36Gn7yI0o8vPJUWWxv3wKcC4eWXKSO0ValDQ55iYFZ3fPZWvige1lp4
         GokDdDi84KOxvbmzJDHzX4eZYgjVoSPijyGfRr/jT89mZuK3Qgcli2c2Uw6wqlQfopQa
         76Fw==
X-Gm-Message-State: ANhLgQ35rID2/BkDsja/FvbncPznE+skbyCXKF2BwzmhgoWzOEtSJl/d
        zWAhY5tIzkrVv+MMu6L8/LAcMQ==
X-Google-Smtp-Source: ADFU+vtIUuWkkPduhumvzxnwcFbQlVbY+SKPwFpeQR7AtSQrW9n1AuJG1rLk3y0gXyhoT8N4PuFTpA==
X-Received: by 2002:a2e:8ecd:: with SMTP id e13mr9686588ljl.244.1585073220414;
        Tue, 24 Mar 2020 11:07:00 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:06:59 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 5.5.12 1/5] mmc: core: Allow host controllers to require R1B for CMD6
Date:   Tue, 24 Mar 2020 19:06:46 +0100
Message-Id: <20200324180650.28819-2-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1292e3efb149ee21d8d33d725eeed4e6b1ade963 ]

It has turned out that some host controllers can't use R1B for CMD6 and
other commands that have R1B associated with them. Therefore invent a new
host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.

In __mmc_switch(), let's check the flag and use it to prevent R1B responses
from being converted into R1. Note that, this also means that the host are
on its own, when it comes to manage the busy timeout.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/mmc_ops.c | 8 +++++---
 include/linux/mmc/host.h   | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 09113b9ad679..18a7afb2a5b2 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -538,10 +538,12 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	 * If the cmd timeout and the max_busy_timeout of the host are both
 	 * specified, let's validate them. A failure means we need to prevent
 	 * the host from doing hw busy detection, which is done by converting
-	 * to a R1 response instead of a R1B.
+	 * to a R1 response instead of a R1B. Note, some hosts requires R1B,
+	 * which also means they are on their own when it comes to deal with the
+	 * busy timeout.
 	 */
-	if (timeout_ms && host->max_busy_timeout &&
-		(timeout_ms > host->max_busy_timeout))
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && timeout_ms &&
+	    host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ba703384bea0..4c5eb3aa8e72 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -333,6 +333,7 @@ struct mmc_host {
 				 MMC_CAP_UHS_SDR50 | MMC_CAP_UHS_SDR104 | \
 				 MMC_CAP_UHS_DDR50)
 #define MMC_CAP_SYNC_RUNTIME_PM	(1 << 21)	/* Synced runtime PM suspends. */
+#define MMC_CAP_NEED_RSP_BUSY	(1 << 22)	/* Commands with R1B can't use R1. */
 #define MMC_CAP_DRIVER_TYPE_A	(1 << 23)	/* Host supports Driver Type A */
 #define MMC_CAP_DRIVER_TYPE_C	(1 << 24)	/* Host supports Driver Type C */
 #define MMC_CAP_DRIVER_TYPE_D	(1 << 25)	/* Host supports Driver Type D */
-- 
2.20.1

