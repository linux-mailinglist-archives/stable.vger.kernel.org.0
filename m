Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D44D6AEA1A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjCGRar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCGRaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B067A72A6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD80611A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3638C433EF;
        Tue,  7 Mar 2023 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209945;
        bh=hcFT8IsqXJCj3rGjIlzW3DWcsEEmsg/ZyBSjz7ZayTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQy96cAjgdRBu+lKmBMRegN/iy/MejKsAL5hX/atwf9ypRyWwXN3IcdvgE4YWJWBn
         6nrONq2d1KKKzkzYk58/B6NwpgcgLnqZYbrwMUxIyh4RGNFyw0A78UrK9Q/fsgKq2I
         xuNaBkuMfgumZW9DDhYK/xzVDK6miUfQ/jCjw52I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0382/1001] habanalabs: bugs fixes in timestamps buff alloc
Date:   Tue,  7 Mar 2023 17:52:34 +0100
Message-Id: <20230307170037.951615833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 5e9ae7600d75e..047306e33baad 100644
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



