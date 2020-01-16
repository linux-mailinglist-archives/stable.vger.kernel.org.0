Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE313F83F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgAPTRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbgAPQze (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 725B820730;
        Thu, 16 Jan 2020 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193734;
        bh=IhmIzIYtYHMkpRqwuhLe6N2owPqBPXz9JzK9F0v1bPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg26bi+I+yUldOKTgvmjn7SkvKF99xjj9G91zrUYjAiiv5fgQ9A+SSWIry66G6qrf
         FkOjPpDD1CnsnfEihI9ll1HJ09Wv/JeQnsPQyt1+DKYsrqhdkteKWD8wI6uN1Ij3bo
         5aAV0IcrrGgAC61pt6/ASe28qJ48YXbJtCcteg9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 026/671] mei: replace POLL* with EPOLL* for write queues.
Date:   Thu, 16 Jan 2020 11:44:17 -0500
Message-Id: <20200116165502.8838-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

[ Upstream commit 03b2cbb6ea3c73e08fcf72d9ef8e286c4dcbd1fe ]

Looks like during merging the bulk POLL* -> EPOLL* replacement
missed the patch
'commit af336cabe083 ("mei: limit the number of queued writes")'

Fix sparse warning:
drivers/misc/mei/main.c:602:13: warning: restricted __poll_t degrades to integer
drivers/misc/mei/main.c:605:30: warning: invalid assignment: |=
drivers/misc/mei/main.c:605:30:    left side has type restricted __poll_t
drivers/misc/mei/main.c:605:30:    right side has type int

Fixes: af336cabe083 ("mei: limit the number of queued writes")
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 4d77a6ae183a..87281b3695e6 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -599,10 +599,10 @@ static __poll_t mei_poll(struct file *file, poll_table *wait)
 			mei_cl_read_start(cl, mei_cl_mtu(cl), file);
 	}
 
-	if (req_events & (POLLOUT | POLLWRNORM)) {
+	if (req_events & (EPOLLOUT | EPOLLWRNORM)) {
 		poll_wait(file, &cl->tx_wait, wait);
 		if (cl->tx_cb_queued < dev->tx_queue_limit)
-			mask |= POLLOUT | POLLWRNORM;
+			mask |= EPOLLOUT | EPOLLWRNORM;
 	}
 
 out:
-- 
2.20.1

