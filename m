Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D903328451
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhCAQdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234779AbhCAQ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8317C64F4E;
        Mon,  1 Mar 2021 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615779;
        bh=aH4USPk7FyZugFKVh0VvfwY4zfIipxgmVAqQRue1nao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUFAfqrFVJrecOMMgfpquzUPCWZXrbYvGBXFykjKUPuO4T6LulyhCSjIPSYbsCiLy
         1niBcIyYUrkTDvh1PY6Me52r3kZe04cbKxMr2cq8IUcy+bZ/hUwoYNg3ND6BEFdwqe
         fiQfQiPjfMMyfDM7L4BJCtra0arGZq2ZK7+YXsLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 056/134] clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:12:37 +0100
Message-Id: <20210301161016.311978912@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 7da390694afbaed8e0f05717a541dfaf1077ba51 ]

When DEBUG is defined this error occurs

drivers/clocksource/mxs_timer.c:138:1: error:
  expected ‘;’ before ‘}’ token

The preceding statement needs a semicolon.
Replace pr_info() with pr_debug() and remove the unneeded ifdef.

Fixes: eb8703e2ef7c ("clockevents/drivers/mxs: Migrate to new 'set-state' interface")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210118211955.763609-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/mxs_timer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index 0ba0a913b41d1..b26c3b84c5b6c 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -152,10 +152,7 @@ static void mxs_irq_clear(char *state)
 
 	/* Clear pending interrupt */
 	timrot_irq_acknowledge();
-
-#ifdef DEBUG
-	pr_info("%s: changing mode to %s\n", __func__, state)
-#endif /* DEBUG */
+	pr_debug("%s: changing mode to %s\n", __func__, state);
 }
 
 static int mxs_shutdown(struct clock_event_device *evt)
-- 
2.27.0



