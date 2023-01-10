Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3445F6649B4
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbjAJSX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbjAJSW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0E4103C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B624FB8189A
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC81C433EF;
        Tue, 10 Jan 2023 18:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374853;
        bh=cYrIxgrRHUpJln9EP7po+IDAjvE9X2NcKotwwqQ7jCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BB1x0x/ZREZiljZXPQ3ByVH2nqlYrI+TGqKPYWFtzzNuMwKeuOg59w6QbNM0eshBq
         RZL4tQLLGe8Y92aEEeCazFobqrZJLD0q77k/9ozDAxOuLjykvpCcHdiJ7RADwHEsAp
         c2SAQpWc44AE4XndFkVDSSYoLAMqf5agV3OGawvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, William Liu <will@willsroot.io>,
        =?UTF-8?q?Hrvoje=20Mi=C5=A1eti=C4=87?= <misetichrvoje@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 155/159] ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob
Date:   Tue, 10 Jan 2023 19:05:03 +0100
Message-Id: <20230110180023.484149449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Liu <will@willsroot.io>

commit 797805d81baa814f76cf7bdab35f86408a79d707 upstream.

"nt_len - CIFS_ENCPWD_SIZE" is passed directly from
ksmbd_decode_ntlmssp_auth_blob to ksmbd_auth_ntlmv2. Malicious requests
can set nt_len to less than CIFS_ENCPWD_SIZE, which results in a negative
number (or large unsigned value) used for a subsequent memcpy in
ksmbd_auth_ntlvm2 and can cause a panic.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: William Liu <will@willsroot.io>
Signed-off-by: Hrvoje Mišetić <misetichrvoje@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -322,7 +322,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struc
 	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
 	dn_len = le16_to_cpu(authblob->DomainName.Length);
 
-	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len)
+	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len ||
+	    nt_len < CIFS_ENCPWD_SIZE)
 		return -EINVAL;
 
 	/* TODO : use domain name that imported from configuration file */


