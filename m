Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1474A4FD90F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355851AbiDLH3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346467AbiDLHWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5212C113;
        Mon, 11 Apr 2022 23:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18015B81B4E;
        Tue, 12 Apr 2022 06:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A562C385A1;
        Tue, 12 Apr 2022 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746781;
        bh=wfOWnBKDHMzsdOEB9VAuP1Z+xiSv2G5c7JafDdG7zx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZnd/jEMLi8++7Illd/DLKRjak7Lsr+ZmjT6Y3fE/KZSfi2j+2Yr4FKxQma4/yCyC
         HI7GTo+Jc0OlTYCkqKTJi41K/xz1uq7aEHnv3v8MIyX06yTnajI+PbHc9KKjqp49oa
         21KxcgrxWZqiJH1AwSTjGUuwFxGIGz5pwJv0WPlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 129/285] habanalabs: reject host map with mmu disabled
Date:   Tue, 12 Apr 2022 08:29:46 +0200
Message-Id: <20220412062947.388797867@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 9a79e3e4a3637c07352d9723b825490a1b04391f ]

This is not something we can do a workaround. It is clearly an error
and we should notify the user that it is an error.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 30 +++++++++----------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 9bd626a00de3..03416b4ee0b7 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1973,16 +1973,15 @@ static int export_dmabuf_from_handle(struct hl_ctx *ctx, u64 handle, int flags,
 static int mem_ioctl_no_mmu(struct hl_fpriv *hpriv, union hl_mem_args *args)
 {
 	struct hl_device *hdev = hpriv->hdev;
-	struct hl_ctx *ctx = hpriv->ctx;
 	u64 block_handle, device_addr = 0;
+	struct hl_ctx *ctx = hpriv->ctx;
 	u32 handle = 0, block_size;
-	int rc, dmabuf_fd = -EBADF;
+	int rc;
 
 	switch (args->in.op) {
 	case HL_MEM_OP_ALLOC:
 		if (args->in.alloc.mem_size == 0) {
-			dev_err(hdev->dev,
-				"alloc size must be larger than 0\n");
+			dev_err(hdev->dev, "alloc size must be larger than 0\n");
 			rc = -EINVAL;
 			goto out;
 		}
@@ -2003,15 +2002,14 @@ static int mem_ioctl_no_mmu(struct hl_fpriv *hpriv, union hl_mem_args *args)
 
 	case HL_MEM_OP_MAP:
 		if (args->in.flags & HL_MEM_USERPTR) {
-			device_addr = args->in.map_host.host_virt_addr;
-			rc = 0;
+			dev_err(hdev->dev, "Failed to map host memory when MMU is disabled\n");
+			rc = -EPERM;
 		} else {
-			rc = get_paddr_from_handle(ctx, &args->in,
-							&device_addr);
+			rc = get_paddr_from_handle(ctx, &args->in, &device_addr);
+			memset(args, 0, sizeof(*args));
+			args->out.device_virt_addr = device_addr;
 		}
 
-		memset(args, 0, sizeof(*args));
-		args->out.device_virt_addr = device_addr;
 		break;
 
 	case HL_MEM_OP_UNMAP:
@@ -2019,20 +2017,14 @@ static int mem_ioctl_no_mmu(struct hl_fpriv *hpriv, union hl_mem_args *args)
 		break;
 
 	case HL_MEM_OP_MAP_BLOCK:
-		rc = map_block(hdev, args->in.map_block.block_addr,
-				&block_handle, &block_size);
+		rc = map_block(hdev, args->in.map_block.block_addr, &block_handle, &block_size);
 		args->out.block_handle = block_handle;
 		args->out.block_size = block_size;
 		break;
 
 	case HL_MEM_OP_EXPORT_DMABUF_FD:
-		rc = export_dmabuf_from_addr(ctx,
-				args->in.export_dmabuf_fd.handle,
-				args->in.export_dmabuf_fd.mem_size,
-				args->in.flags,
-				&dmabuf_fd);
-		memset(args, 0, sizeof(*args));
-		args->out.fd = dmabuf_fd;
+		dev_err(hdev->dev, "Failed to export dma-buf object when MMU is disabled\n");
+		rc = -EPERM;
 		break;
 
 	default:
-- 
2.35.1



