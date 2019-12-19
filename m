Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE801126B9B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfLSSye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbfLSSyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93843227BF;
        Thu, 19 Dec 2019 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781673;
        bh=1cRpwCqdems5pgPypXH00pHUKyYW+gGiZGNNdSfvfJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piQs8L6R/oOwRHt4K1ZKtyyirKduH/wAiT0NBxHYqByKvZsYVhuXE/qo1I//XbY+q
         6BPEq7M9iL2nZ/l9oB8mwLhB3EFqbttGIESenRjnxMuWEoiT9jLQLhv2MHaRWWJWJd
         F8EuMy40bt2O/gYIUpK4thJkkKw1QqYZGav0kq40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 04/80] mmc: core: Drop check for mmc_card_is_removable() in mmc_rescan()
Date:   Thu, 19 Dec 2019 19:33:56 +0100
Message-Id: <20191219183034.205788544@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 99b4ddd8b76a6f60a8c2b3775849d65d21a418fc upstream.

Upfront in mmc_rescan() we use the host->rescan_entered flag, to allow
scanning only once for non-removable cards. Therefore, it's also not
possible that we can have a corresponding card bus attached (host->bus_ops
is NULL), when we are scanning non-removable cards.

For this reason, let' drop the check for mmc_card_is_removable() as it's
redundant.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2297,11 +2297,8 @@ void mmc_rescan(struct work_struct *work
 
 	mmc_bus_get(host);
 
-	/*
-	 * if there is a _removable_ card registered, check whether it is
-	 * still present
-	 */
-	if (host->bus_ops && !host->bus_dead && mmc_card_is_removable(host))
+	/* Verify a registered card to be functional, else remove it. */
+	if (host->bus_ops && !host->bus_dead)
 		host->bus_ops->detect(host);
 
 	host->detect_change = 0;


