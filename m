Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A4E27C6BE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbgI2LsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbgI2Lry (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A60206F7;
        Tue, 29 Sep 2020 11:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380073;
        bh=H4c31ZNlW0cn5fufbmATipIZwP5vLeuOu+F6uB91H2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpaU08QfdAGvoM9/VrGLeB/Sd0U7lMgZrFu/7MvgcXqDWQuxT/1UD6Sz5149ym7tt
         kaS3mJco1o/LQHJLpNj2wJn+UCeZv0Cjn1wZucLaGdJhlsLoYsZ6YzNJP9QNhKsRfU
         OkwB6Bv7/mIMbHhkFqv8qY5Cl6bG5ZYwm1oXwAjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 26/99] libbpf: Fix build failure from uninitialized variable warning
Date:   Tue, 29 Sep 2020 13:01:09 +0200
Message-Id: <20200929105931.016376299@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 3168c158ad3535af1cd7423c9f8cd5ac549f2f9c ]

While compiling libbpf, some GCC versions (at least 8.4.0) have difficulty
determining control flow and a emit warning for potentially uninitialized
usage of 'map', which results in a build error if using "-Werror":

In file included from libbpf.c:56:
libbpf.c: In function '__bpf_object__open':
libbpf_internal.h:59:2: warning: 'map' may be used uninitialized in this function [-Wmaybe-uninitialized]
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
  ^~~~~~~~~~~~
libbpf.c:5032:18: note: 'map' was declared here
  struct bpf_map *map, *targ_map;
                  ^~~

The warning/error is false based on code inspection, so silence it with a
NULL initialization.

Fixes: 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map support")
Reference: 063e68813391 ("libbpf: Fix false uninitialized variable warning")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200831000304.1696435-1-Tony.Ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3ac0094706b81..236c91aff48f8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5030,8 +5030,8 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
 	int i, j, nrels, new_sz;
 	const struct btf_var_secinfo *vi = NULL;
 	const struct btf_type *sec, *var, *def;
+	struct bpf_map *map = NULL, *targ_map;
 	const struct btf_member *member;
-	struct bpf_map *map, *targ_map;
 	const char *name, *mname;
 	Elf_Data *symbols;
 	unsigned int moff;
-- 
2.25.1



