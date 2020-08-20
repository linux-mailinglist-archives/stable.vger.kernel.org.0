Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23CA24B6B3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgHTKRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgHTKRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7BA2075E;
        Thu, 20 Aug 2020 10:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918634;
        bh=UtA49LqjWfOiF+UegpH3bqGT9EIXZNTUrGsjO15YjNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N2eXMzFK7GvyzKXLZqi3znQtGJH4UgmMT3uwaMtiudpbsq5oylHTnYtb1Kn54rF1
         i8fizR2bAJbc4K8iYotveOJGmBCaTSNRY3RbhFIDLkJwaq2RLk0A/RWGXCk4vZcGr6
         8kX5oSwe3S1GxCyOvq26ZHt5l3IqR0Id1zBaeElc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 004/149] ath9k_htc: release allocated buffer if timed out
Date:   Thu, 20 Aug 2020 11:21:21 +0200
Message-Id: <20200820092125.903127111@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 853acf7caf10b828102d92d05b5c101666a6142b ]

In htc_config_pipe_credits, htc_setup_complete, and htc_connect_service
if time out happens, the allocated buffer needs to be released.
Otherwise there will be memory leak.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 257b6ee51e54b..1af216aa5adae 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -175,6 +175,7 @@ static int htc_config_pipe_credits(struct htc_target *target)
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC credit config timeout\n");
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -211,6 +212,7 @@ static int htc_setup_complete(struct htc_target *target)
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC start timeout\n");
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -284,6 +286,7 @@ int htc_connect_service(struct htc_target *target,
 	if (!time_left) {
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
-- 
2.25.1



