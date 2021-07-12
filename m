Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C983B3C4E25
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbhGLHRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242009AbhGLHQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01C17613BE;
        Mon, 12 Jul 2021 07:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073983;
        bh=Z7Qs7WuPbiefhYwHh6FUL/C56yKfnvQpL9jl4ULb0Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkWQUNUXtk/M6oy5Kc6deEUn0FR2+yqmoqAMH5qK5jPRhltZISHs8ZACV7SYECEzc
         7xe51s+PI03Hx5ztOaME7k8Ck9Tq9BArDcvwWgCzsh6WvXDRngjoSWfHf3x5rNVPAj
         kN9sqxL63mOyW/dAbZnM7PK53LfRxRbEMSKb67Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Xu <dxu@dxuuu.xyz>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 424/700] selftests/bpf: Whitelist test_progs.h from .gitignore
Date:   Mon, 12 Jul 2021 08:08:27 +0200
Message-Id: <20210712061021.495603078@linuxfoundation.org>
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

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 809ed84de8b3f2fd7b1d06efb94bf98fd318a7d7 ]

Somehow test_progs.h was being included by the existing rule:

    /test_progs*

This is bad because:

    1) test_progs.h is a checked in file
    2) grep-like tools like ripgrep[0] respect gitignore and
       test_progs.h was being hidden from searches

[0]: https://github.com/BurntSushi/ripgrep

Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/a46f64944bf678bc652410ca6028d3450f4f7f4b.1623880296.git.dxu@dxuuu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index c0c48fdb9ac1..76d495fe3a17 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -8,6 +8,7 @@ FEATURE-DUMP.libbpf
 fixdep
 test_dev_cgroup
 /test_progs*
+!test_progs.h
 test_verifier_log
 feature
 test_sock
-- 
2.30.2



