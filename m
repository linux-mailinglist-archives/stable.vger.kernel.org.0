Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A189614DCF5
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgA3On5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:43:57 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36083 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgA3On4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:43:56 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 3C23830C;
        Thu, 30 Jan 2020 09:43:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zhf7t+
        WMMiMELHks6uXJz3qvUbg4G7xYDuz9623dr24=; b=ECYq3M9tERRwAt6wm6MQD+
        S21FgWkAktT5RrPsOpxfJ0bEJRMFsxoVFjZMiRZ6SWMmrWktaTIjRl/+UogbVtaG
        gXDJ7+p/rWHRgvrFRIIhN2C3Q6qSbb8wsA43+uYsSJrXEAexF9OgzKDD4Wfona7p
        /eF8FKp/FhNgh7+tzZAFOvs4d5zjT+yrmuim+/teQit/gHBlyDc4qM1WSkmK1YOX
        cHuRyKlZGzk5XQhiHu2K32hAF7FEf3hQf250z8jjYyvVJqdX48jMPJH1kPcIiWYV
        B57L4BuE/BcqzxFzz9F1xyfxXqVKKCBOArpRTd4QSq3uzEZrl+j6VXVKUMglypVw
        ==
X-ME-Sender: <xms:q-syXjEMGoK33fueDaUfu-vHmaPXCTdcBWX8YLZGw2OQikUJGKNcRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgepje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:q-syXoXWqmjP2ypwf9roMTVHpUOQTj2k9-_THeFs-WsgNBje9I20UA>
    <xmx:q-syXlyq0VfmzA17mgk_dwOFLa_CjYdd2OGFaIT8HP7r0lJtUWEcXw>
    <xmx:q-syXgpkETW23r0mt39eBocmBy7goA4xVOPOxffWue6Kb1xyoDDwjg>
    <xmx:q-syXi-RSM-xt9pVnTDRRlm_xtXNOvqbICE8sI2lh_7Y3mFRLjxN6g>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C1E03060986;
        Thu, 30 Jan 2020 09:43:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: pcrypt - Fix user-after-free on module unload" failed to apply to 4.9-stable tree
To:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:40:10 +0100
Message-ID: <158039521025123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

