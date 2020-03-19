Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311BD18B6C8
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgCSNZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbgCSNZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C262080C;
        Thu, 19 Mar 2020 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624301;
        bh=+ZWBgP1H1PJaYmkcqqo0h/4VC5fxqrnCIWwQ5MstPNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjL0HK8WSQxIJSuGunH9wxmcwAX/V+C07rSnXjyWrBFrGADJ7AfNmBjPAr463hQ+y
         ws2mefF/5lEK/nx1TO8aD2vzbkXiNh8M2RZNyjALoB9ctPzm10JaJ+e87l1bdySpKl
         1tPxa5ZY20qUwMTgMIcdbBswR+/ZdREqvjvOAgv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 07/65] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
Date:   Thu, 19 Mar 2020 14:03:49 +0100
Message-Id: <20200319123928.582537483@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/mmc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index f6912ded652dc..de14b5845f525 100644
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



