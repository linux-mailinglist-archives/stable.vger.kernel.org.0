Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15369409450
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346540AbhIMOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343617AbhIMO2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E8661555;
        Mon, 13 Sep 2021 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540983;
        bh=dgGFn3u2j2PvLcAOQXu14us5nKFVIt7byqQ4zl8zAQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7R7f89gGz2sozs/R3Aw0N2Un5ZQAQCNbGO7koOGtTyd4jx9GW/R0sKfZ3L1fTQpQ
         9oem4icOpQ7dOYW91RjTXR7eqxdhH1crjyXdslaL/FmXhImlXDbYhwxcaSaF6MecKU
         QSvOopaa8Nrj1JUc5HVE61F3mjTjo9s3eH0euVvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuyi Cheng <chengshuyi@linux.alibaba.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/334] libbpf: Fix the possible memory leak on error
Date:   Mon, 13 Sep 2021 15:12:31 +0200
Message-Id: <20210913131116.653663271@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 6f5e2757bb3c..1bfd11de9be6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7588,8 +7588,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
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



