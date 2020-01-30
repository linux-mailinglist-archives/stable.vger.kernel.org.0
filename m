Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5047014DCF4
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgA3Ony (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:43:54 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36793 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgA3Ony (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:43:54 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id D955148D;
        Thu, 30 Jan 2020 09:43:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rKgx6U
        yfJlQXVDAcccosMPmi3gX2YQBeORCr95GYIEA=; b=qfL4SOmmKg+XaoXxWNm1g/
        5DtsPUV7zqxlmjrWgWWi5VHPp0PxCZY4oDVNC4tBv8KQj1Qg0qsNdkI5zp+PImUu
        b4CmXJvRI/zoB4+YkOrfWiLlJ/Xg7mrtv08qhfv5RtIbNJP1AWEC2pGA777GWL55
        LsAU5ILSM7KZ+n3zl7VFDnR1kwTvK2Xb6RMUsRU7c+SoEf7XjipCnGBaebq27NDL
        m39mNuM1Q2XMcIkvQli2RgOPCUUNY7OdsSHOwp8UpCw+WZliPv3l+I7BeMnLTcW6
        Mjkcw6x8IPmifl23kVkV0T1hgd0s41UF1uua9cUldxml9c7ZwONZ2iLe0d/ZDwbw
        ==
X-ME-Sender: <xms:qesyXoeYNimuBBCk03UqynXBFKWQtZSK7Q17xz30WL2X6D-wYMkeXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgephe
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qesyXucw4egYtPZKkq4O3dUngLBQahsyMUNs6QEHmX_hVdUmVb7yDA>
    <xmx:qesyXkhJcKINwh2XJK7gneE-LeyZowcuWOUMJ0Y7wJL1Ch9FHccyVQ>
    <xmx:qesyXiTtBBkUNMYJ-rqUzs29_1QjVFjvU7UcBEHx91RUtmsYRn3nJw>
    <xmx:qesyXjqg7f5F_Nf8nzRbGpZOvpT8WN0t0fLqpEUTHjRdDEOJHFPr7g>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id E284D3280065;
        Thu, 30 Jan 2020 09:43:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: pcrypt - Fix user-after-free on module unload" failed to apply to 4.4-stable tree
To:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:40:09 +0100
Message-ID: <15803952099186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

