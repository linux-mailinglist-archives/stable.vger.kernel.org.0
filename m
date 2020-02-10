Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA2157699
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgBJMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbgBJMl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677402080C;
        Mon, 10 Feb 2020 12:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338515;
        bh=Lu+RMBiy9nR3yqs0q6WNjeJ7PwjCRs6U+ml8VsoublY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrBfNGS9XAMaWwKgSISqfGoSqjBdXepZcWuakSlAnCRBghT6GnU9WCwge90bdgCuG
         k4vVrEwie5bscRWfBDiAlaDchvqDS90SAj7k7kvHVLRFDgYIZOJpWRbMcp1dlYrjPj
         IpV+s/A4NDXOq7LSHneRflzAw4CxFtXX1SFZDOxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 323/367] net_sched: fix a resource leak in tcindex_set_parms()
Date:   Mon, 10 Feb 2020 04:33:56 -0800
Message-Id: <20200210122452.808742927@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 52b5ae501c045010aeeb1d5ac0373ff161a88291 ]

Jakub noticed there is a potential resource leak in
tcindex_set_parms(): when tcindex_filter_result_init() fails
and it jumps to 'errout1' which doesn't release the memory
and resources allocated by tcindex_alloc_perfect_hash().

We should just jump to 'errout_alloc' which calls
tcindex_free_perfect_hash().

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_tcindex.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -365,7 +365,7 @@ tcindex_set_parms(struct net *net, struc
 
 	err = tcindex_filter_result_init(&new_filter_result, net);
 	if (err < 0)
-		goto errout1;
+		goto errout_alloc;
 	if (old_r)
 		cr = r->res;
 
@@ -484,7 +484,6 @@ errout_alloc:
 		tcindex_free_perfect_hash(cp);
 	else if (balloc == 2)
 		kfree(cp->h);
-errout1:
 	tcf_exts_destroy(&new_filter_result.exts);
 errout:
 	kfree(cp);


