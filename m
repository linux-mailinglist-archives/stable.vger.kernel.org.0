Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA6B14BBFD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgA1OuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgA1N7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:59:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3132173E;
        Tue, 28 Jan 2020 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219972;
        bh=g98h9zgHGfmJG7qp7shi05vz6GMzSl3GulPJVilvKv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U69OnotkKaUaRp8rjRvDEU4Mk8MpQrxZXKcdfrD3hb0poUoGjXVrpbhcPL1TtvHKG
         I9O60+LhanuSDh1NVgbvAs6p8812Xez5naKrzbyI1WZxQffp8i+C7nqyJl/dvu0Pat
         MrX0IoYfV/8rTL5+JSQnkttMhIwiivnsGF7spOLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com
Subject: [PATCH 4.14 08/46] net_sched: fix datalen for ematch
Date:   Tue, 28 Jan 2020 14:57:42 +0100
Message-Id: <20200128135751.237908634@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 61678d28d4a45ef376f5d02a839cc37509ae9281 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/ematch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -267,12 +267,12 @@ static int tcf_em_validate(struct tcf_pr
 				}
 				em->data = (unsigned long) v;
 			}
+			em->datalen = data_len;
 		}
 	}
 
 	em->matchid = em_hdr->matchid;
 	em->flags = em_hdr->flags;
-	em->datalen = data_len;
 	em->net = net;
 
 	err = 0;


