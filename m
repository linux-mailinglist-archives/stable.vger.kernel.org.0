Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A81441860
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhKAJqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234414AbhKAJom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B9F613B5;
        Mon,  1 Nov 2021 09:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758979;
        bh=agtaoqWLsHM3xqWPLgQ/Ek0GDJt1yWaYGKvZFLRRQXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/GjwWTVPAYhA34mrMXxUy3bBBxqXXoAru+/2G0xwKebINkGpLcPa2mdPeozS+Sdl
         8gYe9Tc9rw4W5SX/vOagUwVhUNrpK5zUAPxtCcCtYb1gX0ucE/mvjfFsyS2KYVO9Vq
         /3M2wafYP9xAJ7FwZaUpsvVJb2Hp/JoyUKgUw8yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Kuohai <xukuohai@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.14 062/125] bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()
Date:   Mon,  1 Nov 2021 10:17:15 +0100
Message-Id: <20211101082544.930255516@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

commit fda7a38714f40b635f5502ec4855602c6b33dad2 upstream.

1. The ufd in generic_map_update_batch() should be read from batch.map_fd;
2. A call to fdget() should be followed by a symmetric call to fdput().

Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211019032934.1210517-1-xukuohai@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1333,12 +1333,11 @@ int generic_map_update_batch(struct bpf_
 	void __user *values = u64_to_user_ptr(attr->batch.values);
 	void __user *keys = u64_to_user_ptr(attr->batch.keys);
 	u32 value_size, cp, max_count;
-	int ufd = attr->map_fd;
+	int ufd = attr->batch.map_fd;
 	void *key, *value;
 	struct fd f;
 	int err = 0;
 
-	f = fdget(ufd);
 	if (attr->batch.elem_flags & ~BPF_F_LOCK)
 		return -EINVAL;
 
@@ -1363,6 +1362,7 @@ int generic_map_update_batch(struct bpf_
 		return -ENOMEM;
 	}
 
+	f = fdget(ufd); /* bpf_map_do_batch() guarantees ufd is valid */
 	for (cp = 0; cp < max_count; cp++) {
 		err = -EFAULT;
 		if (copy_from_user(key, keys + cp * map->key_size,
@@ -1382,6 +1382,7 @@ int generic_map_update_batch(struct bpf_
 
 	kfree(value);
 	kfree(key);
+	fdput(f);
 	return err;
 }
 


