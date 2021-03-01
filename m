Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2B03286FE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhCARSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232994AbhCARLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F5A164DF5;
        Mon,  1 Mar 2021 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616985;
        bh=oGjH/WxFSevkoUmxsuaDJh/WFcTzXRcAeebBI+2BCXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvosV6GZZ3tkOOSpKG8tlATMoTBUKMKwk7giikH5/c6WKgtloIx80y9vlhfoAF7j7
         5wT+rdOSanF7XSM9W8aw8QUecq314i8jPKNAYjp1QL2ffYCEB3EyjXr6uIF7xWntAD
         zEF3BcqjUDlDxgZKTJMOSoQzBQdZdo+S/WIdZ/y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/247] clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:12:22 +0100
Message-Id: <20210301161037.643265065@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index f6ddae30933f7..dae8c0c2e606f 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -138,10 +138,7 @@ static void mxs_irq_clear(char *state)
 
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



