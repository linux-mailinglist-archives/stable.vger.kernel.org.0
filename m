Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1429240947F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345813AbhIMObc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346889AbhIMO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E2AB61B7D;
        Mon, 13 Sep 2021 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541051;
        bh=TVKnn333PQunDpQYQvNZzRndMa0VJJy06bQeM8/f4/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S030UuWl3L3Ip+PxqGVjpF9pIrd492ExcHzDsaORSCdt74XOjTBQZmv5QDXZSFMPJ
         UkLS4QcWKukW1Y5PkcOTsy1Ul0pawAdY2hZGnPHSF2tZacFzyTvp1lvY0eNTQjQ2/U
         6ff2wJlDrg0KirZWRt4IWSTCLN7SdbpfI8MYa7k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 143/334] libbpf: Return non-null error on failures in libbpf_find_prog_btf_id()
Date:   Mon, 13 Sep 2021 15:13:17 +0200
Message-Id: <20210913131118.190310648@linuxfoundation.org>
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

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 6d2d73cdd673d493f9f3751188757129b1d23fb7 ]

Variable "err" is initialised to -EINVAL so that this error code is
returned when something goes wrong in libbpf_find_prog_btf_id().
However, a recent change in the function made use of the variable in
such a way that it is set to 0 if retrieving linear information on the
program is successful, and this 0 value remains if we error out on
failures at later stages.

Let's fix this by setting err to -EINVAL later in the function.

Fixes: e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level APIs")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210729162028.29512-2-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index aa5ad6fc5f40..2234d5c33177 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9515,7 +9515,7 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_prog_info *info;
 	struct btf *btf = NULL;
-	int err = -EINVAL;
+	int err;
 
 	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
 	err = libbpf_get_error(info_linear);
@@ -9524,6 +9524,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 			attach_prog_fd);
 		return err;
 	}
+
+	err = -EINVAL;
 	info = &info_linear->info;
 	if (!info->btf_id) {
 		pr_warn("The target program doesn't have BTF\n");
-- 
2.30.2



