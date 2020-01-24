Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF895148201
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391436AbgAXLYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391434AbgAXLYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE66E20704;
        Fri, 24 Jan 2020 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865072;
        bh=j6/Kf8G6Uh7G1tRSycKz/+BZBGadfpZ/ZrQEiojbM+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5dsND9/FgdzLT6Sc6rgMTgmKBkt2OVUIke0dgUC8Pu9zewIhO4j+sLhhfZrfGi/t
         t0ogfXZCsIFMKwNeswI8kXr6gBAAwGnDI5D/DsPv1ukjOYj987DufVr97z5jzCLZzt
         h+UnLuat9L8n0WmMxwqxZdiDWjvD/zxn9ww4bkHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Protopopov <a.s.protopopov@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 432/639] bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup
Date:   Fri, 24 Jan 2020 10:30:02 +0100
Message-Id: <20200124093141.159167686@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 56f0f84e69c7a7f229dfa524b13b0ceb6ce9b09e ]

The bpf_ipv6_fib_lookup function should return BPF_FIB_LKUP_RET_FWD_DISABLED
when forwarding is disabled for the input device.  However instead of checking
if forwarding is enabled on the input device, it checked the global
net->ipv6.devconf_all->forwarding flag.  Change it to behave as expected.

Fixes: 87f5fc7e48dd ("bpf: Provide helper to do forwarding lookups in kernel FIB table")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 91b9502619757..9daf1a4118b51 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4367,7 +4367,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		return -ENODEV;
 
 	idev = __in6_dev_get_safely(dev);
-	if (unlikely(!idev || !net->ipv6.devconf_all->forwarding))
+	if (unlikely(!idev || !idev->cnf.forwarding))
 		return BPF_FIB_LKUP_RET_FWD_DISABLED;
 
 	if (flags & BPF_FIB_LOOKUP_OUTPUT) {
-- 
2.20.1



