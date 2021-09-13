Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC532409151
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245171AbhIMOAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244583AbhIMN6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1381461A09;
        Mon, 13 Sep 2021 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540213;
        bh=thT2wqlvZf15xo7YVN8BMgNJmBy43XTZYaqLpOtEODU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWd48goyVHFng+o3gGNVMc7n2XDvJ4G5fkZGH49wE76G7gcLsuST25UhmxHjmp9rU
         rsArwau8jWA86gT/ADT1+CC8lZ4t7/KaJ2HVLx0broazFsuUoobhe3cit+xEFkCfHX
         steNAeIyej7mnCS8GIs/Vy7axwsuy/ZFsXqeF4ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 100/300] libbpf: Fix removal of inner map in bpf_object__create_map
Date:   Mon, 13 Sep 2021 15:12:41 +0200
Message-Id: <20210913131112.757649153@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

[ Upstream commit a21ab4c59e09c2a9994a6e393b7484e3b3f78a99 ]

If creating an outer map of a BTF-defined map-in-map fails (via
bpf_object__create_map()), then the previously created its inner map
won't be destroyed.

Fix this by ensuring that the destroy routines are not bypassed in the
case of a failure.

Fixes: 646f02ffdd49c ("libbpf: Add BTF-defined map-in-map support")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20210719173838.423148-2-m@lambda.lt
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2af2d0e4a231..f6ebda75b030 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4409,6 +4409,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 {
 	struct bpf_create_map_attr create_attr;
 	struct bpf_map_def *def = &map->def;
+	int err = 0;
 
 	memset(&create_attr, 0, sizeof(create_attr));
 
@@ -4451,8 +4452,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 
 	if (bpf_map_type__is_map_in_map(def->type)) {
 		if (map->inner_map) {
-			int err;
-
 			err = bpf_object__create_map(obj, map->inner_map);
 			if (err) {
 				pr_warn("map '%s': failed to create inner map: %d\n",
@@ -4469,8 +4468,8 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
 		char *cp, errmsg[STRERR_BUFSIZE];
-		int err = -errno;
 
+		err = -errno;
 		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 		pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
 			map->name, cp, err);
@@ -4482,15 +4481,14 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 		map->fd = bpf_create_map_xattr(&create_attr);
 	}
 
-	if (map->fd < 0)
-		return -errno;
+	err = map->fd < 0 ? -errno : 0;
 
 	if (bpf_map_type__is_map_in_map(def->type) && map->inner_map) {
 		bpf_map__destroy(map->inner_map);
 		zfree(&map->inner_map);
 	}
 
-	return 0;
+	return err;
 }
 
 static int init_map_slots(struct bpf_map *map)
-- 
2.30.2



