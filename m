Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB153DD860
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhHBNvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234998AbhHBNux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687C16112D;
        Mon,  2 Aug 2021 13:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912236;
        bh=rnZkppms87SENbqQ0YwaRx8DDxeQ3FjXlqmpA+j/hmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8aY7dTu1r3d7NDYZMbdGS9bq2PJtQyEORHLKxIBbLqp5lbgPMdFvAxR/sFBuacoO
         S64/rQoYFoRKCz3G6dRIZOPuTABlYwyzr6kRQVDTO6rIq707nwH9D4AIqt0+Xz7aXF
         +x02auAklaEjlmp7uA3F6bQzbcicOcOWRjJ6Ak1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
Subject: [PATCH 5.4 01/40] net_sched: check error pointer in tcf_dump_walker()
Date:   Mon,  2 Aug 2021 15:44:41 +0200
Message-Id: <20210802134335.454274504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 580e4273d7a883ececfefa692c1f96bdbacb99b5 ]

Although we take RTNL on dump path, it is possible to
skip RTNL on insertion path. So the following race condition
is possible:

rtnl_lock()		// no rtnl lock
			mutex_lock(&idrinfo->lock);
			// insert ERR_PTR(-EBUSY)
			mutex_unlock(&idrinfo->lock);
tc_dump_action()
rtnl_unlock()

So we have to skip those temporary -EBUSY entries on dump path
too.

Reported-and-tested-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -231,6 +231,8 @@ static int tcf_dump_walker(struct tcf_id
 		index++;
 		if (index < s_i)
 			continue;
+		if (IS_ERR(p))
+			continue;
 
 		if (jiffy_since &&
 		    time_after(jiffy_since,


