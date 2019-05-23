Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2838F2885F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391110AbfEWTZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391105AbfEWTZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39CC206BA;
        Thu, 23 May 2019 19:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639527;
        bh=MqiK/pwYrLP1q3cNq0HrdojzHB5jY3cfxErOTLJALFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwiXAAbVH5hShPzBvKpPo1RIuGPwF9KB0/9hFMVN2lFoqdwX4YyjWlLZyacMngYJ8
         Mm8861SrNaEx77tm96HbsWC7E33Jyi3ycA2Lp1Lds8h0U9DweTeXRH/vCmC21B6Jpc
         FQmmK88H0/x3VgFjym+JsogQ5AwcObyYIjp5uEU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.0 138/139] bpf: add map_lookup_elem_sys_only for lookups from syscall side
Date:   Thu, 23 May 2019 21:07:06 +0200
Message-Id: <20190523181736.720860528@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit c6110222c6f49ea68169f353565eb865488a8619 upstream.

Add a callback map_lookup_elem_sys_only() that map implementations
could use over map_lookup_elem() from system call side in case the
map implementation needs to handle the latter differently than from
the BPF data path. If map_lookup_elem_sys_only() is set, this will
be preferred pick for map lookups out of user space. This hook is
used in a follow-up fix for LRU map, but once development window
opens, we can convert other map types from map_lookup_elem() (here,
the one called upon BPF_MAP_LOOKUP_ELEM cmd is meant) over to use
the callback to simplify and clean up the latter.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bpf.h  |    1 +
 kernel/bpf/syscall.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -35,6 +35,7 @@ struct bpf_map_ops {
 	void (*map_free)(struct bpf_map *map);
 	int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
 	void (*map_release_uref)(struct bpf_map *map);
+	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -738,7 +738,10 @@ static int map_lookup_elem(union bpf_att
 		err = map->ops->map_peek_elem(map, value);
 	} else {
 		rcu_read_lock();
-		ptr = map->ops->map_lookup_elem(map, key);
+		if (map->ops->map_lookup_elem_sys_only)
+			ptr = map->ops->map_lookup_elem_sys_only(map, key);
+		else
+			ptr = map->ops->map_lookup_elem(map, key);
 		if (IS_ERR(ptr)) {
 			err = PTR_ERR(ptr);
 		} else if (!ptr) {


