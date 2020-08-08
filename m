Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6AA23FBCD
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgHHXvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgHHXgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B0B206D8;
        Sat,  8 Aug 2020 23:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929766;
        bh=PtAUaUXWVdMKmJKMJdJwK0Vyk3IPL8CzcjLOySQH6vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAg5oNWq7tEZvjPhrIDA2xr+sWwwcZRSbU353rxNpMPWdTqMtgcNhyQbNuIeBR98n
         175va/DNv1t97fSbayHzJgF1HtIiiRwy68/JMzrnGUzTlvUDUJVSdDMyWYAT2MeIcA
         nLtgJcrYS8zEFQwGXGnvoewJrPDJG3TWdER+oW4I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 18/72] soc: qcom: rpmh-rsc: Don't use ktime for timeout in write_tcs_reg_sync()
Date:   Sat,  8 Aug 2020 19:34:47 -0400
Message-Id: <20200808233542.3617339-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit be24c6a71ecfbd9436ea1f496eb518a53e06368c ]

The write_tcs_reg_sync() may be called after timekeeping is suspended
so it's not OK to use ktime.  The readl_poll_timeout_atomic() macro
implicitly uses ktime.  This was causing a warning at suspend time.

Change to just loop 1000000 times with a delay of 1 us between loops.
This may give a timeout of more than 1 second but never less and is
safe even if timekeeping is suspended.

NOTE: I don't have any actual evidence that we need to loop here.
It's possibly that all we really need to do is just read the value
back to ensure that the pipes are cleaned and the looping/comparing is
totally not needed.  I never saw the loop being needed in my tests.
However, the loop shouldn't hurt.

Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Fixes: 91160150aba0 ("soc: qcom: rpmh-rsc: Timeout after 1 second in write_tcs_reg_sync()")
Reported-by: Maulik Shah <mkshah@codeaurora.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200528074530.1.Ib86e5b406fe7d16575ae1bb276d650faa144b63c@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index 076fd27f3081c..906778e2c1fae 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -175,13 +175,21 @@ static void write_tcs_reg(const struct rsc_drv *drv, int reg, int tcs_id,
 static void write_tcs_reg_sync(const struct rsc_drv *drv, int reg, int tcs_id,
 			       u32 data)
 {
-	u32 new_data;
+	int i;
 
 	writel(data, tcs_reg_addr(drv, reg, tcs_id));
-	if (readl_poll_timeout_atomic(tcs_reg_addr(drv, reg, tcs_id), new_data,
-				      new_data == data, 1, USEC_PER_SEC))
-		pr_err("%s: error writing %#x to %d:%#x\n", drv->name,
-		       data, tcs_id, reg);
+
+	/*
+	 * Wait until we read back the same value.  Use a counter rather than
+	 * ktime for timeout since this may be called after timekeeping stops.
+	 */
+	for (i = 0; i < USEC_PER_SEC; i++) {
+		if (readl(tcs_reg_addr(drv, reg, tcs_id)) == data)
+			return;
+		udelay(1);
+	}
+	pr_err("%s: error writing %#x to %d:%#x\n", drv->name,
+	       data, tcs_id, reg);
 }
 
 /**
-- 
2.25.1

