Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78167498EFC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357318AbiAXTtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354598AbiAXTgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25F0C06137F;
        Mon, 24 Jan 2022 11:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FD43B8121C;
        Mon, 24 Jan 2022 19:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B88C340E5;
        Mon, 24 Jan 2022 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051817;
        bh=roOoVmBLp8DGLovcxZsX04NbD9zAfwHu/iuBHS6vXH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTopkVwaT+3kDZSKLWF10HJuMaaKYn029nvUP4UgMfaFS9Yxn4oFpIOmVrdxp9aSO
         AF/6BAjrcg9TsS+rRd5x6HiFW8+7Pnt5p5tRPvkO8NUD5uRfB5tMVGtDzMFggN62Xo
         t+3uBaJl6KgAMhYbS+4HVVrmHu1o+0Z4NOod4nms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/239] pcmcia: fix setting of kthread task states
Date:   Mon, 24 Jan 2022 19:42:14 +0100
Message-Id: <20220124183946.158719236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

[ Upstream commit fbb3485f1f931102d8ba606f1c28123f5b48afa3 ]

We need to set TASK_INTERRUPTIBLE before calling kthread_should_stop().
Otherwise, kthread_stop() might see that the pccardd thread is still
in TASK_RUNNING state and fail to wake it up.

Additionally, we only need to set the state back to TASK_RUNNING if
kthread_should_stop() breaks the loop.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: d3046ba809ce ("pcmcia: fix a boot time warning in pcmcia cs code")
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/cs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 8c8caec3a72cc..182e5ef4ab83d 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -669,18 +669,16 @@ static int pccardd(void *__skt)
 		if (events || sysfs_events)
 			continue;
 
+		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		schedule();
 
-		/* make sure we are running */
-		__set_current_state(TASK_RUNNING);
-
 		try_to_freeze();
 	}
+	/* make sure we are running before we exit */
+	__set_current_state(TASK_RUNNING);
 
 	/* shut down socket, if a device is still present */
 	if (skt->state & SOCKET_PRESENT) {
-- 
2.34.1



