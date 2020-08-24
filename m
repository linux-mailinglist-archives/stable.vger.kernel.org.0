Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980EC24F9BE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgHXIkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgHXIkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62D4D22B49;
        Mon, 24 Aug 2020 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258419;
        bh=8ZfPDjBednZIPM4jhBpxyi85ckrUlCtixwY+7Murw8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fe7TPdhXQH7uOIMjXKaUnWJ1zVckJvCA09eV3tuBNu+py6EA541Krb3IkwgrtYTZP
         vc16egeTbjA1WpSARULDs2uhBJFJcOX3JGmgrHLQqs6Wb2+20tN+AhHMj7uX+urRzI
         U/oLANdnRw3opUWaBrEZvdqDr7WJfbmdrNBNfvcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 033/124] opp: Reorder the code for !target_freq case
Date:   Mon, 24 Aug 2020 10:29:27 +0200
Message-Id: <20200824082411.048028270@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit b23dfa3543f31fbb8c0098925bf90fc23193d17a ]

Reorder the code a bit to make it more readable. Add additional comment
as well.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Clément Péron <peron.clem@gmail.com>
Tested-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 195fcaff18448..2d3880b3d6ee0 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -817,15 +817,21 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 	}
 
 	if (unlikely(!target_freq)) {
-		if (opp_table->required_opp_tables) {
-			ret = _set_required_opps(dev, opp_table, NULL);
-		} else if (!_get_opp_count(opp_table)) {
+		/*
+		 * Some drivers need to support cases where some platforms may
+		 * have OPP table for the device, while others don't and
+		 * opp_set_rate() just needs to behave like clk_set_rate().
+		 */
+		if (!_get_opp_count(opp_table))
 			return 0;
-		} else {
+
+		if (!opp_table->required_opp_tables) {
 			dev_err(dev, "target frequency can't be 0\n");
 			ret = -EINVAL;
+			goto put_opp_table;
 		}
 
+		ret = _set_required_opps(dev, opp_table, NULL);
 		goto put_opp_table;
 	}
 
-- 
2.25.1



