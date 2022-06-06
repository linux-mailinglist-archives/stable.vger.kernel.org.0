Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDA53EAA0
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiFFOto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiFFOtn (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 6 Jun 2022 10:49:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C036E8D2
        for <Stable@vger.kernel.org>; Mon,  6 Jun 2022 07:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D437B819FC
        for <Stable@vger.kernel.org>; Mon,  6 Jun 2022 14:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F93C385A9;
        Mon,  6 Jun 2022 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654526978;
        bh=RR5f48tdCk77lrlhaOILuA7DNrSzNpKBgCFg7usRmcE=;
        h=Subject:To:Cc:From:Date:From;
        b=cZlTIaAN/X1tL89aPo4oVgfO5mqmoN7pM/BGZeKDM/X0Dh7t+EoUGMWeGFhIn+Lye
         oGMRaLxuM4ka7Y+5ayxTv2zcWb54tP6VAvb0an+gZjw7clQetw6KSOS8m/Lely0xKq
         EObtTSuLFMLGiMOcjcOVLqxPM6K/NzcgbXCErQQc=
Subject: FAILED: patch "[PATCH] ima: remove the IMA_TEMPLATE Kconfig option" failed to apply to 4.9-stable tree
To:     guozihua@huawei.com, Stable@vger.kernel.org, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 16:49:35 +0200
Message-ID: <1654526975150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 891163adf180bc369b2f11c9dfce6d2758d2a5bd Mon Sep 17 00:00:00 2001
From: GUO Zihua <guozihua@huawei.com>
Date: Thu, 7 Apr 2022 10:16:19 +0800
Subject: [PATCH] ima: remove the IMA_TEMPLATE Kconfig option

The original 'ima' measurement list template contains a hash, defined
as 20 bytes, and a null terminated pathname, limited to 255
characters.  Other measurement list templates permit both larger hashes
and longer pathnames.  When the "ima" template is configured as the
default, a new measurement list template (ima_template=) must be
specified before specifying a larger hash algorithm (ima_hash=) on the
boot command line.

To avoid this boot command line ordering issue, remove the legacy "ima"
template configuration option, allowing it to still be specified on the
boot command line.

The root cause of this issue is that during the processing of ima_hash,
we would try to check whether the hash algorithm is compatible with the
template. If the template is not set at the moment we do the check, we
check the algorithm against the configured default template. If the
default template is "ima", then we reject any hash algorithm other than
sha1 and md5.

For example, if the compiled default template is "ima", and the default
algorithm is sha1 (which is the current default). In the cmdline, we put
in "ima_hash=sha256 ima_template=ima-ng". The expected behavior would be
that ima starts with ima-ng as the template and sha256 as the hash
algorithm. However, during the processing of "ima_hash=",
"ima_template=" has not been processed yet, and hash_setup would check
the configured hash algorithm against the compiled default: ima, and
reject sha256. So at the end, the hash algorithm that is actually used
will be sha1.

With template "ima" removed from the configured default, we ensure that
the default tempalte would at least be "ima-ng" which allows for
basically any hash algorithm.

This change would not break the algorithm compatibility checks for IMA.

Fixes: 4286587dccd43 ("ima: add Kconfig default measurement list template")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index f3a9cc201c8c..7249f16257c7 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -69,10 +69,9 @@ choice
 	  hash, defined as 20 bytes, and a null terminated pathname,
 	  limited to 255 characters.  The 'ima-ng' measurement list
 	  template permits both larger hash digests and longer
-	  pathnames.
+	  pathnames. The configured default template can be replaced
+	  by specifying "ima_template=" on the boot command line.
 
-	config IMA_TEMPLATE
-		bool "ima"
 	config IMA_NG_TEMPLATE
 		bool "ima-ng (default)"
 	config IMA_SIG_TEMPLATE
@@ -82,7 +81,6 @@ endchoice
 config IMA_DEFAULT_TEMPLATE
 	string
 	depends on IMA
-	default "ima" if IMA_TEMPLATE
 	default "ima-ng" if IMA_NG_TEMPLATE
 	default "ima-sig" if IMA_SIG_TEMPLATE
 
@@ -102,19 +100,19 @@ choice
 
 	config IMA_DEFAULT_HASH_SHA256
 		bool "SHA256"
-		depends on CRYPTO_SHA256=y && !IMA_TEMPLATE
+		depends on CRYPTO_SHA256=y
 
 	config IMA_DEFAULT_HASH_SHA512
 		bool "SHA512"
-		depends on CRYPTO_SHA512=y && !IMA_TEMPLATE
+		depends on CRYPTO_SHA512=y
 
 	config IMA_DEFAULT_HASH_WP512
 		bool "WP512"
-		depends on CRYPTO_WP512=y && !IMA_TEMPLATE
+		depends on CRYPTO_WP512=y
 
 	config IMA_DEFAULT_HASH_SM3
 		bool "SM3"
-		depends on CRYPTO_SM3=y && !IMA_TEMPLATE
+		depends on CRYPTO_SM3=y
 endchoice
 
 config IMA_DEFAULT_HASH

