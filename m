Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACD3472578
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhLMJny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35926 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhLMJlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99390CE0E7A;
        Mon, 13 Dec 2021 09:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9B9C00446;
        Mon, 13 Dec 2021 09:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388505;
        bh=+bc2O6rAQ2NGvwrQjXh+qYFPAwjKCd+vTMbQr8SdOzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2lGGL4/8uICaTUgrKNKCjKhRKG6mU9n5xs3Ib7BHpyU/s/HEUw4eOR6cI58theAU
         KY8DRbC1QWh1FAthgvLLZr5WqHy1efDwxkwQ4/5kvPLOx88hm0u0QKOIFlK+6nyo+C
         BGXBEdqCrlk3/FrMvFPFAS4P/9ij2CIBdCQEpIFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 74/74] net: sched: make function qdisc_free_cb() static
Date:   Mon, 13 Dec 2021 10:30:45 +0100
Message-Id: <20211213092933.286039792@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 5362700c942b2cc4bab328361545a6d6fe649534 upstream.

Fixes the following sparse warning:

net/sched/sch_generic.c:944:6: warning:
 symbol 'qdisc_free_cb' was not declared. Should it be static?

Fixes: 3a7d0d07a386 ("net: sched: extend Qdisc with rcu")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -958,7 +958,7 @@ void qdisc_free(struct Qdisc *qdisc)
 	kfree((char *) qdisc - qdisc->padded);
 }
 
-void qdisc_free_cb(struct rcu_head *head)
+static void qdisc_free_cb(struct rcu_head *head)
 {
 	struct Qdisc *q = container_of(head, struct Qdisc, rcu);
 


