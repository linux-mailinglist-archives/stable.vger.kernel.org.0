Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32D040DFF5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhIPQQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240862AbhIPQOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893B161246;
        Thu, 16 Sep 2021 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808640;
        bh=8e0DDvsPXf1kH0LnFdERMGCtpGzYk7PCmA9MgBhGK6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezzpT+CpYcb0jGOUs+aX6iEVZFrg0nqNkd+SL2Z+EhNGO6IkY5k//KcaBmosjCJfu
         RrpScqW3ow4/IzF5SW8ZdEAHVLdnpUp6S1XFNETWIQpRcn4UVBisdQCqgIHiFPzQez
         9uEDyqN5yu9wWSH1PsRglJlArFc3rM2yGWoWb39Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/306] libbpf: Fix race when pinning maps in parallel
Date:   Thu, 16 Sep 2021 17:58:32 +0200
Message-Id: <20210916155759.774620841@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

[ Upstream commit 043c5bb3c4f43670ab4fea0b847373ab42d25f3e ]

When loading in parallel multiple programs which use the same to-be
pinned map, it is possible that two instances of the loader will call
bpf_object__create_maps() at the same time. If the map doesn't exist
when both instances call bpf_object__reuse_map(), then one of the
instances will fail with EEXIST when calling bpf_map__pin().

Fix the race by retrying reusing a map if bpf_map__pin() returns
EEXIST. The fix is similar to the one in iproute2: e4c4685fd6e4 ("bpf:
Fix race condition with map pinning").

Before retrying the pinning, we don't do any special cleaning of an
internal map state. The closer code inspection revealed that it's not
required:

    - bpf_object__create_map(): map->inner_map is destroyed after a
      successful call, map->fd is closed if pinning fails.
    - bpf_object__populate_internal_map(): created map elements is
      destroyed upon close(map->fd).
    - init_map_slots(): slots are freed after their initialization.

Signed-off-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210726152001.34845-1-m@lambda.lt
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0dad862b3b9d..b337d6f29098 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4284,10 +4284,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	unsigned int i, j;
 	int err;
+	bool retried;
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		map = &obj->maps[i];
 
+		retried = false;
+retry:
 		if (map->pin_path) {
 			err = bpf_object__reuse_map(map);
 			if (err) {
@@ -4295,6 +4298,12 @@ bpf_object__create_maps(struct bpf_object *obj)
 					map->name);
 				goto err_out;
 			}
+			if (retried && map->fd < 0) {
+				pr_warn("map '%s': cannot find pinned map\n",
+					map->name);
+				err = -ENOENT;
+				goto err_out;
+			}
 		}
 
 		if (map->fd >= 0) {
@@ -4328,9 +4337,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->pin_path && !map->pinned) {
 			err = bpf_map__pin(map, NULL);
 			if (err) {
+				zclose(map->fd);
+				if (!retried && err == -EEXIST) {
+					retried = true;
+					goto retry;
+				}
 				pr_warn("map '%s': failed to auto-pin at '%s': %d\n",
 					map->name, map->pin_path, err);
-				zclose(map->fd);
 				goto err_out;
 			}
 		}
-- 
2.30.2



