Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051C5174CD
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfEHJPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:15:06 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:36290 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfEHJPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 05:15:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=wuyihao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TRApN24_1557306900;
Received: from ali-186590dcce93-2.local(mailfrom:wuyihao@linux.alibaba.com fp:SMTPD_---0TRApN24_1557306900)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 May 2019 17:15:00 +0800
Subject: [PATCH 2/2] NFSv4.1: Fix bug only the first CB_NOTIFY_LOCK is handled
From:   Yihao Wu <wuyihao@linux.alibaba.com>
To:     linux-nfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
References: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
 <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
Message-ID: <cdba66b5-29a3-e37b-1e0f-808c171d09c3@linux.alibaba.com>
Date:   Wed, 8 May 2019 17:15:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the first CB_NOTIFY_LOCK wakes a waiter, it can still fail to
acquire the lock. Then it might goes to sleep again. However it's removed
from the wait queue and not put back. So when the CB_NOTIFY_LOCK comes
again, it fails to wake this waiter.

Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
---
 fs/nfs/nfs4proc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f13ea09..9de2c2d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6932,6 +6932,10 @@ struct nfs4_lock_waiter {
 
 		status = -ERESTARTSYS;
 		wait_woken(&wait, TASK_INTERRUPTIBLE, NFS4_LOCK_MAXTIMEOUT);
+		if (!signalled())  {
+			finish_wait(q, &wait);
+			add_wait_queue(q, &wait);
+		}
 	}
 
 	finish_wait(q, &wait);
-- 
1.8.3.1


