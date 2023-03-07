Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3796AEF3C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjCGSWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjCGSVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:21:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E367B3726
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E5B6B819C8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A318C433EF;
        Tue,  7 Mar 2023 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212934;
        bh=FozaXj21IlAEggRWxF9BwTaGNkJOs/pXg16euC6ZFhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6vEXb2akl5S7gDgKjZ54odV36RWvCd+nyXlpYZt70Rfz2zJBchg7kJGK9bZXMTRz
         G3h6ZCAn5KjU71jedQZYp8nUpOyehYSy9dxFjNyS83ynd62RLRSiTgmdBpF+0jcmcN
         ei8obJKLhnm3P0lrsbbCbxpW1BTU1BclYDLJXiEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/885] habanalabs: bugs fixes in timestamps buff alloc
Date:   Tue,  7 Mar 2023 17:54:08 +0100
Message-Id: <20230307170015.789993590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 1693fef9e95dbe8ab767d208a02328fff13fbb94 ]

use argument instead of fixed GFP value for allocation
in Timestamps buffers alloc function.
change data type of size to size_t.

Fixes: 9158bf69e74f ("habanalabs: Timestamps buffers registration")
Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index ef28f3b37b932..a49038da3f6d0 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -2089,12 +2089,13 @@ static int hl_ts_mmap(struct hl_mmap_mem_buf *buf, struct vm_area_struct *vma, v
 static int hl_ts_alloc_buf(struct hl_mmap_mem_buf *buf, gfp_t gfp, void *args)
 {
 	struct hl_ts_buff *ts_buff = NULL;
-	u32 size, num_elements;
+	u32 num_elements;
+	size_t size;
 	void *p;
 
 	num_elements = *(u32 *)args;
 
-	ts_buff = kzalloc(sizeof(*ts_buff), GFP_KERNEL);
+	ts_buff = kzalloc(sizeof(*ts_buff), gfp);
 	if (!ts_buff)
 		return -ENOMEM;
 
-- 
2.39.2



