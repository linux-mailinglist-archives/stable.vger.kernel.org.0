Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC127C7B2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgI2Lz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730886AbgI2Loh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17EB3206E5;
        Tue, 29 Sep 2020 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379876;
        bh=VCB3jIeTeM9vuV/mmbVp0GqfvmLKunj3FWHwKOrmC2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2cjX0QDdn4gwYQsjySAMILoevn3QjrktChCr4ONXhJDUSBIos/pgqhML8fIUOP7X
         NXtSzZfnN+grgwQVOiCDr0BlSGwmBwC9uQ+zlCkQDqntRIFRAZParjRGn3khNlx+MF
         Jhpe5LpevcFZzokOagdmEBcOBgEdpejl6BTBWkjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 357/388] bpf: Fix a rcu warning for bpffs map pretty-print
Date:   Tue, 29 Sep 2020 13:01:28 +0200
Message-Id: <20200929110027.746939753@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit ce880cb825fcc22d4e39046a6c3a3a7f6603883d ]

Running selftest
  ./btf_btf -p
the kernel had the following warning:
  [   51.528185] WARNING: CPU: 3 PID: 1756 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x2eb/0x300
  [   51.529217] Modules linked in:
  [   51.529583] CPU: 3 PID: 1756 Comm: test_btf Not tainted 5.9.0-rc1+ #878
  [   51.530346] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.el7.centos 04/01/2014
  [   51.531410] RIP: 0010:htab_map_get_next_key+0x2eb/0x300
  ...
  [   51.542826] Call Trace:
  [   51.543119]  map_seq_next+0x53/0x80
  [   51.543528]  seq_read+0x263/0x400
  [   51.543932]  vfs_read+0xad/0x1c0
  [   51.544311]  ksys_read+0x5f/0xe0
  [   51.544689]  do_syscall_64+0x33/0x40
  [   51.545116]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The related source code in kernel/bpf/hashtab.c:
  709 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
  710 {
  711         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
  712         struct hlist_nulls_head *head;
  713         struct htab_elem *l, *next_l;
  714         u32 hash, key_size;
  715         int i = 0;
  716
  717         WARN_ON_ONCE(!rcu_read_lock_held());

In kernel/bpf/inode.c, bpffs map pretty print calls map->ops->map_get_next_key()
without holding a rcu_read_lock(), hence causing the above warning.
To fix the issue, just surrounding map->ops->map_get_next_key() with rcu read lock.

Fixes: a26ca7c982cb ("bpf: btf: Add pretty print support to the basic arraymap")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20200916004401.146277-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 218c09ff6a273..375d93eb71c71 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -205,10 +205,12 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	else
 		prev_key = key;
 
+	rcu_read_lock();
 	if (map->ops->map_get_next_key(map, prev_key, key)) {
 		map_iter(m)->done = true;
-		return NULL;
+		key = NULL;
 	}
+	rcu_read_unlock();
 	return key;
 }
 
-- 
2.25.1



