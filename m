Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8E127CB33
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732682AbgI2MZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbgI2Ldc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06E623BC7;
        Tue, 29 Sep 2020 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378833;
        bh=VE3fSo3aAsqJCVY65T3BpwRXkibKi5NDJeqN25lw3VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkTKS9AZNvxsFi28zEgRJjQMNmpvb0w4lUhhcIg+hf/TUZwdWnu2iHBNbOLIZnCTP
         oc+NP8dkAyrhFFklpLZPJ5Z0QATxjyRL3u++fk6DPZJja3gNILwncgb5TKiijhw5B5
         m7y0RDS8V+Stq5kn5TQJH8vzypLhsxpqYM2+NPEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gengming Liu <l.dmxcsnsbh@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/245] atm: fix a memory leak of vcc->user_back
Date:   Tue, 29 Sep 2020 13:00:07 +0200
Message-Id: <20200929105954.576854338@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 8d9f73c0ad2f20e9fed5380de0a3097825859d03 ]

In lec_arp_clear_vccs() only entry->vcc is freed, but vcc
could be installed on entry->recv_vcc too in lec_vcc_added().

This fixes the following memory leak:

unreferenced object 0xffff8880d9266b90 (size 16):
  comm "atm2", pid 425, jiffies 4294907980 (age 23.488s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 6b 6b 6b a5  ............kkk.
  backtrace:
    [<(____ptrval____)>] kmem_cache_alloc_trace+0x10e/0x151
    [<(____ptrval____)>] lane_ioctl+0x4b3/0x569
    [<(____ptrval____)>] do_vcc_ioctl+0x1ea/0x236
    [<(____ptrval____)>] svc_ioctl+0x17d/0x198
    [<(____ptrval____)>] sock_do_ioctl+0x47/0x12f
    [<(____ptrval____)>] sock_ioctl+0x2f9/0x322
    [<(____ptrval____)>] vfs_ioctl+0x1e/0x2b
    [<(____ptrval____)>] ksys_ioctl+0x61/0x80
    [<(____ptrval____)>] __x64_sys_ioctl+0x16/0x19
    [<(____ptrval____)>] do_syscall_64+0x57/0x65
    [<(____ptrval____)>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Cc: Gengming Liu <l.dmxcsnsbh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ad4f829193f05..5a6186b809874 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1270,6 +1270,12 @@ static void lec_arp_clear_vccs(struct lec_arp_table *entry)
 		entry->vcc = NULL;
 	}
 	if (entry->recv_vcc) {
+		struct atm_vcc *vcc = entry->recv_vcc;
+		struct lec_vcc_priv *vpriv = LEC_VCC_PRIV(vcc);
+
+		kfree(vpriv);
+		vcc->user_back = NULL;
+
 		entry->recv_vcc->push = entry->old_recv_push;
 		vcc_release_async(entry->recv_vcc, -EPIPE);
 		entry->recv_vcc = NULL;
-- 
2.25.1



