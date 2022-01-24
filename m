Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161AF4996A7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiAXVFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53796 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444606AbiAXVBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C473761317;
        Mon, 24 Jan 2022 21:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F689C340E5;
        Mon, 24 Jan 2022 21:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058070;
        bh=KXzbmPA767ltcjzNwVWOMCdu5eyCPYs7gRedD1yhhm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goF2PXxf7QSRK3TAK5FKer4ODLEQKuYej9nnsrgE2oEP8WFqRpqzL6sMnVlA3H7VI
         RhwFTRZZAEZvZCU2gxsfL1Fr7ikWiEVCw8sifHCnn2AtXm0iauczy8qh4UGPny9Lll
         K2mXTdfivGbmAogrDqNO3Ct5TaooZHOlOMyrCWXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0172/1039] libbpf: Fix glob_syms memory leak in bpf_linker
Date:   Mon, 24 Jan 2022 19:32:41 +0100
Message-Id: <20220124184131.023971255@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8cb125566c40b7141d8842c534f0ea5820ee3d5c ]

glob_syms array wasn't freed on bpf_link__free(). Fix that.

Fixes: a46349227cd8 ("libbpf: Add linker extern resolution support for functions and global variables")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211124002325.1737739-6-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index f677dccdeae44..94bdd97859285 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -210,6 +210,7 @@ void bpf_linker__free(struct bpf_linker *linker)
 	}
 	free(linker->secs);
 
+	free(linker->glob_syms);
 	free(linker);
 }
 
-- 
2.34.1



