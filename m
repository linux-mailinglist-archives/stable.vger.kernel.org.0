Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450BA2F49C7
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbhAMLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:12:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727313AbhAMLMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610536283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A6uXIJTikyi8NRRLgwIPs52yHdAVnddGSD2hRw1TBXA=;
        b=g60SQQX1AeMgUCBTTa681jUjnULayhxXQ6laFkSHtfFD1NxaIXLMBKQDn+MgJs5rHVEora
        e+gCdza6TJc5VkePJnjZFofLmja2RhrJXFQQ5ZwnnwSzEQfQt5bMotvSwphMSFSlprIQ6/
        j3wTUUZlPwe3XIRkB2bfC5krMNXCwwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Az6-8rUnM5yy6OiBe330kQ-1; Wed, 13 Jan 2021 06:11:21 -0500
X-MC-Unique: Az6-8rUnM5yy6OiBe330kQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43E561922961;
        Wed, 13 Jan 2021 11:11:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9206F60BD9;
        Wed, 13 Jan 2021 11:11:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210112161044.3101-1-toke@redhat.com>
References: <20210112161044.3101-1-toke@redhat.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL before passing it to strcmp()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2648794.1610536273.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 13 Jan 2021 11:11:13 +0000
Message-ID: <2648795.1610536273@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm intending to use Tianjia's patch.  Would you like to add a Reviewed-by=
?

David
---
commit 11078a592e6dcea6b9f30e822d3d30e3defc99ca
Author: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Date:   Thu Jan 7 17:28:55 2021 +0800

    X.509: Fix crash caused by NULL pointer
    =

    On the following call path, `sig->pkey_algo` is not assigned
    in asymmetric_key_verify_signature(), which causes runtime
    crash in public_key_verify_signature().
    =

      keyctl_pkey_verify
        asymmetric_key_verify_signature
          verify_signature
            public_key_verify_signature
    =

    This patch simply check this situation and fixes the crash
    caused by NULL pointer.
    =

    Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate ve=
rification")
    Cc: stable@vger.kernel.org # v5.10+
    Reported-by: Tobias Markus <tobias@markus-regensburg.de>
    Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/=
public_key.c
index 8892908ad58c..788a4ba1e2e7 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_ke=
y *pkey,
 	if (ret)
 		goto error_free_key;
 =

-	if (strcmp(sig->pkey_algo, "sm2") =3D=3D 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") =3D=3D 0 &&
+	    sig->data_size) {
 		ret =3D cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;

