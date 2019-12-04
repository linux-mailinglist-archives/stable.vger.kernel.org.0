Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD91133D4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbfLDSIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbfLDSIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:08:43 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C94B206DF;
        Wed,  4 Dec 2019 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482922;
        bh=Nh+HcfVHCez8hEtRqsXlfDz3c1EZS0DjrPKmFW0Nb7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oP4Q/Vu6XSYETN2ILr2I8vVLmooWuZl5JlpAoGpeHfjqBRmOh/8xBHa1o/AEZZCPY
         tYLnvoYBpawqM+iKOvJLFtuDTjTG2TpsLE1sCdsV8mzwrkPfFx74pA+64TCYoXHszT
         sZDN6s+5Y3P68oCp1quh78e49xCn8r1bxn3fz7/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Sun <sironhide0null@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/209] bpf: drop refcount if bpf_map_new_fd() fails in map_create()
Date:   Wed,  4 Dec 2019 18:55:57 +0100
Message-Id: <20191204175333.517622722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Sun <sironhide0null@gmail.com>

[ Upstream commit 352d20d611414715353ee65fc206ee57ab1a6984 ]

In bpf/syscall.c, map_create() first set map->usercnt to 1, a file
descriptor is supposed to return to userspace. When bpf_map_new_fd()
fails, drop the refcount.

Fixes: bd5f5f4ecb78 ("bpf: Add BPF_MAP_GET_FD_BY_ID")
Signed-off-by: Peng Sun <sironhide0null@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 34110450a78f2..f5c1d5479ba3d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -348,12 +348,12 @@ static int map_create(union bpf_attr *attr)
 	err = bpf_map_new_fd(map);
 	if (err < 0) {
 		/* failed to allocate fd.
-		 * bpf_map_put() is needed because the above
+		 * bpf_map_put_with_uref() is needed because the above
 		 * bpf_map_alloc_id() has published the map
 		 * to the userspace and the userspace may
 		 * have refcnt-ed it through BPF_MAP_GET_FD_BY_ID.
 		 */
-		bpf_map_put(map);
+		bpf_map_put_with_uref(map);
 		return err;
 	}
 
-- 
2.20.1



