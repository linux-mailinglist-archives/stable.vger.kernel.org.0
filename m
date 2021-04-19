Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E570E36442B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbhDSNZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241811AbhDSNYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DDA613E0;
        Mon, 19 Apr 2021 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838369;
        bh=3Zz1KqwH7N0XH8TsspPrkxrJdFWYCC7RQ6USo//FgoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjUK0rP6UAtau7DHqBryDjK3u2evdKzfxNHoUOtLDiyLX9HyW9LU/ixrJuw4C5yaJ
         o1xaqvDc1FE2Jpzq8R2z6+41kf2B9X/XEQBTbi8PsONma+TckGucPoAc/8XtKsHNFJ
         svekCtMHsxZ64fUoCTmC+Y8hxX2zQ9PiDtsemE1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/73] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 19 Apr 2021 15:06:27 +0200
Message-Id: <20210419130525.004088820@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]

In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
is freed and later under spinlock, causing potential use-after-free.
Set the free pointer to NULL to avoid undefined behavior.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 1 +
 net/rds/send.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 92b6b22884d4..ed1d2255ce5a 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 68e2bdb08fd0..aa3bc081773f 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2



