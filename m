Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE741780CE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbgCCR6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbgCCR6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9CA206D5;
        Tue,  3 Mar 2020 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258331;
        bh=ggxuYCgz1u3GcE7u9ixBow/LaXc7aRuMwLgM6eGzt54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkYGNTA2ToL5z103Bb8+7edXWanLk3XB4Re4NOLg9XxASW5M0tKB/4K6o/mGstgc2
         PNpSUUTi+MqLS6QfSzbK6hlllx0HzKKmsHpducLh+CANTaua/cJwYhsbxHUrQQJHfC
         yo+CEx51CLzCL+p7muAMSox5GK04o27WLqokLE2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/87] irqchip/gic-v3-its: Fix misuse of GENMASK macro
Date:   Tue,  3 Mar 2020 18:42:52 +0100
Message-Id: <20200303174349.180457479@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

[ Upstream commit 20faba848752901de23a4d45a1174d64d2069dde ]

Arguments are supposed to be ordered high then low.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/ab5deb4fc3cd604cb620054770b7d00016d736bc.1562734889.git.joe@perches.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bf7b69449b438..f9b73336a39ee 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -208,7 +208,7 @@ static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 
 static struct its_collection *valid_col(struct its_collection *col)
 {
-	if (WARN_ON_ONCE(col->target_address & GENMASK_ULL(0, 15)))
+	if (WARN_ON_ONCE(col->target_address & GENMASK_ULL(15, 0)))
 		return NULL;
 
 	return col;
-- 
2.20.1



