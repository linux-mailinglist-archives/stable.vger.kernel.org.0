Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDECC2F536
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfE3EpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbfE3DL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:56 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B8324481;
        Thu, 30 May 2019 03:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185915;
        bh=61rT1CV4mXZHJmbRbNi/SAhsPS3Jn7ms7XsvZb6geZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyftvF3F82i7gqfv1ipENU2boQ/O6DURI0rCJTpxhEAAbMB/oir7B08rSkCtnQIcV
         quDmBgwzGNBXDlP7qZrusXFcsgeLNy2pv8GaeAnlvchTpCLhEtAMTNBOtgeyY9e9bh
         MzxzMXN/qQ5DIshv6ilyHt3MHcqtANQe4HhZl8uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 298/405] misc: fastrpc: consider address offset before sending to DSP
Date:   Wed, 29 May 2019 20:04:56 -0700
Message-Id: <20190530030555.917034721@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80f3afd72bd4149c57daf852905476b43bb47647 ]

While passing address phy address to DSP, take care of the offset
calculated from virtual address vma.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 36d0d5c9cfbad..9996c83ba5cb9 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -667,8 +667,16 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 		pages[i].size = roundup(len, PAGE_SIZE);
 
 		if (ctx->maps[i]) {
+			struct vm_area_struct *vma = NULL;
+
 			rpra[i].pv = (u64) ctx->args[i].ptr;
 			pages[i].addr = ctx->maps[i]->phys;
+
+			vma = find_vma(current->mm, ctx->args[i].ptr);
+			if (vma)
+				pages[i].addr += ctx->args[i].ptr -
+						 vma->vm_start;
+
 		} else {
 			rlen -= ALIGN(args, FASTRPC_ALIGN) - args;
 			args = ALIGN(args, FASTRPC_ALIGN);
-- 
2.20.1



