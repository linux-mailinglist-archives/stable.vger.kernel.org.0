Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92A383250
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhEQOrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241078AbhEQOmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0680461953;
        Mon, 17 May 2021 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261172;
        bh=kH82i5J5JigCj0Eidb3S+KlFSpJ1WLg6mTvHIXtIcJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKu2GFZTxIRgYV7NnEdv3FAfHqBFjxnv0wx+r50xLvomhGPy50APov1JwxOeOQLnU
         iMzhnLWL0h0CM42p85cxtvlquvviwlxK6Fnp1LjYTJXxJC4MxWB5gAERjNZt9pLfB9
         007NClWH4q6tZRWf3twhQkcv5qnI2b4jjWj56C/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
Subject: [PATCH 5.4 017/141] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Mon, 17 May 2021 16:01:09 +0200
Message-Id: <20210517140243.343007756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit be8597239379f0f53c9710dd6ab551bbf535bec6 ]

syzbot is hitting "INFO: trying to register non-static key." message [1],
for "struct l2cap_chan"->tx_q.lock spinlock is not yet initialized when
l2cap_chan_del() is called due to e.g. timeout.

Since "struct l2cap_chan"->lock mutex is initialized at l2cap_chan_create()
immediately after "struct l2cap_chan" is allocated using kzalloc(), let's
as well initialize "struct l2cap_chan"->{tx_q,srej_q}.lock spinlocks there.

[1] https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842

Reported-and-tested-by: syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index f5039700d927..959a16b13303 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -450,6 +450,8 @@ struct l2cap_chan *l2cap_chan_create(void)
 	if (!chan)
 		return NULL;
 
+	skb_queue_head_init(&chan->tx_q);
+	skb_queue_head_init(&chan->srej_q);
 	mutex_init(&chan->lock);
 
 	/* Set default lock nesting level */
-- 
2.30.2



