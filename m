Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8925416B2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377519AbiFGUyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378398AbiFGUvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:51:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B691A200430;
        Tue,  7 Jun 2022 11:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C6036168C;
        Tue,  7 Jun 2022 18:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5E2C385A2;
        Tue,  7 Jun 2022 18:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627331;
        bh=mTdIDoujXMOK+HqZWo1bcLLznZ0mfsHSUpSPn8Lcwd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcS9IG/JxxtNt9fLoQM0vLHeeGwk2M/unOA+ABDIbgOigSLItc7Y7ThDFWc0xuG4D
         0PYGfBfF7vRVF7w1DNtbFBlVkY/cs6ArKibgoZCHdbgcMdXl64jEruURXXWygJNLq1
         mjGkUYcWpvXEdkj0hHiep6dP+f/XYdb8AaMKAw9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, GUO Zihua <guozihua@huawei.com>,
        Stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.17 702/772] ima: remove the IMA_TEMPLATE Kconfig option
Date:   Tue,  7 Jun 2022 19:04:54 +0200
Message-Id: <20220607165009.735183646@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: GUO Zihua <guozihua@huawei.com>

commit 891163adf180bc369b2f11c9dfce6d2758d2a5bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/Kconfig |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

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


