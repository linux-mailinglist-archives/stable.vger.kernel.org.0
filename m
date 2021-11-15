Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44045250E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhKPBqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241603AbhKOSXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B81A61AAD;
        Mon, 15 Nov 2021 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998833;
        bh=4nVadxB16ZJj1oWdVPkPole19kWdPG1hrPvNHloTras=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoXgeq/veLOSgoddfwFkSpl7o7bp/4wE7g0tTSTtuUy6/tY3NM6fiJNmyVKEezBol
         oofRJQdK0Kg86X+hN/Y0daVxl6YreSv3IjQGS7kcsfUYeLe1lNz8CSL1d5CgY33SO2
         B6fnX+cwM+IQdbp9szfUFR1oCIEsnO4ScRJRWhs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 079/849] bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
Date:   Mon, 15 Nov 2021 17:52:42 +0100
Message-Id: <20211115165422.729521171@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 5d63ae908242f028bd10860cba98450d11c079b8 ]

Expose the maximum amount of useable memory from the arm64 JIT.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211014142554.53120-3-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 41c23f474ea63..803e7773fa869 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1136,6 +1136,11 @@ out:
 	return prog;
 }
 
+u64 bpf_jit_alloc_exec_limit(void)
+{
+	return BPF_JIT_REGION_SIZE;
+}
+
 void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-- 
2.33.0



