Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E88929C35D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759088AbgJ0O1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759083AbgJ0O1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6F3206DC;
        Tue, 27 Oct 2020 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808859;
        bh=JC0Y0QPLd4dv2Chd2uSnFM6k2pNn9+xYOM4MwLSX+Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PzfczwP+xlc3oojFSBnPoM8UCugTJpEuVBlVo+4Kao0aw7tSI71T+InHIZCie4Je
         8rukqMX+SKzrGG0ZC8tu0xHSIaAm8wE5rzxqo5ZTanPeTfAF65lGBDDzTpOV5Gh2g9
         +myNLqPhptpW8tDTNPTJsDolyngwCmS+kZWRAgPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com,
        Julian Anastasov <ja@ssi.bg>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/264] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
Date:   Tue, 27 Oct 2020 14:55:10 +0100
Message-Id: <20201027135442.485586340@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit c5a8a8498eed1c164afc94f50a939c1a10abf8ad ]

do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
zero. Fix it.

Reported-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c339b5e386b78..3ad1de081e3c7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2393,6 +2393,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		/* Set timeout values for (tcp tcpfin udp) */
 		ret = ip_vs_set_timeout(ipvs, (struct ip_vs_timeout_user *)arg);
 		goto out_unlock;
+	} else if (!len) {
+		/* No more commands with len == 0 below */
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	usvc_compat = (struct ip_vs_service_user *)arg;
@@ -2469,9 +2473,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
-		break;
-	default:
-		ret = -EINVAL;
 	}
 
   out_unlock:
-- 
2.25.1



