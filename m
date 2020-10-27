Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9629C4BC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901230AbgJ0R5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901226AbgJ0OVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D62206F7;
        Tue, 27 Oct 2020 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808482;
        bh=aU/UoA9JIqq7KS5xytmAjERfjek2tcD+Ech4+blNA2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnFNQzAAHMkPSvRIOjy0Tv0ADV5lPKRBeTlyhYvtcadX587IKb53D9bVOaffGugQZ
         5r+5VfIcw2+M32SUrhehtT3gcMVbRPa87J5JlaesZuHiD2dOY+UIs6C+N9yMlUW8qh
         ORi4UeIvCDVzG+GTVOAbh3nizJxO0dcTW4ewjXWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/264] slimbus: core: check get_addr before removing laddr ida
Date:   Tue, 27 Oct 2020 14:52:45 +0100
Message-Id: <20201027135435.710249903@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit f97769fde678e111a1b7b165b380d8a3dfe54f4e ]

logical address can be either assigned by the SLIMBus controller or the core.
Core uses IDA in cases where get_addr callback is not provided by the
controller.
Core already has this check while allocating IDR, however during absence
reporting this is not checked. This patch fixes this issue.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200925095520.27316-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 943172806a8a7..6e690aaacad1e 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -297,8 +297,8 @@ void slim_report_absent(struct slim_device *sbdev)
 	mutex_lock(&ctrl->lock);
 	sbdev->is_laddr_valid = false;
 	mutex_unlock(&ctrl->lock);
-
-	ida_simple_remove(&ctrl->laddr_ida, sbdev->laddr);
+	if (!ctrl->get_laddr)
+		ida_simple_remove(&ctrl->laddr_ida, sbdev->laddr);
 	slim_device_update_status(sbdev, SLIM_DEVICE_STATUS_DOWN);
 }
 EXPORT_SYMBOL_GPL(slim_report_absent);
-- 
2.25.1



