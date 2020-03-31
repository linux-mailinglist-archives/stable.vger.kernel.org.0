Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF37D199111
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgCaJQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731993AbgCaJQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2CB520787;
        Tue, 31 Mar 2020 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646212;
        bh=L+9Vty2YS+wgu/7RjYEPxT1XFKRm43WtauDC7+v9CGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xczGZoLP29hhJ10zjlNsRJFGthTuQ6XQ5SAgGwrrItYT/YUxg/otM/RdtmD5VWNEj
         oSP77Q2XBtMj2JBp3SEOxjtVEuCxgm/G6lqH49BxRyaNetAD/mtj+rqdjBZYslwUlf
         j8EtQE995n8P4NOw8AY/woDQMxpR40p/ElpVo548=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 118/155] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Date:   Tue, 31 Mar 2020 10:59:18 +0200
Message-Id: <20200331085431.674272329@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 4c59406ed00379c8663f8663d82b2537467ce9d7 upstream.

After xfrm_add_policy add a policy, its ref is 2, then

                             xfrm_policy_timer
                               read_lock
                               xp->walk.dead is 0
                               ....
                               mod_timer()
xfrm_policy_kill
  policy->walk.dead = 1
  ....
  del_timer(&policy->timer)
    xfrm_pol_put //ref is 1
  xfrm_pol_put  //ref is 0
    xfrm_policy_destroy
      call_rcu
                                 xfrm_pol_hold //ref is 1
                               read_unlock
                               xfrm_pol_put //ref is 0
                                 xfrm_policy_destroy
                                  call_rcu

xfrm_policy_destroy is called twice, which may leads to
double free.

Call Trace:
RIP: 0010:refcount_warn_saturate+0x161/0x210
...
 xfrm_policy_timer+0x522/0x600
 call_timer_fn+0x1b3/0x5e0
 ? __xfrm_decode_session+0x2990/0x2990
 ? msleep+0xb0/0xb0
 ? _raw_spin_unlock_irq+0x24/0x40
 ? __xfrm_decode_session+0x2990/0x2990
 ? __xfrm_decode_session+0x2990/0x2990
 run_timer_softirq+0x5c5/0x10e0

Fix this by use write_lock_bh in xfrm_policy_kill.

Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing policy->walk.dead")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Timo Teräs <timo.teras@iki.fi>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -431,7 +431,9 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
 
 static void xfrm_policy_kill(struct xfrm_policy *policy)
 {
+	write_lock_bh(&policy->lock);
 	policy->walk.dead = 1;
+	write_unlock_bh(&policy->lock);
 
 	atomic_inc(&policy->genid);
 


