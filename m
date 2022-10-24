Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3AB60B5FF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiJXSpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiJXSpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:45:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36BCAC498;
        Mon, 24 Oct 2022 10:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F614CE13CF;
        Mon, 24 Oct 2022 12:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B69FC433C1;
        Mon, 24 Oct 2022 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614384;
        bh=l3lOmvb8DxNeJCwa8Zo59caxbNTlaKKRdNSZFh4rEMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCblZg3g/HaucYtS6HBQZ9tDgdjRqjNy+C3g27SJqrghLgghPnT14DH4Ts1NpRlcq
         BN1UkJtGbFuVC9RdN4KbmZiGTjgsgzcHvrRAiUdYANRlVVhfNL9sOM6ieKEJTwMTHv
         HAcwLfSkdoooTbnetCvzd/AoWIUbyLczT/zNWX18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Nam Cao <namcaov@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/390] staging: vt6655: fix some erroneous memory clean-up loops
Date:   Mon, 24 Oct 2022 13:30:37 +0200
Message-Id: <20221024113033.029480414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit 2a2db520e3ca5aafba7c211abfd397666c9b5f9d ]

In some initialization functions of this driver, memory is allocated with
'i' acting as an index variable and increasing from 0. The commit in
"Fixes" introduces some clean-up codes in case of allocation failure,
which free memory in reverse order with 'i' decreasing to 0. However,
there are some problems:
  - The case i=0 is left out. Thus memory is leaked.
  - In case memory allocation fails right from the start, the memory
    freeing loops will start with i=-1 and invalid memory locations will
    be accessed.

One of these loops has been fixed in commit c8ff91535880 ("staging:
vt6655: fix potential memory leak"). Fix the remaining erroneous loops.

Link: https://lore.kernel.org/linux-staging/Yx9H1zSpxmNqx6Xc@kadam/
Fixes: 5341ee0adb17 ("staging: vt6655: check for memory allocation failures")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Signed-off-by: Nam Cao <namcaov@gmail.com>
Link: https://lore.kernel.org/r/20220912170429.29852-1-namcaov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vt6655/device_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 09ab6d6f2429..0dd70173a754 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -564,7 +564,7 @@ static int device_init_rd0_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD0Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -610,7 +610,7 @@ static int device_init_rd1_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD1Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -715,7 +715,7 @@ static int device_init_td1_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD1Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1



