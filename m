Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6DC498A30
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344663AbiAXTBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345268AbiAXS77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:59:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74E4C0619D0;
        Mon, 24 Jan 2022 10:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4663B61416;
        Mon, 24 Jan 2022 18:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A37EC340E5;
        Mon, 24 Jan 2022 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050599;
        bh=tnFxo+X8MhMhJfzopAdktpTd6isKsEkPQG4eerdzgBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvlHXLzPptJjz0N4M+7QM3sYEwMqNMIk+u0mmXW8zbIIYvuQKX55cr4rAIprTxxrQ
         xosC6oqE0jQfvp/cyNGADw7HSx4D6gfZ6eRLi6qI4fiSlQLbLyGmiKHl+iABYqlirh
         CJw3NodlSxa04THOz3ahfpptDT/qj+vbtQN6p17Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/157] pcmcia: fix setting of kthread task states
Date:   Mon, 24 Jan 2022 19:42:24 +0100
Message-Id: <20220124183934.499963137@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index c3b615c94b4bf..a92cbc952b70b 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -665,18 +665,16 @@ static int pccardd(void *__skt)
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



