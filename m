Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7914998EE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453759AbiAXVat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450655AbiAXVVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5428FC0A1CC7;
        Mon, 24 Jan 2022 12:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08674B812A5;
        Mon, 24 Jan 2022 20:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAE2C340E7;
        Mon, 24 Jan 2022 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055276;
        bh=1XugZksY2Q1RIc5Ov3cpXwUMSko7XlkqMP6r64FLYaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ui4xB5DUYphgvhlHiOHh9Pb8xGCwdoroSqhtmwUejApUHTQfmIWvWegyxlNAoiGNV
         pvD1FKHb6jRtG7IoAWuHd3+ygNcg0l6+tXORHaEVMroQls/lu+avi3W2D0PJqaHGOe
         0yu/RaHv88IbIhcn2ZMR/1TTaQmBm87CvcWDTsME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/846] libbpf: Free up resources used by inner map definition
Date:   Mon, 24 Jan 2022 19:33:35 +0100
Message-Id: <20220124184104.375758757@linuxfoundation.org>
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
index 7145463a4a562..0ad29203cbfbf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8676,7 +8676,10 @@ int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
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



