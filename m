Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1801B67F3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgDWXKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50306 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728589AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkve-0004mS-7f; Fri, 24 Apr 2020 00:06:46 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvZ-00E6z2-1M; Fri, 24 Apr 2020 00:06:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com,
        "Cong Wang" <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Apr 2020 00:07:14 +0100
Message-ID: <lsq.1587683028.609597722@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 207/245] net_sched: fix datalen for ematch
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 61678d28d4a45ef376f5d02a839cc37509ae9281 upstream.

syzbot reported an out-of-bound access in em_nbyte. As initially
analyzed by Eric, this is because em_nbyte sets its own em->datalen
in em_nbyte_change() other than the one specified by user, but this
value gets overwritten later by its caller tcf_em_validate().
We should leave em->datalen untouched to respect their choices.

I audit all the in-tree ematch users, all of those implement
->change() set em->datalen, so we can just avoid setting it twice
in this case.

Reported-and-tested-by: syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com
Reported-by: syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/ematch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -266,12 +266,12 @@ static int tcf_em_validate(struct tcf_pr
 				}
 				em->data = (unsigned long) v;
 			}
+			em->datalen = data_len;
 		}
 	}
 
 	em->matchid = em_hdr->matchid;
 	em->flags = em_hdr->flags;
-	em->datalen = data_len;
 
 	err = 0;
 errout:

