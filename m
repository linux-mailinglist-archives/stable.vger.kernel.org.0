Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE552FADFA
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 01:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbhASAOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 19:14:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732664AbhASAOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 19:14:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611015205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=k8uZwZ9l9/9GHM34N72Urrm3zDwDS5163gHM9WUjrbg=;
        b=Rsrzfo9EAxgJKl8r6yCT60Z0ycl/YvqG7PSzNQ90Fa6ZBaG1Te6/hx56WW81qskvJ6hHu3
        TBtF0nIAwOSz6Gtx3mU8g3bnt9Frqe7ycLb8H2zJdxEQAR+3ORnghBMwfe7CLnD75KweVw
        asIIU4hLIbx4bBrcKehfYudRXY/qWu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-Fj6D9-fAOwi5YHvuGOer8Q-1; Mon, 18 Jan 2021 19:13:23 -0500
X-MC-Unique: Fj6D9-fAOwi5YHvuGOer8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AB6F18C89C4;
        Tue, 19 Jan 2021 00:13:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A5A960C9C;
        Tue, 19 Jan 2021 00:13:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     Tobias Markus <tobias@markus-regensburg.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] X.509: Fix crash caused by NULL pointer
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 19 Jan 2021 00:13:19 +0000
Message-ID: <164034.1611015199@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

On the following call path, `sig->pkey_algo` is not assigned
in asymmetric_key_verify_signature(), which causes runtime
crash in public_key_verify_signature().

  keyctl_pkey_verify
    asymmetric_key_verify_signature
      verify_signature
        public_key_verify_signature

This patch simply check this situation and fixes the crash
caused by NULL pointer.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verific=
ation")
Reported-by: Tobias Markus <tobias@markus-regensburg.de>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Tested-by: Jo=C3=A3o Fonseca <jpedrofonseca@ua.pt>
Cc: stable@vger.kernel.org # v5.10+
---

 crypto/asymmetric_keys/public_key.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/p=
ublic_key.c
index 8892908ad58c..788a4ba1e2e7 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key=
 *pkey,
 	if (ret)
 		goto error_free_key;
=20
-	if (strcmp(sig->pkey_algo, "sm2") =3D=3D 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") =3D=3D 0 &&
+	    sig->data_size) {
 		ret =3D cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;

