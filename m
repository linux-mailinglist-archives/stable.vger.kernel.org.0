Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6886A1E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404950AbfHHTMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405322AbfHHTKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D494B2189D;
        Thu,  8 Aug 2019 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291434;
        bh=kQkCSML3p6gGTaYXMo3ygZUJW6sPyqX045IrhYREfh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFIo9rKDLxTKhwhjh94Ip7Hk67huHiHiF/3yQg5ouR/6M1gMfhaNVKovbflbqBmZF
         4qp6mcPuwZf/Kmwn2goKM/WXOFvYnicrF9DE5sdzF4IQT13avh2BpwlT5oV2kz+dQF
         6DYFFI7AL+1ShDgKyCipmemBFxRj3+eZe9TBN4Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 13/33] ife: error out when nla attributes are empty
Date:   Thu,  8 Aug 2019 21:05:20 +0200
Message-Id: <20190808190454.218276770@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c8ec4632c6ac9cda0e8c3d51aa41eeab66585bd5 ]

act_ife at least requires TCA_IFE_PARMS, so we have to bail out
when there is no attribute passed in.

Reported-by: syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com
Fixes: ef6980b6becb ("introduce IFE action")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -459,6 +459,9 @@ static int tcf_ife_init(struct net *net,
 	int ret = 0;
 	int err;
 
+	if (!nla)
+		return -EINVAL;
+
 	err = nla_parse_nested(tb, TCA_IFE_MAX, nla, ife_policy, NULL);
 	if (err < 0)
 		return err;


