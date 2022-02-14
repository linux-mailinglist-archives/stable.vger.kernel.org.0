Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5924B47B3
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbiBNJrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbiBNJqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A548717B3;
        Mon, 14 Feb 2022 01:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C82236102D;
        Mon, 14 Feb 2022 09:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC86C340E9;
        Mon, 14 Feb 2022 09:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831554;
        bh=4RIDEAq+c22nmmG4y8cxqHGvT85mUiWcK7yNYU3i7IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqJXK3/nkfETofJ1CeDtn3sUOWG+pdjyCrsnsoK9TWMgoufkPBpSHRI3W2krsc/Bl
         g6Y5cQ0mW/5JR+Wind0zlxFToW0usSLBoH6RUNcryzVJIcRIPjN/4wcIz6iRpwg4FX
         0GzyRFbAv6ni8945ZoiRYdpcYyTQ41aNJ9YQgt5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 002/116] ima: Remove ima_policy file before directory
Date:   Mon, 14 Feb 2022 10:25:01 +0100
Message-Id: <20220214092458.753440143@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
@@ -496,12 +496,12 @@ int __init ima_fs_init(void)
 
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


