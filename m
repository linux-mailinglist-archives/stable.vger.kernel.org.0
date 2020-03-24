Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED54191876
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCXSHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45924 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgCXSHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id t17so8968658ljc.12
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jV/7nbfuaKTyqKa8OwvFG6+JXR2maNrlTVAP3xkJ9Sg=;
        b=Nr9lG9gFY7ZMGr7WQbQM+ULYB6/xTYx3Te1zDFhqDPrY25oLSiTWtrndYBc3RDTCxs
         hI431Fl+rSR42j03Cpdat3TG9yjjeUhgm8vr7Lm8agRyifUj0YqqFsTA01XeTztJr3bk
         /vsyojg+C8+15hiyhbq1trPseqg3Rs6u1YE1csF7vwJZ9oKBGYpsJwOCww4Zu1vvAie+
         5Yvk0TLSCX9OT7JuObegYGYw3DADkO6ltlL0waZ9C2KYjRo03XxTNh4LYlb+6a7PibrA
         +A9LWZ8IWMeSoX8EFdPfddrH//7/tIZJYWdt49fkXsCuqatwz++QHn3gtnmrTGg2mUtG
         aiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jV/7nbfuaKTyqKa8OwvFG6+JXR2maNrlTVAP3xkJ9Sg=;
        b=oZoNwPNFMRLDQX/7C0FukZIGNN25hVdUzAsaacC2X+bm3C6JESWQXwLfFlSG0XZcCW
         bppTxCg466wnwm9KW7a6C7oF91bQAKTGXS2d6d26O0qILpVjU3ZQje38UDs79Nc5ZJxm
         bLjYEovLruyG+hkroVDgp0gqFg8c5cJnHjAmgNu4lhs275veRJkuNWIU1KBLZQkvrqCC
         Rr4Ly3Yuyr4cKOJOMyaYHs2bHsxKAvyJvgZGhtyK8PUC9mV2iyRb4BXJ+pzlUeYzKwcL
         nJddTXR95WIcgTVGDeOuzE2BjjLVNswB2XE52EXzowgE1COpNWZC7qHvwFwnirXEIwDA
         XoJg==
X-Gm-Message-State: ANhLgQ2ZbqnFSzrTcHE1Ct72xgSM4gX6BIF4/tJGFHGTWqbkb+nx/qr9
        y7waD5wuUlKDKjdOW+45apiHFA==
X-Google-Smtp-Source: ADFU+vsQe4e5JBMVEMj4Q5gE1FAQM9i4VD1CpnhHiOkdLlVJm68Rqeot7zN3BU4u6c5J7m1JtpUq2g==
X-Received: by 2002:a05:651c:1190:: with SMTP id w16mr17736083ljo.119.1585073222121;
        Tue, 24 Mar 2020 11:07:02 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:01 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 5.5.12 2/5] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
Date:   Tue, 24 Mar 2020 19:06:47 +0100
Message-Id: <20200324180650.28819-3-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
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

