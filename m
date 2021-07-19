Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E8C3CDD1D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhGSO4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237975AbhGSOxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFD361249;
        Mon, 19 Jul 2021 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708774;
        bh=1lFpVrFhGJi6Y5ZeBVcXi7/wuX7f+Sf5yJ+Q1Ri4xZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsRwlaAKms6o7O2lnvccJikvxWpVLfyxAP4o4WshZ7xvLdWO39KYYUWHMYYzvJmTa
         f4PiIiL1d75tdbnk2r5k5OsuIRgurxKQCykgbB6k37ibs/OK8h6zSffHdQFTnwvw7K
         Zlmh85Hi+xPYS9JUEE3FEsSTb5EbV7Qo9H0BlA4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/421] tools/bpftool: Fix error return code in do_batch()
Date:   Mon, 19 Jul 2021 16:48:57 +0200
Message-Id: <20210719144950.911086062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index d15a62be6cf0..37610144f6b0 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -291,8 +291,10 @@ static int do_batch(int argc, char **argv)
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



