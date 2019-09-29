Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D00C1580
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfI2OC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfI2OC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61E3F2082F;
        Sun, 29 Sep 2019 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765775;
        bh=sgzGlI1/+w+8UgTyIP745ekMfbCwyPb117mkLDg4PDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoaMxDQc6BnclTjNExMECoH5IQsp5zL3KxXxHdPHlyeYiHIs9CcgTeimRhTjq3VO2
         IV0koAC532+H/d13yuUQc0DA+P3TVBxQQl9YVDY9j2Kn++1K8t4Ix2MEMNRsvqsl01
         tqZi7siUnWTFjWWkxkymXAKBOjKrk9qR3hWlgwsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.3 02/25] clocksource/drivers/timer-of: Do not warn on deferred probe
Date:   Sun, 29 Sep 2019 15:56:05 +0200
Message-Id: <20190929135007.562831229@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 763719771e84b8c8c2f53af668cdc905faa608de upstream.

Deferred probe is an expected return value for clk_get() on many
platforms. The driver deals with it properly, so there's no need
to output a warning that may potentially confuse users.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/timer-of.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/clocksource/timer-of.c
+++ b/drivers/clocksource/timer-of.c
@@ -113,8 +113,10 @@ static __init int timer_of_clk_init(stru
 	of_clk->clk = of_clk->name ? of_clk_get_by_name(np, of_clk->name) :
 		of_clk_get(np, of_clk->index);
 	if (IS_ERR(of_clk->clk)) {
-		pr_err("Failed to get clock for %pOF\n", np);
-		return PTR_ERR(of_clk->clk);
+		ret = PTR_ERR(of_clk->clk);
+		if (ret != -EPROBE_DEFER)
+			pr_err("Failed to get clock for %pOF\n", np);
+		goto out;
 	}
 
 	ret = clk_prepare_enable(of_clk->clk);


