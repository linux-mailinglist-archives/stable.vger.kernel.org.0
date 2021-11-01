Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA6B4417D8
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhKAJkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhKAJhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A7DA6135A;
        Mon,  1 Nov 2021 09:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758814;
        bh=pCmfhynfVRMTz77d99mvKRVIv+QqsiCuApemwBRjFkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwBcLc4SLMBovlPx4qPx4bCiwfvC4PHE68jxH3FWoIgx312xlfE7/LGHg/fHokbHk
         AkUBV7B1TOFuBVBZzG4wssL5a7lDlfEgXRX0Sm0emq5XTioz5ETR9YhYaB0/uuieTM
         qbTzrY17p9YxYjFaDTIl19ZMaH9aagMT39DF+U14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Kuohai <xukuohai@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 38/77] bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()
Date:   Mon,  1 Nov 2021 10:17:26 +0100
Message-Id: <20211101082519.913605339@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -1309,12 +1309,11 @@ int generic_map_update_batch(struct bpf_
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
 
@@ -1339,6 +1338,7 @@ int generic_map_update_batch(struct bpf_
 		return -ENOMEM;
 	}
 
+	f = fdget(ufd); /* bpf_map_do_batch() guarantees ufd is valid */
 	for (cp = 0; cp < max_count; cp++) {
 		err = -EFAULT;
 		if (copy_from_user(key, keys + cp * map->key_size,
@@ -1358,6 +1358,7 @@ int generic_map_update_batch(struct bpf_
 
 	kfree(value);
 	kfree(key);
+	fdput(f);
 	return err;
 }
 


