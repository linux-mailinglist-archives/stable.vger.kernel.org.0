Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2AD4091BE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbhIMOF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343928AbhIMOB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB796613B5;
        Mon, 13 Sep 2021 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540277;
        bh=pegOMUlMbZdM5E+EtRNU5j8y5kuY5Nu/4AfHP64OQs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1t/FYmmdVkzhzLPqZnhWoGYjXJfBy5Fw5KjV4lsnTnt+ANJ62UU3hyGU2wL8J3qV
         uZxsbtRtdMpMPOl1C46dmv7OnCmsCoTs1fI8RQSGoHCgEFo1TFKjPT7DUcbbm7xL6d
         dB+P4M+IHD/wRNJ73lnBTGwFmXh4tGB+DuHxhcaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuyi Cheng <chengshuyi@linux.alibaba.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/300] libbpf: Fix the possible memory leak on error
Date:   Mon, 13 Sep 2021 15:12:35 +0200
Message-Id: <20210913131112.555649472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuyi Cheng <chengshuyi@linux.alibaba.com>

[ Upstream commit 18353c87e0e0440d4c7c746ed740738bbc1b538e ]

If the strdup() fails then we need to call bpf_object__close(obj) to
avoid a resource leak.

Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/1626180159-112996-3-git-send-email-chengshuyi@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c41d9b2b59ac..2af2d0e4a231 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7365,8 +7365,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
 		obj->kconfig = strdup(kconfig);
-		if (!obj->kconfig)
-			return ERR_PTR(-ENOMEM);
+		if (!obj->kconfig) {
+			err = -ENOMEM;
+			goto out;
+		}
 	}
 
 	err = bpf_object__elf_init(obj);
-- 
2.30.2



