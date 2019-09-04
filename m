Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2C9A9082
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbfIDSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbfIDSKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E615206B8;
        Wed,  4 Sep 2019 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620606;
        bh=k9djja5ly5uwE2OFtHOxsuV0pvkx9VzB3lHm8awq8tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtDKsixV09BwaTW0FTgShtMyHOA8OunyFnCTU1d9jzhnmVz3ov+9RXEsjbTQlNdkl
         hVY+BXxAbgZ8d6UYV+WGIOmLoloVQO7kh8TgidsRXADbLyCEam+MvmILG/D6LPwKTT
         xLD709nR7Y+HEHbMZwAIG36WsS1bKBzqVOStQgUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 028/143] habanalabs: fix DRAM usage accounting on context tear down
Date:   Wed,  4 Sep 2019 19:52:51 +0200
Message-Id: <20190904175315.161061753@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8113756ba27298d6e95403c087dc5881b419a99 ]

The patch fix the DRAM usage accounting by adding a missing update of
the DRAM memory consumption, when a context is being torn down without an
organized release of the allocated memory.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index 693877e37fd87..924a438ba9736 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -1629,6 +1629,8 @@ void hl_vm_ctx_fini(struct hl_ctx *ctx)
 			dev_dbg(hdev->dev,
 				"page list 0x%p of asid %d is still alive\n",
 				phys_pg_list, ctx->asid);
+			atomic64_sub(phys_pg_list->total_size,
+					&hdev->dram_used_mem);
 			free_phys_pg_pack(hdev, phys_pg_list);
 			idr_remove(&vm->phys_pg_pack_handles, i);
 		}
-- 
2.20.1



