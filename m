Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010EB66E02
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfGLMfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbfGLMeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D656F216B7;
        Fri, 12 Jul 2019 12:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934857;
        bh=810QhP04pMIX2PIb4dJFz81zjKz5dk8ZjqnXMiK9jNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHGEr27kVxhipkJEhm1qkXO/BwB2Qm7NRI22Gu3KqkZ7PdYxbY7ODCznNtXj2awJG
         JQbm0tGIGKMDPlYgw/OyXbQXpxI3LbhzQzEEJVvQPBTpX0iLxx6k5fpcIExZbfFAxB
         1lLpiTynaXTjvT0LVHYVB2nFxxJXr6w7vKu0jTIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.2 54/61] staging: vchiq: make wait events interruptible
Date:   Fri, 12 Jul 2019 14:20:07 +0200
Message-Id: <20190712121623.644648361@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 77cf3f5dcf35c8f547f075213dbc15146d44cc76 upstream.

The killable version of wait_event() is meant to be used on situations
where it should not fail at all costs, but still have the convenience of
being able to kill it if really necessary. Wait events in VCHIQ doesn't
fit this criteria, as it's mainly used as an interface to V4L2 and ALSA
devices.

Fixes: 852b2876a8a8 ("staging: vchiq: rework remove_event handling")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -395,13 +395,21 @@ remote_event_create(wait_queue_head_t *w
 	init_waitqueue_head(wq);
 }
 
+/*
+ * All the event waiting routines in VCHIQ used a custom semaphore
+ * implementation that filtered most signals. This achieved a behaviour similar
+ * to the "killable" family of functions. While cleaning up this code all the
+ * routines where switched to the "interruptible" family of functions, as the
+ * former was deemed unjustified and the use "killable" set all VCHIQ's
+ * threads in D state.
+ */
 static inline int
 remote_event_wait(wait_queue_head_t *wq, struct remote_event *event)
 {
 	if (!event->fired) {
 		event->armed = 1;
 		dsb(sy);
-		if (wait_event_killable(*wq, event->fired)) {
+		if (wait_event_interruptible(*wq, event->fired)) {
 			event->armed = 0;
 			return 0;
 		}


