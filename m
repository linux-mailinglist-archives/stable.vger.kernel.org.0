Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F083C49DA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhGLGrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237645AbhGLGq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B64A76101E;
        Mon, 12 Jul 2021 06:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072128;
        bh=/vJfQf0KqnpTvcZfTUjXJKbG+jsTGoegs3278QZjCmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWyJLnfPaM6TClpOooGPv0fq92Ni/PW64AykxomT3bcPfyoXBlWRj7ozLe/NRnlqc
         cetI6eWhFy2mEFMFTSgCj38+UGPRsXuvN15EKUS7Utr0zJStS3s2fFl4zwCyxzQST7
         zwITqo93gN1kNq7jx0j3C5LLz9H3Gx7/3PO+4puM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/593] tools/bpftool: Fix error return code in do_batch()
Date:   Mon, 12 Jul 2021 08:08:19 +0200
Message-Id: <20210712060923.290188504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 33068d6ed5d6..c58a135dc355 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -338,8 +338,10 @@ static int do_batch(int argc, char **argv)
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



