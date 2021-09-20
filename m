Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4CD412176
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350548AbhITSGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356498AbhITSDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A43F6323E;
        Mon, 20 Sep 2021 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158210;
        bh=PALLLA4cNsd3d3iksZIZjOimC2VkR4FqFNZeNO2n+SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sndkmA8wGtuUJMfFZol60/AVxRu0EAUNBSdxvmPbqhtiIUV9jSvgs8EeuMMW0pa4s
         xcdimth6+DWNBCvuxF6y4BBOYVNpZwxr4C1uDABKNtzsjMX1NVXuVCv9yJmJwMVqLq
         aA9QlCQEx6NrSpmoRdGDvfrUzB/xFTOFSkpOFHQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhenwei pi <pizhenwei@bytedance.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 018/260] crypto: public_key: fix overflow during implicit conversion
Date:   Mon, 20 Sep 2021 18:40:36 +0200
Message-Id: <20210920163931.741126042@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

commit f985911b7bc75d5c98ed24d8aaa8b94c590f7c6a upstream.

Hit kernel warning like this, it can be reproduced by verifying 256
bytes datafile by keyctl command, run script:
RAWDATA=rawdata
SIGDATA=sigdata

modprobe pkcs8_key_parser

rm -rf *.der *.pem *.pfx
rm -rf $RAWDATA
dd if=/dev/random of=$RAWDATA bs=256 count=1

openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
  -subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=xx.com/emailAddress=yy@xx.com"

KEY_ID=`openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER | keyctl \
  padd asymmetric 123 @s`

keyctl pkey_sign $KEY_ID 0 $RAWDATA enc=pkcs1 hash=sha1 > $SIGDATA
keyctl pkey_verify $KEY_ID 0 $RAWDATA $SIGDATA enc=pkcs1 hash=sha1

Then the kernel reports:
 WARNING: CPU: 5 PID: 344556 at crypto/rsa-pkcs1pad.c:540
   pkcs1pad_verify+0x160/0x190
 ...
 Call Trace:
  public_key_verify_signature+0x282/0x380
  ? software_key_query+0x12d/0x180
  ? keyctl_pkey_params_get+0xd6/0x130
  asymmetric_key_verify_signature+0x66/0x80
  keyctl_pkey_verify+0xa5/0x100
  do_syscall_64+0x35/0xb0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The reason of this issue, in function 'asymmetric_key_verify_signature':
'.digest_size(u8) = params->in_len(u32)' leads overflow of an u8 value,
so use u32 instead of u8 for digest_size field. And reorder struct
public_key_signature, it saves 8 bytes on a 64-bit machine.

Cc: stable@vger.kernel.org
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/public_key.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -38,9 +38,9 @@ extern void public_key_free(struct publi
 struct public_key_signature {
 	struct asymmetric_key_id *auth_ids[2];
 	u8 *s;			/* Signature */
-	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;		/* Number of bytes in digest */
+	u32 s_size;		/* Number of bytes in signature */
+	u32 digest_size;	/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
 	const char *encoding;


