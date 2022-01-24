Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2C549991C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454184AbiAXVb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451495AbiAXVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459F8C0617AD;
        Mon, 24 Jan 2022 12:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02ACBB8121C;
        Mon, 24 Jan 2022 20:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F379C340E5;
        Mon, 24 Jan 2022 20:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055447;
        bh=PuXMzZC0JJs9TAfAXVy0DFtIr+gcAaCNY8pQmI2PdSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbvWWtC4XSGtpM6dcHrvo90kLRx/5khu+/Ta1Q5GHBV+ZT3UK0wqBC8sMblvKFQhT
         om0c61U2Zhl3A8mk2CV+11IHpt9O8FsPXOjO1JxEm67hpH4dq4lCsncJ/nKZ6LuVZ1
         7dHZSRpnuhVpTMwcZcZPzZeQWj1Lzz2fZ50v16JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/846] libbpf: Fix glob_syms memory leak in bpf_linker
Date:   Mon, 24 Jan 2022 19:34:24 +0100
Message-Id: <20220124184106.057803738@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 2df880cefdaee..84095a2c2ef2a 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -211,6 +211,7 @@ void bpf_linker__free(struct bpf_linker *linker)
 	}
 	free(linker->secs);
 
+	free(linker->glob_syms);
 	free(linker);
 }
 
-- 
2.34.1



