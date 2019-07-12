Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5466CA7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfGLMVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfGLMV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E91216E3;
        Fri, 12 Jul 2019 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934088;
        bh=RGqaMnUl8fu5VGTAT/EWM2D/EJZuaOJplXwUWrI4ww0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4kxAfcammzUKPyjruQB+SosiMiJ6mdLTTiWrc3n9/EiuU0Y6R8HP+bARvhwrDd/1
         QfNn7IZ4+V+HtIDKOX+cWSvTmW1gYOO5L4iJMOSTCRb/tYhKCNhJnI8Q4BveU42wpo
         p4X8gyYgM/4kFvCv0H3r5TCrtE3MHdTDVfQqLM/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/91] bpf, devmap: Add missing RCU read lock on flush
Date:   Fri, 12 Jul 2019 14:18:43 +0200
Message-Id: <20190712121623.602025258@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 86723c8640633bee4b4588d3c7784ee7a0032f65 ]

.ndo_xdp_xmit() assumes it is called under RCU. For example virtio_net
uses RCU to detect it has setup the resources for tx. The assumption
accidentally broke when introducing bulk queue in devmap.

Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 357d456d57b9..fc500ca464d0 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -282,6 +282,7 @@ void __dev_map_flush(struct bpf_map *map)
 	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
 	u32 bit;
 
+	rcu_read_lock();
 	for_each_set_bit(bit, bitmap, map->max_entries) {
 		struct bpf_dtab_netdev *dev = READ_ONCE(dtab->netdev_map[bit]);
 		struct xdp_bulk_queue *bq;
@@ -297,6 +298,7 @@ void __dev_map_flush(struct bpf_map *map)
 
 		__clear_bit(bit, bitmap);
 	}
+	rcu_read_unlock();
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -389,6 +391,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 
 		int cpu;
 
+		rcu_read_lock();
 		for_each_online_cpu(cpu) {
 			bitmap = per_cpu_ptr(dev->dtab->flush_needed, cpu);
 			__clear_bit(dev->bit, bitmap);
@@ -396,6 +399,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 			bq = per_cpu_ptr(dev->bulkq, cpu);
 			bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
 		}
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1



