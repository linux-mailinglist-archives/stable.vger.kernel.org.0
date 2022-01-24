Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B87499FEB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842357AbiAXXBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839744AbiAXWvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:51:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97FBC09D9F0;
        Mon, 24 Jan 2022 13:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A99B811FB;
        Mon, 24 Jan 2022 21:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFE3C340E5;
        Mon, 24 Jan 2022 21:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058476;
        bh=iOwbgegqT26I6orDq8beuiWOLFK1+X2f+sFwzIToXCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtLpkQMbi+nYL042ZCwqzyVpzMok3cY3EZ7z3wnggWVnWz86UiTAYV5P1yckulCOj
         O+9BIY+F3inWjW1HxsjQssMX77bEWSEe23IXcXGXPkALj2P2EMexW7WiWiKh0Ms2PA
         LJzE6IZJ+Ubwn6y88eNPE+i9A55OiaGLnw01mqC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuyi Cheng <chengshuyi@linux.alibaba.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0268/1039] libbpf: Add "bool skipped" to struct bpf_map
Date:   Mon, 24 Jan 2022 19:34:17 +0100
Message-Id: <20220124184134.312014386@linuxfoundation.org>
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

From: Shuyi Cheng <chengshuyi@linux.alibaba.com>

[ Upstream commit 229fae38d0fc0d6ff58d57cbeb1432da55e58d4f ]

Fix error: "failed to pin map: Bad file descriptor, path:
/sys/fs/bpf/_rodata_str1_1."

In the old kernel, the global data map will not be created, see [0]. So
we should skip the pinning of the global data map to avoid
bpf_object__pin_maps returning error. Therefore, when the map is not
created, we mark “map->skipped" as true and then check during relocation
and during pinning.

Fixes: 16e0c35c6f7a ("libbpf: Load global data maps lazily on legacy kernels")
Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4050a0f8dad66..fd25e30e70cc2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -400,6 +400,7 @@ struct bpf_map {
 	char *pin_path;
 	bool pinned;
 	bool reused;
+	bool skipped;
 	__u64 map_extra;
 };
 
@@ -5003,8 +5004,10 @@ bpf_object__create_maps(struct bpf_object *obj)
 		 * kernels.
 		 */
 		if (bpf_map__is_internal(map) &&
-		    !kernel_supports(obj, FEAT_GLOBAL_DATA))
+		    !kernel_supports(obj, FEAT_GLOBAL_DATA)) {
+			map->skipped = true;
 			continue;
+		}
 
 		retried = false;
 retry:
@@ -5607,8 +5610,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			} else {
 				const struct bpf_map *map = &obj->maps[relo->map_idx];
 
-				if (bpf_map__is_internal(map) &&
-				    !kernel_supports(obj, FEAT_GLOBAL_DATA)) {
+				if (map->skipped) {
 					pr_warn("prog '%s': relo #%d: kernel doesn't support global data\n",
 						prog->name, i);
 					return -ENOTSUP;
@@ -7733,6 +7735,9 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		char *pin_path = NULL;
 		char buf[PATH_MAX];
 
+		if (map->skipped)
+			continue;
+
 		if (path) {
 			int len;
 
-- 
2.34.1



