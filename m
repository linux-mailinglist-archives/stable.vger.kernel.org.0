Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9167C9A16
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfJCIlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42461 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E6F521E3E;
        Thu,  3 Oct 2019 04:41:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BqanlR
        SNgD11v/Xyhld/wRkjwEPBvbfCCa9IBdN+bN8=; b=BbzG/g5aQJSCAoa/JWikbE
        tbBV3HIkFonlc9y04exK6oriOQGYmN7q1bxvxDEgnITlnKD3w7yiMSCSJDRn7giI
        Q17WvasDrakfVkNCQLv2bDLm6HmO6SNOwV0cPiJk/Yz06iZSMp6m5599LAG9DLPC
        gPBg6nfwhVnx8G9XFzYDIZOcS0+uQyUzro2Q9hBAGLmKHsBQpbjJbbMCj5q5kR0Q
        fWhb0z14bkt6DwYQVtfywAkLK1KZ+spisyacspwp418dtRvTskHLcqbR1mwEktdt
        RR8w+YTZ5XOMIb6A64hzZcf9FcuYIHWmS8pBOlbJCB6UQUv2L6WEXcXbJ0X9hONw
        ==
X-ME-Sender: <xms:TrSVXUV_UPvXAqCdjdc3qEJEp3epa0rxvBkvDiY_GZ1QAJj91_kwkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepuddt
X-ME-Proxy: <xmx:TrSVXSYJisuzBgXCHtWTRqy3RFzBcRCxpglgEmkEE-LRqKOvSXDwBw>
    <xmx:TrSVXT0GyeT4bXj2WucMZ0es3ueimw9CL3etiPux95u9L0dtaoAM1w>
    <xmx:TrSVXfsAJMj2iH1z517DVaQA8gdW3bSZOuCagf4L_adLIKSGBnO9rQ>
    <xmx:TrSVXftRmtfLloFDL5w7YM1JcvkvAss1MCExcQUA-4tvjYldL7lKXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22AE580063;
        Thu,  3 Oct 2019 04:41:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: detect potential multiref due to corrupted" failed to apply to 4.19-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:39 +0200
Message-ID: <157009209989190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e12a0ce2fa69798194f3a8628baf6edfbd5c548f Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Wed, 21 Aug 2019 22:01:52 +0800
Subject: [PATCH] staging: erofs: detect potential multiref due to corrupted
 images

As reported by erofs-utils fuzzer, currently, multiref
(ondisk deduplication) hasn't been supported for now,
we should forbid it properly.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190821140152.229648-1-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 4d6faaab04f5..60d7c20db87d 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -798,6 +798,7 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
+	err = 0;
 	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_NR_INLINE_PAGEVECS,
 				  cl->pagevec, 0);
 
@@ -819,8 +820,17 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 		DBG_BUGON(pagenr >= nr_pages);
-		DBG_BUGON(pages[pagenr]);
 
+		/*
+		 * currently EROFS doesn't support multiref(dedup),
+		 * so here erroring out one multiref page.
+		 */
+		if (unlikely(pages[pagenr])) {
+			DBG_BUGON(1);
+			SetPageError(pages[pagenr]);
+			z_erofs_onlinepage_endio(pages[pagenr]);
+			err = -EFSCORRUPTED;
+		}
 		pages[pagenr] = page;
 	}
 	z_erofs_pagevec_ctor_exit(&ctor, true);
@@ -828,7 +838,6 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	overlapped = false;
 	compressed_pages = pcl->compressed_pages;
 
-	err = 0;
 	for (i = 0; i < clusterpages; ++i) {
 		unsigned int pagenr;
 
@@ -852,7 +861,12 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 			DBG_BUGON(pagenr >= nr_pages);
-			DBG_BUGON(pages[pagenr]);
+			if (unlikely(pages[pagenr])) {
+				DBG_BUGON(1);
+				SetPageError(pages[pagenr]);
+				z_erofs_onlinepage_endio(pages[pagenr]);
+				err = -EFSCORRUPTED;
+			}
 			pages[pagenr] = page;
 
 			overlapped = true;

