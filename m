Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC0F408EA1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbhIMNgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241706AbhIMNdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A1086138E;
        Mon, 13 Sep 2021 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539586;
        bh=o21YIMvVkVJCwVrULYcHxHU/6XcaQYo/AjSboxziAsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTRfH5z4s/IQvi/tg01BeImz7K9NGXMXMUGy0icThfONqcToqIYwhngxptNBylw6T
         RM3gHRdY/q6Mlyk49dRX8bfk1mZ8veBuhym028MfaJJWPyeq/OCNEVD9xue2CpGzwO
         zt+m60kRdg0AS8KDSA4In3C099O13JQru+mEFJ+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuyi Cheng <chengshuyi@linux.alibaba.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/236] libbpf: Fix the possible memory leak on error
Date:   Mon, 13 Sep 2021 15:13:06 +0200
Message-Id: <20210913131103.116958945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 95eef7ebdac5..04cde732d686 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6907,8 +6907,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
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



