Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9B38A7A0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbhETKlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234813AbhETKiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1032E61C6C;
        Thu, 20 May 2021 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504488;
        bh=dPx9z9fKQJ6K4YmTJcUomZVJhoMxNaHdCoO5HYefZCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eULwJoAg91lKSGSNCcbArjNBrhFaV573E6OqFVwCbmRVBbTxtPjSKxBMQuRFbEEOi
         3zw4uIFuuaBzCyO5x+nf2j0m6N28AW9DqDMDd7T6M0krbiKdm2j4es91ygIKvobWG2
         gz9Wdc20ZIh/Vx6qjH74oKRLuXGAOO8BYP+j5tlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
Subject: [PATCH 4.14 241/323] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Thu, 20 May 2021 11:22:13 +0200
Message-Id: <20210520092128.439367429@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index b5a7d04066ec..460401349255 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -445,6 +445,8 @@ struct l2cap_chan *l2cap_chan_create(void)
 	if (!chan)
 		return NULL;
 
+	skb_queue_head_init(&chan->tx_q);
+	skb_queue_head_init(&chan->srej_q);
 	mutex_init(&chan->lock);
 
 	/* Set default lock nesting level */
-- 
2.30.2



