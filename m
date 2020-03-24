Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D013C19188F
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCXSHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39397 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgCXSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id i20so7557875ljn.6
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7fvoYlYi4lMDSB97ToxNN2Z/j072k5ZAIM3GjTSGx0=;
        b=W3243hXbqYEDk1dAuztyaCWL36x5xDIV1TVfQezZWPWLoNYT/k7B5zUS/LZX30jiMt
         7rceCt/jtEViWdcx/0vUWC5EpI6vECCgoZ7K8CtoX3F1PXZDZiS88JuHtyYP9iOGzmgI
         OktwuvgJZpieMDyR0kS+onAzXnpPXUf0iULPK4P66yG88CJ5CeFv/p9NGaQZVT4CA79N
         +gArQKUjbQFz62xqRuWmH0vCOKi1J6L4TW9E1MIMUkJ74S5ORdDnyQLBd9hziTJw0sdL
         Enfq5k5U4l/2BfvDTd8uO+yNE5S+onHgvHAQ9QJHM479j8WMi+v9yuxMMk/zwMpm0gh4
         OBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7fvoYlYi4lMDSB97ToxNN2Z/j072k5ZAIM3GjTSGx0=;
        b=s+V/9Ku4ijqdEeeoLMcU6tJKfIE+NYN/JHbWONA9vEnrSRYZf3lYnpnCcEQ4+xB39g
         kvffgG3kdU/vb7ZyDNvWitqEK0RridYpry8+l0r7iMrI3/Xmeqnn1d0hRpNP9iS7H+c4
         QM1+zmwdblAfHDBGNorTWldZJvwokPY9lZxG8MgTgehERqVDrLIsGFMulSKJPMORyIrT
         YBll7zbQTonriwlb6oqqvBRjs0GuTtlxRlg8/vtFzO5igB4IDNoDalpZfXgEXyUgrbJS
         M3ORz0LxZ/4fBK8hOoOO3GL3H3eNJi1TIY2pFyWcXcKUkYtnExbhoZSjDPlsnSZ9hnpI
         MOBA==
X-Gm-Message-State: ANhLgQ3It9FmyM8aBaxPgpkhWgcbV1gAyXWleRPp4mkY4ebo/M+dLboN
        Vgrl8FSS6AzVsSgjeEA5q5GSzg==
X-Google-Smtp-Source: ADFU+vusW3scmpvBmi9o7o/dNk5T2lWSVhshoynti6qdN9LkC42nPpsvEZFHDPOGjBfQ8ZnBjXhdzw==
X-Received: by 2002:a05:651c:549:: with SMTP id q9mr6435344ljp.210.1585073267231;
        Tue, 24 Mar 2020 11:07:47 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 3sm12113809ljq.18.2020.03.24.11.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:46 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.4.28 3/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
Date:   Tue, 24 Mar 2020 19:07:36 +0100
Message-Id: <20200324180738.28892-4-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180738.28892-1-ulf.hansson@linaro.org>
References: <20200324180738.28892-1-ulf.hansson@linaro.org>
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
index c8804895595f..b7159e243323 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1911,9 +1911,12 @@ static int mmc_sleep(struct mmc_host *host)
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

