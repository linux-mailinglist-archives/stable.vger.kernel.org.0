Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F83329BFD3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816429AbgJ0RGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793527AbgJ0PGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42F122453;
        Tue, 27 Oct 2020 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811205;
        bh=ChXSg92q0KDDStYfIpuZUm65CrxV/X8/S/XpJifQi6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWQewhQWIHBkv/GVPTefnO5O7wsWFlKLEaMjEaK6x6hS65lK24B6WZNJwbUDgozNF
         +f0Y1UvYbXRk01h5eoqQ3oEnbctW2j96e9K9mCBzn19vf4mlJ3cJHyRwsfnZX0JfBk
         zHR+WwBTlinu+zCCI7Kh4QCz91VE5bQjGeIBHRa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 409/633] um: time-travel: Fix IRQ handling in time_travel_handle_message()
Date:   Tue, 27 Oct 2020 14:52:32 +0100
Message-Id: <20201027135541.910190231@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ebef8ea2ba967026192a26f4529890893919bc57 ]

As the comment here indicates, we need to do the polling in the
idle loop without blocking interrupts, since interrupts can be
vhost-user messages that we must process even while in our idle
loop.

I don't know why I explained one thing and implemented another,
but we have indeed observed random hangs due to this, depending
on the timing of the messages.

Fixes: 88ce64249233 ("um: Implement time-travel=ext")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/time.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 25eaa6a0c6583..c07436e89e599 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -70,13 +70,17 @@ static void time_travel_handle_message(struct um_timetravel_msg *msg,
 	 * read of the message and write of the ACK.
 	 */
 	if (mode != TTMH_READ) {
+		bool disabled = irqs_disabled();
+
+		BUG_ON(mode == TTMH_IDLE && !disabled);
+
+		if (disabled)
+			local_irq_enable();
 		while (os_poll(1, &time_travel_ext_fd) != 0) {
-			if (mode == TTMH_IDLE) {
-				BUG_ON(!irqs_disabled());
-				local_irq_enable();
-				local_irq_disable();
-			}
+			/* nothing */
 		}
+		if (disabled)
+			local_irq_disable();
 	}
 
 	ret = os_read_file(time_travel_ext_fd, msg, sizeof(*msg));
-- 
2.25.1



