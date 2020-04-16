Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507B61ACA0A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbgDPPam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731001AbgDPNn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C9452076D;
        Thu, 16 Apr 2020 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044607;
        bh=uq4hJNtqFZPJMrmWI/E4aG4wnFS/dFvqaSP8vydg5S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJ17n6wWe0YKRoHU9ySYudFZKBWQhXxwtjrpwJ1+qXht0Nx64JuQm373TVHQNI7dC
         JipwBr+ilwgfjTgqitcioU4j2ZJ7eh7wbiBhjlPQE5Z3Fy4sUGBXS1U5rOETcHEP8W
         4EQOZeSLZybIDeUGvGqTqY/GhLuw99SaHOLUL1/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/232] firmware: arm_sdei: fix double-lock on hibernate with shared events
Date:   Thu, 16 Apr 2020 15:22:02 +0200
Message-Id: <20200416131319.672863005@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 6ded0b61cf638bf9f8efe60ab8ba23db60ea9763 ]

SDEI has private events that must be registered on each CPU. When
CPUs come and go they must re-register and re-enable their private
events. Each event has flags to indicate whether this should happen
to protect against an event being registered on a CPU coming online,
while all the others are unregistering the event.

These flags are protected by the sdei_list_lock spinlock, because
the cpuhp callbacks can't take the mutex.

Hibernate needs to unregister all events, but keep the in-memory
re-register and re-enable as they are. sdei_unregister_shared()
takes the spinlock to walk the list, then calls _sdei_event_unregister()
on each shared event. _sdei_event_unregister() tries to take the
same spinlock to update re-register and re-enable. This doesn't go
so well.

Push the re-register and re-enable updates out to their callers.
sdei_unregister_shared() doesn't want these values updated, so
doesn't need to do anything.

This also fixes shared events getting lost over hibernate as this
path made them look unregistered.

Fixes: da351827240e ("firmware: arm_sdei: Add support for CPU and system power states")
Reported-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 9cd70d1a56221..eb2df89d4924f 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -491,11 +491,6 @@ static int _sdei_event_unregister(struct sdei_event *event)
 {
 	lockdep_assert_held(&sdei_events_lock);
 
-	spin_lock(&sdei_list_lock);
-	event->reregister = false;
-	event->reenable = false;
-	spin_unlock(&sdei_list_lock);
-
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_unregister(event->event_num);
 
@@ -518,6 +513,11 @@ int sdei_event_unregister(u32 event_num)
 			break;
 		}
 
+		spin_lock(&sdei_list_lock);
+		event->reregister = false;
+		event->reenable = false;
+		spin_unlock(&sdei_list_lock);
+
 		err = _sdei_event_unregister(event);
 		if (err)
 			break;
@@ -585,26 +585,15 @@ static int _sdei_event_register(struct sdei_event *event)
 
 	lockdep_assert_held(&sdei_events_lock);
 
-	spin_lock(&sdei_list_lock);
-	event->reregister = true;
-	spin_unlock(&sdei_list_lock);
-
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_register(event->event_num,
 					       sdei_entry_point,
 					       event->registered,
 					       SDEI_EVENT_REGISTER_RM_ANY, 0);
 
-
 	err = sdei_do_cross_call(_local_event_register, event);
-	if (err) {
-		spin_lock(&sdei_list_lock);
-		event->reregister = false;
-		event->reenable = false;
-		spin_unlock(&sdei_list_lock);
-
+	if (err)
 		sdei_do_cross_call(_local_event_unregister, event);
-	}
 
 	return err;
 }
@@ -632,8 +621,17 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
 			break;
 		}
 
+		spin_lock(&sdei_list_lock);
+		event->reregister = true;
+		spin_unlock(&sdei_list_lock);
+
 		err = _sdei_event_register(event);
 		if (err) {
+			spin_lock(&sdei_list_lock);
+			event->reregister = false;
+			event->reenable = false;
+			spin_unlock(&sdei_list_lock);
+
 			sdei_event_destroy(event);
 			pr_warn("Failed to register event %u: %d\n", event_num,
 				err);
-- 
2.20.1



