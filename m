Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBCD681127
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbjA3OKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbjA3OKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857563B0EE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393B1B80E60
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB0BC433D2;
        Mon, 30 Jan 2023 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087824;
        bh=NFeNF9CZQeL5hnoc/VcHAV0VY8/v3LIRZXz3VFMCAKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPbyBx/KQlqQTFZDnej1Ir4+1SkXtBQTp3/9+UkhYbOJZu/w3RFht30AdhtYmhzd9
         lzZ4hQqoaCamL5yRr3mlA9bZ/7JV2BIHyhOoNfPPIYrPz8GOqYuojbMrtQNFSxhG06
         NIY0h3DiSbmUt1p+Y4ySRByNF0XGTZcoy4SHWQL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/204] IB/hfi1: Reserve user expected TIDs
Date:   Mon, 30 Jan 2023 14:49:47 +0100
Message-Id: <20230130134317.260449828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit ecf91551cdd2925ed6d9a9d99074fa5f67b90596 ]

To avoid a race, reserve the number of user expected
TIDs before setup.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328547636.1472310.7419712824785353905.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 212273fcf4dd..236cfc560ab7 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -282,16 +282,13 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	/* Find sets of physically contiguous pages */
 	tidbuf->n_psets = find_phys_blocks(tidbuf, pinned);
 
-	/*
-	 * We don't need to access this under a lock since tid_used is per
-	 * process and the same process cannot be in hfi1_user_exp_rcv_clear()
-	 * and hfi1_user_exp_rcv_setup() at the same time.
-	 */
+	/* Reserve the number of expected tids to be used. */
 	spin_lock(&fd->tid_lock);
 	if (fd->tid_used + tidbuf->n_psets > fd->tid_limit)
 		pageset_count = fd->tid_limit - fd->tid_used;
 	else
 		pageset_count = tidbuf->n_psets;
+	fd->tid_used += pageset_count;
 	spin_unlock(&fd->tid_lock);
 
 	if (!pageset_count)
@@ -400,10 +397,11 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 nomem:
 	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
 		  mapped_pages, ret);
+	/* adjust reserved tid_used to actual count */
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count - tididx;
+	spin_unlock(&fd->tid_lock);
 	if (tididx) {
-		spin_lock(&fd->tid_lock);
-		fd->tid_used += tididx;
-		spin_unlock(&fd->tid_lock);
 		tinfo->tidcnt = tididx;
 		tinfo->length = mapped_pages * PAGE_SIZE;
 
-- 
2.39.0



