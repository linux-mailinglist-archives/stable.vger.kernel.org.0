Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF154236F
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiFHDRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 23:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346406AbiFHDOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 23:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1519EC05;
        Tue,  7 Jun 2022 12:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3550B823CC;
        Tue,  7 Jun 2022 19:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D833C385A5;
        Tue,  7 Jun 2022 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629968;
        bh=ydX+2CKF6CXsKEyIp/NMR38F13oGuyKzNtRL6g2GNiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCGgJCXHl5Sxqzkq98hUAN/g42XDLoerZFgAPdI2Ke9TMdjSwbXHwJ8qHE8CEQXSR
         ffJ3NW1aUUl5j1ItSaWZh00P8+u4QbgTSQ0Rr7YniAyZoMKbALQFKSYXOT/K2sI3Cj
         rP64Of8X2J1InIFsSHF4WzZmHjCuMjx7kRzj+1nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Jablonsky <jjablonsky@snapchat.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.18 853/879] misc: fastrpc: fix list iterator in fastrpc_req_mem_unmap_impl
Date:   Tue,  7 Jun 2022 19:06:11 +0200
Message-Id: <20220607165027.614890950@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit c5c07c5958cf0c9af6e76813e6de15d42ee49822 upstream.

This is another instance of incorrect use of list iterator and
checking it for NULL.

The list iterator value 'map' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty (in this case, the
check 'if (!map) {' will always be false and never exit as expected).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'map' as a dedicated pointer to
point to the found element.

Without this patch, Kernel crashes with below trace:

Unable to handle kernel access to user memory outside uaccess routines
 at virtual address 0000ffff7fb03750
...
Call trace:
 fastrpc_map_create+0x70/0x290 [fastrpc]
 fastrpc_req_mem_map+0xf0/0x2dc [fastrpc]
 fastrpc_device_ioctl+0x138/0xc60 [fastrpc]
 __arm64_sys_ioctl+0xa8/0xec
 invoke_syscall+0x48/0x114
 el0_svc_common.constprop.0+0xd4/0xfc
 do_el0_svc+0x28/0x90
 el0_svc+0x3c/0x130
 el0t_64_sync_handler+0xa4/0x130
 el0t_64_sync+0x18c/0x190
Code: 14000016 f94000a5 eb05029f 54000260 (b94018a6)
---[ end trace 0000000000000000 ]---

Fixes: 5c1b97c7d7b7 ("misc: fastrpc: add support for FASTRPC_IOCTL_MEM_MAP/UNMAP")
Cc: stable@vger.kernel.org
Reported-by: Jan Jablonsky <jjablonsky@snapchat.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220518152353.13058-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1747,17 +1747,18 @@ err_invoke:
 static int fastrpc_req_mem_unmap_impl(struct fastrpc_user *fl, struct fastrpc_mem_unmap *req)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_map *map = NULL, *m;
+	struct fastrpc_map *map = NULL, *iter, *m;
 	struct fastrpc_mem_unmap_req_msg req_msg = { 0 };
 	int err = 0;
 	u32 sc;
 	struct device *dev = fl->sctx->dev;
 
 	spin_lock(&fl->lock);
-	list_for_each_entry_safe(map, m, &fl->maps, node) {
-		if ((req->fd < 0 || map->fd == req->fd) && (map->raddr == req->vaddr))
+	list_for_each_entry_safe(iter, m, &fl->maps, node) {
+		if ((req->fd < 0 || iter->fd == req->fd) && (iter->raddr == req->vaddr)) {
+			map = iter;
 			break;
-		map = NULL;
+		}
 	}
 
 	spin_unlock(&fl->lock);


