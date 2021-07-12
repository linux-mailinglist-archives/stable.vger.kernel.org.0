Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC883C49D5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbhGLGq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237322AbhGLGqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A0061153;
        Mon, 12 Jul 2021 06:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072116;
        bh=MpOHLmu9O94BZxYx8gRPUM9KVkgIO8BnigbsNjk/yLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpKhn4cgQP4nhXw3lGrP3hDdQ9jBR0VRnvE0Pt1kJSHLKTq3JCQ4VBGHZetQWivjY
         3+6ujK+dUJLVChS/DtBeJXNxZpYt2zvk3yihXdmf0omyNHGPLgHehqxOvoouJDQj7f
         VmmUYpxRMYNldE+SmkME/r3vSEXHrf+U4au5PqoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Xu <dxu@dxuuu.xyz>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/593] selftests/bpf: Whitelist test_progs.h from .gitignore
Date:   Mon, 12 Jul 2021 08:08:41 +0200
Message-Id: <20210712060926.177717981@linuxfoundation.org>
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
index 3ab1200e172f..b1b37dcade9f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -9,6 +9,7 @@ fixdep
 test_dev_cgroup
 /test_progs*
 test_tcpbpf_user
+!test_progs.h
 test_verifier_log
 feature
 test_sock
-- 
2.30.2



