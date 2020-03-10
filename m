Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BCA1801E8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCJPdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:33:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41700 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJPdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:33:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id o10so7906821ljc.8
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFF5Nn+0MYGNKIt8ggfC3I2q2J2gXyLFnHV/fd1EhtU=;
        b=j/MqCVvH17KM8gW1kqrm22z+IZnEON6jMprpfTXFef3hwZzBL/5WAe/3AdQmRut44P
         uE9EZfoKSXp6bNBoCpNmkPmzcOzDyAAMLwwXnkXYhltJXzDirX1mUsEAGe5XfUsdFPMc
         MEsDi86NBxIuRq5anIInjaWiBP/7hw2xNqWSBLrFlkj71pjeqd8YhbKJXNU+QEtHLEA4
         eVhearQSqCxRkE92r1r5r5rtFaElLAfNHzr4mHC5dhwnzxSoxJaNfPCfq+LbVA4uyz9C
         UIzG7htevwJ6oZTs52ZmtrT/4c2NbklYogsaUxD987R9bYOpGG1RDGWqNcPNkcfWQxtE
         aFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFF5Nn+0MYGNKIt8ggfC3I2q2J2gXyLFnHV/fd1EhtU=;
        b=OXxBot/NRV3aOW4w3o5nj6kBlemSYFrgWEMESey82CsWSsjXkY/ycjOdSMGMaza90A
         sAySdd2JQmOgTmCKpqb0bjiWfcVzNA1XjfXHMb4iC6YwRce+0G08dmoiKWKVx9FFTaNO
         iiRAfykYPflhQ13ZLKGJpRl9yekz3Z0rC+twa4qqPk2T8fge/zmvbI/Bw25odJlqkPNY
         qpuAfZoldOPyja21y1AVYWig/gv4ylSTlatdWD0huXd1GUUEe2JRjU3LhidyHStdG4b1
         dsMJSG4tJ7NmHAixYK9QfrrGbHZE8iqy/sgDy6jNw8p7Vp5IwLNmzNE2Ul6Wx7UL/BWQ
         Y8lw==
X-Gm-Message-State: ANhLgQ32zhPWMQvHqQNkh1U2A+6YT2PVHCHQT08m/Fufcn5TZrbMOciY
        HEteiYYrMbuLz5YQbrAp+YuSRw==
X-Google-Smtp-Source: ADFU+vtmiH30+Gm0I+Xbs8uD729V2mXSp7zVFQvsuP5yXIuBa5z2yMtZD6BoHHuDJ5/la1sxw6jVOA==
X-Received: by 2002:a2e:b1c2:: with SMTP id e2mr4080968lja.288.1583854429815;
        Tue, 10 Mar 2020 08:33:49 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id c22sm17283776lfi.41.2020.03.10.08.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:33:49 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Shawn Lin <shawn.lin@rock-chips.com>, mirq-linux@rere.qmqm.pl,
        Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
Date:   Tue, 10 Mar 2020 16:33:38 +0100
Message-Id: <20200310153340.5593-3-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310153340.5593-1-ulf.hansson@linaro.org>
References: <20200310153340.5593-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aa54d359dab7..a971c4bcc442 100644
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

