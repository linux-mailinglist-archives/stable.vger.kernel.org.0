Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7534E1A9BC2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393926AbgDOLHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:07:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46985 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896750AbgDOLHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:07:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 31ED75C0099;
        Wed, 15 Apr 2020 07:07:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZQYsIg
        N6V2WO0/Jd52HUNUYpSbQgONtVq4D6jsrKChY=; b=UGJYD1PWUYwqlM4h6Wmjif
        /4xB4AkxafnfClR8P8C7PQKVAwfcKGONFgbXp898y4a8nh5afwonXPZ/DMHfXfgl
        ZqIhOkUuQlMg5q6yMMELZEZggT0Z/396/gu5ghnQtSdmrGD/X78KtfQXXhy2aTSs
        7C4MOWcwPWPte4IDRVUo7iM2SAAtFy0PTuJEsCKmEn+S/qnARqDCruvEW6IhiY6t
        v+tSiP7HKG8YiacEapWk22Tjs2NvC/fdI9TbZ/eAAAYudw0rCV80ts3ggVJH7144
        1xoVTg6x0WvWT8f8lvqqMwHzMIKCuQBfGpo9KhtAOwnt7D2oxldo9bAD7eYGTr2g
        ==
X-ME-Sender: <xms:3uqWXvr52lYGC09a04Qny1CvupUy4g4pplVXzDylkFYrVAp9V8YfGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepleenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3uqWXsDVbL62RsBcElnosTyMCg0yDP5Z-PQbtQFYW2txE5rmWFwFzw>
    <xmx:3uqWXmzdxTwL5NT8o8MntnXu7f1cXlnSPYX2g-eXY6svrXvEMzSzZQ>
    <xmx:3uqWXtaxKPSGpY5JpJdPG3QGsmxZnwz4aV7g6nG4pwdLd1FkvNFWWw>
    <xmx:3uqWXtjelzxqC3mnGz-C1xAAyXDOkrcHQky-XsD72jUj44ByCYzFGw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8BEC306005E;
        Wed, 15 Apr 2020 07:07:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - only try to map auth tag if needed" failed to apply to 4.19-stable tree
To:     gilad@benyossef.com, geert+renesas@glider.be,
        herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:07:08 +0200
Message-ID: <158694882829120@kroah.com>
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

From 504e84abec7a635b861afd8d7f92ecd13eaa2b09 Mon Sep 17 00:00:00 2001
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Wed, 29 Jan 2020 16:37:55 +0200
Subject: [PATCH] crypto: ccree - only try to map auth tag if needed

Make sure to only add the size of the auth tag to the source mapping
for encryption if it is an in-place operation. Failing to do this
previously caused us to try and map auth size len bytes from a NULL
mapping and crashing if both the cryptlen and assoclen are zero.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index b938ceae7ae7..885347b5b372 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1109,9 +1109,11 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	}
 
 	size_to_map = req->cryptlen + areq_ctx->assoclen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
+	/* If we do in-place encryption, we also need the auth tag */
+	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) &&
+	   (req->src == req->dst)) {
 		size_to_map += authsize;
-
+	}
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,

