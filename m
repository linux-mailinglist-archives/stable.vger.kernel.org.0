Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1385D3C4E44
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244532AbhGLHRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240075AbhGLHQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859DE61153;
        Mon, 12 Jul 2021 07:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074037;
        bh=PzEQanErQby50e1hChNgY74Y8p6+VUwcFMVmNlBaGz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDJMNLHiCaRZG+5Y5pQZxuavS2F5nlIxNThPlCyhdX5hSeOUACmeo9ohzDqN5iIOi
         KK2wfcaV8O3tSRg12Z1S5503fsHPfH0wllGXivr2ufvw7sCFFw48n10cuG+DXME5ZK
         fdHmnQSk4WqBz7nK+snuw6p1DD0yIw7X8ff48Y6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 400/700] tools/bpftool: Fix error return code in do_batch()
Date:   Mon, 12 Jul 2021 08:08:03 +0200
Message-Id: <20210712061018.931757420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit ca16b429f39b4ce013bfa7e197f25681e65a2a42 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 668da745af3c2 ("tools: bpftool: add support for quotations ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20210609115916.2186872-1-chengzhihao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index d9afb730136a..0f36b9edd3f5 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -340,8 +340,10 @@ static int do_batch(int argc, char **argv)
 		n_argc = make_args(buf, n_argv, BATCH_ARG_NB_MAX, lines);
 		if (!n_argc)
 			continue;
-		if (n_argc < 0)
+		if (n_argc < 0) {
+			err = n_argc;
 			goto err_close;
+		}
 
 		if (json_output) {
 			jsonw_start_object(json_wtr);
-- 
2.30.2



