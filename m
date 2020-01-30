Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C714DD4C
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgA3OvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:51:17 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41233 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727278AbgA3OvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:51:17 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 6405245E;
        Thu, 30 Jan 2020 09:43:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kfhjwZ
        Hn8ZMmPVhJmL8/yWZeHwVH2IcEynv9M6eo/Gg=; b=q9YLCklT0r8Gq8x3Ymw+wV
        WurM05OQOEzqc4hvHetbvHVSdxviVG4DwDMfyOSp4/S8SCaBvRWerVFsPsMl2T9N
        8+pDt3nH6HAYJakN+RNRwbPBrMtb9t/3YzdtQ39UM2tjCte0/6WYcPZO+P4W8WcC
        otKuX2Kx1ZpTERTB4KUmjk+lpIRWcL6ZsvyfvbH0sJEakBoxKJLp3O38R6VUDi+e
        AGLQuqE+wgpcdw5srz++g6EMzl5GYevfCjWAdc/nARHg/MIegJNreA9SyNJxMkNT
        2sTt8GbZZmB4zui2z3xIoQ42ZeM06FjLZVB6FUXG0kUZWf1VuXmQnpm0ktGvHnmA
        ==
X-ME-Sender: <xms:pOsyXlMFmfzuXTnso8DO1SoGi8f6UfnWeTK2bZSzxpFGuvKHu72NkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgepvd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pOsyXl3cSGPxS_IgbjQcDkrzZ2AznpInQ0x8BN4xbz3aXAFWNl4kyA>
    <xmx:pOsyXtXVkjNJon8Ik-gsVJCdS1gAfZiFDyrzqcani1p5g7oRrcjDRg>
    <xmx:pOsyXi_HEFPg7ek5cN3dTfiwAi-8TmWPEFaw_qWC-7FDbZIg8J2V-Q>
    <xmx:pesyXiPAKI5iXudjpRlnmWpB4wXOAYspPjEhJzSedFtK58XNdSjZcQ>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id F027F3280063;
        Thu, 30 Jan 2020 09:43:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: pcrypt - Fix user-after-free on module unload" failed to apply to 4.19-stable tree
To:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:40:07 +0100
Message-ID: <1580395207158126@kroah.com>
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

From 07bfd9bdf568a38d9440c607b72342036011f727 Mon Sep 17 00:00:00 2001
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 19 Nov 2019 17:41:31 +0800
Subject: [PATCH] crypto: pcrypt - Fix user-after-free on module unload

On module unload of pcrypt we must unregister the crypto algorithms
first and then tear down the padata structure.  As otherwise the
crypto algorithms are still alive and can be used while the padata
structure is being freed.

Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..81bbea7f2ba6 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -362,11 +362,12 @@ static int __init pcrypt_init(void)
 
 static void __exit pcrypt_exit(void)
 {
+	crypto_unregister_template(&pcrypt_tmpl);
+
 	pcrypt_fini_padata(pencrypt);
 	pcrypt_fini_padata(pdecrypt);
 
 	kset_unregister(pcrypt_kset);
-	crypto_unregister_template(&pcrypt_tmpl);
 }
 
 subsys_initcall(pcrypt_init);

