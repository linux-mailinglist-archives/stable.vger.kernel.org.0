Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831A04B47EC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiBNJll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244569AbiBNJke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:40:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9994EAE6F;
        Mon, 14 Feb 2022 01:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4CAFB80DA9;
        Mon, 14 Feb 2022 09:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184D8C340E9;
        Mon, 14 Feb 2022 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831329;
        bh=nFiWx+3e3Mkbt3NrtocNjgORR1FvmAKTE3TtK8vz04g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzLHFpBWwgfdy7IXnbGMKjC4DPOsvDMj8eFjxFiwhLT70bsGZffCcnVdIlIOvsTpm
         FkrvpYfKP1SEqAKKN3HHLLOrUE/qhKShseU6e8cHWfbHAfsuPXqJPS3jmNoL5lRRqi
         Ihf8VvSjBHrRR1CtOTq2n3pC3cgqYirKQimu1sjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 02/71] ima: Remove ima_policy file before directory
Date:   Mon, 14 Feb 2022 10:25:30 +0100
Message-Id: <20220214092452.105351407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit f7333b9572d0559e00352a926c92f29f061b4569 upstream.

The removal of ima_dir currently fails since ima_policy still exists, so
remove the ima_policy file before removing the directory.

Fixes: 4af4662fa4a9 ("integrity: IMA policy")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -494,12 +494,12 @@ int __init ima_fs_init(void)
 
 	return 0;
 out:
+	securityfs_remove(ima_policy);
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_symlink);
 	securityfs_remove(ima_dir);
-	securityfs_remove(ima_policy);
 	return -1;
 }


