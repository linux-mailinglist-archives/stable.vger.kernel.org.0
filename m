Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94914DCF3
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgA3Onx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:43:53 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36879 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgA3Onw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:43:52 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 72D85391;
        Thu, 30 Jan 2020 09:43:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=K0OOl1
        FZVTGKtPNR3oOLvSJF5t9fDc7xAFCgZeRgzzI=; b=dHdMv3V0+Xszj4ZKMIRWpd
        cU535ZYQwFYaJkrrq8gegS0VFrH/naTr9vYgsVUoST2FNIVL2mL6C/cv87WpzGop
        RtZ8eLP6KlRijYMKNYTKQ2JbuL89zSIm1/fSZzAw9cKjYp6Tx3dxUTPZeG86mr9/
        AUldiij7xdMsoGajk7VzY0ajLak/AFbjXhSkH5u7tBaHOPbEzd1SvuCnTAqrujF4
        3UwDtFg05SBQxuWDGwmJEHnWGzvibQ4Dkc0WDSrRzpeaOCXFFUsSabz4VLbddS5B
        K6mHaidDtsKFYTbynaL1R9raP8TG42Z/pQMHjtD/n8JWpRPNXoh5WNuqmxUwxZaQ
        ==
X-ME-Sender: <xms:pusyXtSGqX7235NjVYWLgJsVx1ehX-xkU0d_ebz6pMLh3KsUYhBPHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgephe
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:p-syXjHNayKc-Ljmm4X1_tvYBIXYhiLTbSHjKl8X5b4I4aVfZjNgtA>
    <xmx:p-syXlltazjHUGi3Kp-7pToD1vrTWudHbAXg9MA9At1Fu3wqK6__jA>
    <xmx:p-syXm0km17LfqeKcehr2bOlweDFJGO1FOIA5MyY2GV0WSIVEUTaig>
    <xmx:p-syXgFOoEBr07CtThrE6Ibp5AIGmE_enB5yuyqSkNvd6z6JrlDtDQ>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 900A03060986;
        Thu, 30 Jan 2020 09:43:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: pcrypt - Fix user-after-free on module unload" failed to apply to 4.14-stable tree
To:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:40:08 +0100
Message-ID: <158039520825514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

