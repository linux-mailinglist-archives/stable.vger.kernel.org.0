Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73529BBEB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809842AbgJ0Q3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802704AbgJ0Pu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9194C207C3;
        Tue, 27 Oct 2020 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813859;
        bh=2EdnI/44i6cOeu1YQKKHewLtw6WjTFdpQXVpmbL+U34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa4Qk+MUSVPUGkM0qNX/52ZY/cGgkJRAnt19tSFKbzaVKFUkOZKl3eNBOkRayAoFE
         YfyjZIal+M0EWESdVwni0hwURvZ1YZGYCS61zZV4vdHpqcpYMYpqqW/61JhqHAo+ql
         1vQsOjydTYWzSU4xkli2dbG1pgUmrd5oghHJ54sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 677/757] libbpf: Close map fd if init map slots failed
Date:   Tue, 27 Oct 2020 14:55:27 +0100
Message-Id: <20201027135522.291289890@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8b71a31ca4a97..edd6f7b7d9b82 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3841,6 +3841,36 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
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
@@ -3883,28 +3913,11 @@ bpf_object__create_maps(struct bpf_object *obj)
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



