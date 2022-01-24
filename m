Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9E499673
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445540AbiAXVEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353026AbiAXU6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CEC61365;
        Mon, 24 Jan 2022 20:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90921C340E5;
        Mon, 24 Jan 2022 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057884;
        bh=RO+5N/zhRhahqWndNfd+YsjyavI19TV9eMuwRXShToo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIFpWiSCkkbm9r38mtPAp7mSTovnYEy7aKVudpVvgeOluvHWCW+B/D7GvcqnY2M5z
         GuTKR2dFSMExAQixtP3U9J/xtGdorTkHgZw9mXP91uTdARIMYyCrTKxJ6BEanVeMgP
         Kpq3bfuaq0mKHDlnU7i2/SUbNElUN3Vxr58ixcRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0110/1039] libbpf: Free up resources used by inner map definition
Date:   Mon, 24 Jan 2022 19:31:39 +0100
Message-Id: <20220124184128.836185058@linuxfoundation.org>
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

[ Upstream commit 8f7b239ea8cfdc8e64c875ee417fed41431a1f37 ]

It's not enough to just free(map->inner_map), as inner_map itself can
have extra memory allocated, like map name.

Fixes: 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5367bc8e52073..509f3719409bb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9028,7 +9028,10 @@ int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
 		pr_warn("error: inner_map_fd already specified\n");
 		return libbpf_err(-EINVAL);
 	}
-	zfree(&map->inner_map);
+	if (map->inner_map) {
+		bpf_map__destroy(map->inner_map);
+		zfree(&map->inner_map);
+	}
 	map->inner_map_fd = fd;
 	return 0;
 }
-- 
2.34.1



