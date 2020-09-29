Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD2727C8FD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgI2MGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbgI2Lhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B107623A75;
        Tue, 29 Sep 2020 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379388;
        bh=1421uzvkwaBdxLSU4zsKRga+Ar+Yd6i16Q6f6C1NZE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F67zcp2eMOwM3PZ2niGOYbi5itew/7zf9ANhbPV/mwGwFCTWnCviNOLcucC1BOly6
         ofN8jT76CJ4IAZ66ZmypJ30pIm1Tu9iemti22VGsIUjMOUtVnLp1aUXpJJaJNqYCg0
         kvNIVOIK9/y4wAWg5P4+8T/78brffUiqGYKShVLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/388] firmware: arm_sdei: Use cpus_read_lock() to avoid races with cpuhp
Date:   Tue, 29 Sep 2020 12:57:51 +0200
Message-Id: <20200929110017.253465654@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 54f529a6806c9710947a4f2cdc15d6ea54121ccd ]

SDEI has private events that need registering and enabling on each CPU.
CPUs can come and go while we are trying to do this. SDEI tries to avoid
these problems by setting the reregister flag before the register call,
so any CPUs that come online register the event too. Sticking plaster
like this doesn't work, as if the register call fails, a CPU that
subsequently comes online will register the event before reregister
is cleared.

Take cpus_read_lock() around the register and enable calls. We don't
want surprise CPUs to do the wrong thing if they race with these calls
failing.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index eb2df89d4924f..e497785cd99fe 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -412,14 +412,19 @@ int sdei_event_enable(u32 event_num)
 		return -ENOENT;
 	}
 
-	spin_lock(&sdei_list_lock);
-	event->reenable = true;
-	spin_unlock(&sdei_list_lock);
 
+	cpus_read_lock();
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_enable(event->event_num);
 	else
 		err = sdei_do_cross_call(_local_event_enable, event);
+
+	if (!err) {
+		spin_lock(&sdei_list_lock);
+		event->reenable = true;
+		spin_unlock(&sdei_list_lock);
+	}
+	cpus_read_unlock();
 	mutex_unlock(&sdei_events_lock);
 
 	return err;
@@ -621,21 +626,18 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
 			break;
 		}
 
-		spin_lock(&sdei_list_lock);
-		event->reregister = true;
-		spin_unlock(&sdei_list_lock);
-
+		cpus_read_lock();
 		err = _sdei_event_register(event);
 		if (err) {
-			spin_lock(&sdei_list_lock);
-			event->reregister = false;
-			event->reenable = false;
-			spin_unlock(&sdei_list_lock);
-
 			sdei_event_destroy(event);
 			pr_warn("Failed to register event %u: %d\n", event_num,
 				err);
+		} else {
+			spin_lock(&sdei_list_lock);
+			event->reregister = true;
+			spin_unlock(&sdei_list_lock);
 		}
+		cpus_read_unlock();
 	} while (0);
 	mutex_unlock(&sdei_events_lock);
 
-- 
2.25.1



