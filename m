Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103EB27CD2F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgI2MmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbgI2LLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:11:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C27206A5;
        Tue, 29 Sep 2020 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377905;
        bh=D3OpbZK4+998PZ46qefmAIBurWQeGCWnaWWhcztTlgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Q6KtvJ6QUQtS/A25wz4j0xV20Fb1xnauahMM8NxEieV3873HZcT8kGmQ4UDUf0Kw
         yec0oiuSXixfFSZNrvDJMI6s9vfFLkDMDtoonjg8Ycu6pqncq8Rpz8UIKIIP3LTaKY
         87lMF/R4/Q0oh4t85ygY3vOSaAfuuo9tYlP8qJEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 113/121] batman-adv: Add missing include for in_interrupt()
Date:   Tue, 29 Sep 2020 13:00:57 +0200
Message-Id: <20200929105935.782138095@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 4bba9dab86b6ac15ca560ef1f2b5aa4529cbf784 ]

The fix for receiving (internally generated) bla packets outside the
interrupt context introduced the usage of in_interrupt(). But this
functionality is only defined in linux/preempt.h which was not included
with the same patch.

Fixes: 279e89b2281a ("batman-adv: bla: use netif_rx_ni when not in interrupt context")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index f8b117acb9443..f24b1cee4993f 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -36,6 +36,7 @@
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
+#include <linux/preempt.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/seq_file.h>
-- 
2.25.1



