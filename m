Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74812F3529
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392575AbhALQMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:12:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392201AbhALQMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 11:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610467883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7GrmVz3g5PnC6MejB1/FJv7gDiKaAZjfigOkKnsP7RY=;
        b=S206fAItRro+Pa6RZPtQeri6bm89tLHvLj6bwp4uHyNTlVJSRUfrNkNj53FQa1YbMy/nPq
        cceVvS7icaBxmZmUK+xIXFBRyMrGUTlRe5U6mc04FmJwQ7hgsB31qX+e8bzEuneHcIkQ3N
        6iZUXsIcuUBiJh5kDlBADiou/WNK2ac=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-QRriAerDOS-PMJbLFnVxCg-1; Tue, 12 Jan 2021 11:11:21 -0500
X-MC-Unique: QRriAerDOS-PMJbLFnVxCg-1
Received: by mail-wm1-f72.google.com with SMTP id r1so660561wmn.8
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 08:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7GrmVz3g5PnC6MejB1/FJv7gDiKaAZjfigOkKnsP7RY=;
        b=c541JhVpLbiuFT1MIWl1OwqrQ+cR2tn/zxAr4VDJ3+smuXrAuVOzQ0OI0dPdMiOGrL
         xDeX3Fzcho25xc/svlW87VoHseeIr6v1DHTOkPTKv+OuwsPxbA5CFmVLx0+ZhE/Os2Tk
         ZOOQVy5iUGMSGjvA1Xllfo9xg8hJTrzww9CWIC1uS/qJNnJazPm434jZZPI07vGM1Bge
         ExkEDvXAo2gyEio4oaPFiwYttVueB/68GIEzekPg2gklWjH8dm/7IF1PzmzQlNZgEsyC
         6tjdWTd3sCzjlfD+Pkea6sIkrW+kSmR1g45z0trJycWPsgwJ1mat7Ca9h1a/KM2ybBE2
         g25w==
X-Gm-Message-State: AOAM532oLvfrabo+jvZ+IOB/gT/KHYtvSGC1ybVNsofM2ezzvDOs78wd
        ey718JjpPJ/vXeBx/O8D4ilF7fXsP3njBot/YFuhTFDebrVlLpIuBt3bLb9uobmaSufC9BgpjSf
        BnyK4ufadeGa/a+nO
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr4317092wmc.105.1610467879459;
        Tue, 12 Jan 2021 08:11:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9gtHso6LQWZ01xitLmZ7DVGmvVKcp38eals66lkxaBqWRIlrF6/TqEJ1hfzciMThkNCz2Iw==
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr4317069wmc.105.1610467879236;
        Tue, 12 Jan 2021 08:11:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e15sm5765658wrx.86.2021.01.12.08.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 08:11:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2A2DF180322; Tue, 12 Jan 2021 17:11:17 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] crypto: public_key: check that pkey_algo is non-NULL before passing it to strcmp()
Date:   Tue, 12 Jan 2021 17:10:44 +0100
Message-Id: <20210112161044.3101-1-toke@redhat.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When public_key_verify_signature() is called from
asymmetric_key_verify_signature(), the pkey_algo field of struct
public_key_signature will be NULL, which causes a NULL pointer dereference
in the strcmp() check. Fix this by adding a NULL check.

One visible manifestation of this is that userspace programs (such as the
'iwd' WiFi daemon) will be killed when trying to verify a TLS key using the
keyctl(2) interface.

Cc: stable@vger.kernel.org
Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 crypto/asymmetric_keys/public_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..35b09e95a870 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;
-- 
2.30.0

