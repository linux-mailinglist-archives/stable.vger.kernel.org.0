Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27962E3CDD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438571AbgL1OIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438568AbgL1OIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C58207CC;
        Mon, 28 Dec 2020 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164441;
        bh=kxrCbyT3PxzfcGh20bH6TjoHTOAC0oaWrGIUi+f+FkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdr4Q6ReOXEqlJQ4lM2zWRODZFReE5qx1zbdJqajn8n/ekGOAeMKO34cMrbL9qBMc
         GmwjADb/8JrIvW/VLzR5jJKlxYD2WtcZSW8pNX5akJQW9Kz7tx2BwG8UYIr7Kx9BDi
         l1tpam3g9p+sLPk6pI+jgz2QJ73klmPxGC4Z7elA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Yin <carl.yin@quectel.com>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/717] bus: mhi: core: Fix null pointer access when parsing MHI configuration
Date:   Mon, 28 Dec 2020 13:42:29 +0100
Message-Id: <20201228125028.200166670@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Yin <carl.yin@quectel.com>

[ Upstream commit f4d0b39c842585c74bce8f8a80553369181b72df ]

Functions parse_ev_cfg() and parse_ch_cfg() access mhi_cntrl->mhi_dev
before it is set in function mhi_register_controller(),
use cntrl_dev instead of mhi_dev.

Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Signed-off-by: Carl Yin <carl.yin@quectel.com>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 0a09f8215057d..8cefa359fccd8 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -610,7 +610,7 @@ static int parse_ev_cfg(struct mhi_controller *mhi_cntrl,
 {
 	struct mhi_event *mhi_event;
 	const struct mhi_event_config *event_cfg;
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
+	struct device *dev = mhi_cntrl->cntrl_dev;
 	int i, num;
 
 	num = config->num_events;
@@ -692,7 +692,7 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 			const struct mhi_controller_config *config)
 {
 	const struct mhi_channel_config *ch_cfg;
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
+	struct device *dev = mhi_cntrl->cntrl_dev;
 	int i;
 	u32 chan;
 
-- 
2.27.0



