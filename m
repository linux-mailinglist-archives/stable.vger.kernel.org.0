Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934AF6CC481
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjC1PFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjC1PFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B934EC70
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04AA61843
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB180C4339B;
        Tue, 28 Mar 2023 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015828;
        bh=zJDjHXIzK7gDXWGT/oi+MHk0J7JQH6deLI5FX2BAhSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZyLUMJ62LDUBDKuLJ7tj5rBj4Kxrr3ejrQycCcgFi7/RoJXCLB4EiVzOCoUuOprI
         MQF0yFFE5CW6XAW8pPADMl23sDF8DxcYxJcujXEHv2bKVmk81YyCvepfct987Q7kwx
         rx28Gmn+YSFKrEIWyuj43krsPL2Zhpo+ZVw79kzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miao Lihua <441884205@qq.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 191/224] ksmbd: fix wrong signingkey creation when encryption is AES256
Date:   Tue, 28 Mar 2023 16:43:07 +0200
Message-Id: <20230328142625.337435374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 7a891d4b62d62566323676cb0e922ded4f37afe1 upstream.

MacOS and Win11 support AES256 encrytion and it is included in the cipher
array of encryption context. Especially on macOS, The most preferred
cipher is AES256. Connecting to ksmbd fails on newer MacOS clients that
support AES256 encryption. MacOS send disconnect request after receiving
final session setup response from ksmbd. Because final session setup is
signed with signing key was generated incorrectly.
For signging key, 'L' value should be initialized to 128 if key size is
16bytes.

Cc: stable@vger.kernel.org
Reported-by: Miao Lihua <441884205@qq.com>
Tested-by: Miao Lihua <441884205@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -727,8 +727,9 @@ static int generate_key(struct ksmbd_con
 		goto smb3signkey_ret;
 	}
 
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
+	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
 	else
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);


