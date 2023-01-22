Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57B676EC8
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjAVPOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjAVPOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B8B22005
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8992C60C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99090C433EF;
        Sun, 22 Jan 2023 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400456;
        bh=irmckzeQbsuB/pYcPM06W/3YkbMDqLGOIJHCh1AzCxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDRn5p1q2gGR7OV4T5SBejrct4qmRw0gyJawu6aThcueEBFPDoyuB1YL3joIL6QpN
         NhysWRa/4W8e+G6SSicDpe1JJF+vc7/p1AQ2H4VQs3/xZpI1HvMybLuNjqcr57mbm/
         yvZMg/DwJaqqs4wA1PvT64CshvgLBVIYerLBXdvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Ola Jeppsson <ola@snap.com>, Abel Vesa <abel.vesa@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 52/98] misc: fastrpc: Fix use-after-free race condition for maps
Date:   Sun, 22 Jan 2023 16:04:08 +0100
Message-Id: <20230122150231.697441019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ola Jeppsson <ola@snap.com>

commit 96b328d119eca7563c1edcc4e1039a62e6370ecb upstream.

It is possible that in between calling fastrpc_map_get() until
map->fl->lock is taken in fastrpc_free_map(), another thread can call
fastrpc_map_lookup() and get a reference to a map that is about to be
deleted.

Rewrite fastrpc_map_get() to only increase the reference count of a map
if it's non-zero. Propagate this to callers so they can know if a map is
about to be deleted.

Fixes this warning:
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 5 PID: 10100 at lib/refcount.c:25 refcount_warn_saturate
...
Call trace:
 refcount_warn_saturate
 [fastrpc_map_get inlined]
 [fastrpc_map_lookup inlined]
 fastrpc_map_create
 fastrpc_internal_invoke
 fastrpc_device_ioctl
 __arm64_sys_ioctl
 invoke_syscall

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable <stable@kernel.org>
Signed-off-by: Ola Jeppsson <ola@snap.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221124174941.418450-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -263,10 +263,12 @@ static void fastrpc_map_put(struct fastr
 		kref_put(&map->refcount, fastrpc_free_map);
 }
 
-static void fastrpc_map_get(struct fastrpc_map *map)
+static int fastrpc_map_get(struct fastrpc_map *map)
 {
-	if (map)
-		kref_get(&map->refcount);
+	if (!map)
+		return -ENOENT;
+
+	return kref_get_unless_zero(&map->refcount) ? 0 : -ENOENT;
 }
 
 static int fastrpc_map_find(struct fastrpc_user *fl, int fd,


