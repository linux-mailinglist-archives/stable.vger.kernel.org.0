Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43ACC604425
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiJSL7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiJSL6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:58:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB843B9AF;
        Wed, 19 Oct 2022 04:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7D5ACE215A;
        Wed, 19 Oct 2022 09:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A134C433D6;
        Wed, 19 Oct 2022 09:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170261;
        bh=aG1VmPiSOMKW2hCxcFGQZpli/fWumh5/A/cWuJlqu4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urwMgiumImtwKnLLjZSeTCtHje+FFMtdJRfxY720kIwBbiKmDbso00KM0wy1rRfFd
         hmR6mlFEolerOooTMABhl9qf+AawHFNCJt3+zgHtAkpzXAJEXZiWEIb5C+7EVcf+r4
         CUN4h1fWtTcv6h2rVzoxdcLlasMLzO27bSpQyaCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Nam Cao <namcaov@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 561/862] staging: vt6655: fix some erroneous memory clean-up loops
Date:   Wed, 19 Oct 2022 10:30:48 +0200
Message-Id: <20221019083314.776142674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index bab08a40fe66..d76f65756db8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -583,7 +583,7 @@ static int device_init_rd0_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD0Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -629,7 +629,7 @@ static int device_init_rd1_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD1Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -734,7 +734,7 @@ static int device_init_td1_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD1Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1



