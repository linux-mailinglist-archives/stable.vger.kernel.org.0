Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CDE291E45
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgJRTvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgJRTVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C55222B9;
        Sun, 18 Oct 2020 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048873;
        bh=Xerhk7RgVOtG1WU9Ag6tCmB6KN9b6/1DMXofnjiU4rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Il5M2COmmJFwjY31aJk3WN/kDjyX48MbfSNk+gjDpswDG5LQNhcr6kKxsGJhBJQr4
         /x0eTP9hdnOQpfedpjZmQ+oeSAn6HKqF+yG5sd85NuW9ItQJ+1XtnhdfpUZOwY6WPk
         YbUZrt4MUkFrz2JtP6++RjNBuOeLzCXfM3nmBLHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 038/101] libbpf: Close map fd if init map slots failed
Date:   Sun, 18 Oct 2020 15:19:23 -0400
Message-Id: <20201018192026.4053674-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a0f2b7acb4b1d29127ff99c714233b973afd1411 ]

Previously we forgot to close the map fd if bpf_map_update_elem()
failed during map slot init, which will leak map fd.

Let's move map slot initialization to new function init_map_slots() to
simplify the code. And close the map fd if init slot failed.

Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201006021345.3817033-2-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 55 ++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 236c91aff48f8..bafc0524a83a7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3677,6 +3677,36 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
+static int init_map_slots(struct bpf_map *map)
+{
+	const struct bpf_map *targ_map;
+	unsigned int i;
+	int fd, err;
+
+	for (i = 0; i < map->init_slots_sz; i++) {
+		if (!map->init_slots[i])
+			continue;
+
+		targ_map = map->init_slots[i];
+		fd = bpf_map__fd(targ_map);
+		err = bpf_map_update_elem(map->fd, &i, &fd, 0);
+		if (err) {
+			err = -errno;
+			pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
+				map->name, i, targ_map->name,
+				fd, err);
+			return err;
+		}
+		pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
+			 map->name, i, targ_map->name, fd);
+	}
+
+	zfree(&map->init_slots);
+	map->init_slots_sz = 0;
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
@@ -3719,28 +3749,11 @@ bpf_object__create_maps(struct bpf_object *obj)
 		}
 
 		if (map->init_slots_sz) {
-			for (j = 0; j < map->init_slots_sz; j++) {
-				const struct bpf_map *targ_map;
-				int fd;
-
-				if (!map->init_slots[j])
-					continue;
-
-				targ_map = map->init_slots[j];
-				fd = bpf_map__fd(targ_map);
-				err = bpf_map_update_elem(map->fd, &j, &fd, 0);
-				if (err) {
-					err = -errno;
-					pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
-						map->name, j, targ_map->name,
-						fd, err);
-					goto err_out;
-				}
-				pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
-					 map->name, j, targ_map->name, fd);
+			err = init_map_slots(map);
+			if (err < 0) {
+				zclose(map->fd);
+				goto err_out;
 			}
-			zfree(&map->init_slots);
-			map->init_slots_sz = 0;
 		}
 
 		if (map->pin_path && !map->pinned) {
-- 
2.25.1

