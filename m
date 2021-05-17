Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE623832EC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbhEQOwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241249AbhEQOua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5A561464;
        Mon, 17 May 2021 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261390;
        bh=GTG8bbh8V6Po43xFaE8EyHLkS4c8grvCURbwrR39XoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ct3oLnkbnKFRie6KGjlVF3zeB12Qv68WPNfFXuQGjedSOZO9MpfyeZmEp3INNNAuP
         Sez4zU6Kz/TnTSL1vJuAAcD+WHEwMMoliYZvM/4gP89qIE5Q5oScTh1GoQtW1PIEGM
         TwnlQqb6ZeynocvRw3lLKHv3JOIv1f+fz7plNCAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/289] fs: dlm: flush swork on shutdown
Date:   Mon, 17 May 2021 15:59:00 +0200
Message-Id: <20210517140305.689779548@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit eec054b5a7cfe6d1f1598a323b05771ee99857b5 ]

This patch fixes the flushing of send work before shutdown. The function
cancel_work_sync() is not the right workqueue functionality to use here
as it would cancel the work if the work queues itself. In cases of
EAGAIN in send() for dlm message we need to be sure that everything is
send out before. The function flush_work() will ensure that every send
work is be done inclusive in EAGAIN cases.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 79f56f16bc2c..44e2716ac158 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -612,10 +612,7 @@ static void shutdown_connection(struct connection *con)
 {
 	int ret;
 
-	if (cancel_work_sync(&con->swork)) {
-		log_print("canceled swork for node %d", con->nodeid);
-		clear_bit(CF_WRITE_PENDING, &con->flags);
-	}
+	flush_work(&con->swork);
 
 	mutex_lock(&con->sock_mutex);
 	/* nothing to shutdown */
-- 
2.30.2



