Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB73ED655
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhHPNUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240392AbhHPNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 454F4632F5;
        Mon, 16 Aug 2021 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119619;
        bh=AFSoulhYUMNVBK6Gyldb72HJbX4q6DqARrNVCvnHzeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwt8LDpn8i0zvaYSvPh3mjGtLa0uKN8mOmQev0DphN0W6hUTSFwGLUZNJ85twM050
         MX51eo7BLvKArAu4s4GYqVikhoPc/+QNArF6X69lXoDs5j0U2cH981ekKYQ1crg3YL
         C0zYd1D4Fy2LueCJz/BVOROnu47oZxxwk81MSNH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Xu <dxu@dxuuu.xyz>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 063/151] libbpf: Do not close un-owned FD 0 on errors
Date:   Mon, 16 Aug 2021 15:01:33 +0200
Message-Id: <20210816125446.143295347@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit c34c338a40e4f3b6f80889cd17fd9281784d1c32 ]

Before this patch, btf_new() was liable to close an arbitrary FD 0 if
BTF parsing failed. This was because:

* btf->fd was initialized to 0 through the calloc()
* btf__free() (in the `done` label) closed any FDs >= 0
* btf->fd is left at 0 if parsing fails

This issue was discovered on a system using libbpf v0.3 (without
BTF_KIND_FLOAT support) but with a kernel that had BTF_KIND_FLOAT types
in BTF. Thus, parsing fails.

While this patch technically doesn't fix any issues b/c upstream libbpf
has BTF_KIND_FLOAT support, it'll help prevent issues in the future if
more BTF types are added. It also allow the fix to be backported to
older libbpf's.

Fixes: 3289959b97ca ("libbpf: Support BTF loading and raw data output in both endianness")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/5969bb991adedb03c6ae93e051fd2a00d293cf25.1627513670.git.dxu@dxuuu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d57e13a13798..1d9e5b35524c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -805,6 +805,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 	btf->nr_types = 0;
 	btf->start_id = 1;
 	btf->start_str_off = 0;
+	btf->fd = -1;
 
 	if (base_btf) {
 		btf->base_btf = base_btf;
@@ -833,8 +834,6 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 	if (err)
 		goto done;
 
-	btf->fd = -1;
-
 done:
 	if (err) {
 		btf__free(btf);
-- 
2.30.2



