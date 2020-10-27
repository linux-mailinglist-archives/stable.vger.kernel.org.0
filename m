Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D529B374
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766866AbgJ0Ot3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766539AbgJ0Ot2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D4E9207DE;
        Tue, 27 Oct 2020 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810168;
        bh=07fMfKYU6c0o/gMbRmGlXpokkcNIDhS9nbF01ONF268=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwx5MZ/CwVR5XZ22TeddEXbmeNi+7m5l+gvJ7gG4UtBJCjJWKZRYQBeWbZKvVye8G
         rJYo3SaWGxmp46SgxfKIOnRTAfMbpQEeHMW4LqJIX+y8XO1O9kjZqeg33cV9ZTnPUS
         PmXnUymKKlOz+9qnrpPIhin+HiJ98X4KtbkJSS/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 013/633] net/smc: fix use-after-free of delayed events
Date:   Tue, 27 Oct 2020 14:45:56 +0100
Message-Id: <20201027135523.308963994@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit d535ca1367787ddc8bff22d679a11f864c8228bc ]

When a delayed event is enqueued then the event worker will send this
event the next time it is running and no other flow is currently
active. The event handler is called for the delayed event, and the
pointer to the event keeps set in lgr->delayed_event. This pointer is
cleared later in the processing by smc_llc_flow_start().
This can lead to a use-after-free condition when the processing does not
reach smc_llc_flow_start(), but frees the event because of an error
situation. Then the delayed_event pointer is still set but the event is
freed.
Fix this by always clearing the delayed event pointer when the event is
provided to the event handler for processing, and remove the code to
clear it in smc_llc_flow_start().

Fixes: 555da9af827d ("net/smc: add event-based llc_flow framework")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_llc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -233,8 +233,6 @@ static bool smc_llc_flow_start(struct sm
 	default:
 		flow->type = SMC_LLC_FLOW_NONE;
 	}
-	if (qentry == lgr->delayed_event)
-		lgr->delayed_event = NULL;
 	smc_llc_flow_qentry_set(flow, qentry);
 	spin_unlock_bh(&lgr->llc_flow_lock);
 	return true;
@@ -1590,13 +1588,12 @@ static void smc_llc_event_work(struct wo
 	struct smc_llc_qentry *qentry;
 
 	if (!lgr->llc_flow_lcl.type && lgr->delayed_event) {
-		if (smc_link_usable(lgr->delayed_event->link)) {
-			smc_llc_event_handler(lgr->delayed_event);
-		} else {
-			qentry = lgr->delayed_event;
-			lgr->delayed_event = NULL;
+		qentry = lgr->delayed_event;
+		lgr->delayed_event = NULL;
+		if (smc_link_usable(qentry->link))
+			smc_llc_event_handler(qentry);
+		else
 			kfree(qentry);
-		}
 	}
 
 again:


