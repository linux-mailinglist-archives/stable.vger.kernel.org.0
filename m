Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7058D15C62F
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbgBMP6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgBMPZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:13 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869EE246B1;
        Thu, 13 Feb 2020 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607512;
        bh=qryj1/5zCcZu3EilfXkWMgTiTaiwavq8VV7ZrG6NMl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swB0qy+OfvCiZf0BBQTbtg6+Cbe8k4S6I+zTXlVGng7swK+HrQpZo+8MQfc0Wfhsf
         IVOubNXW2iB+KZ4SRH/xWHJSEKCRsVDyGH+FYtilxShcygABwUeDnxr5BAReHQahEX
         6HdSjqrDOPO+VCHuDCTfMtlTmlsW8gPfREFDQ/rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerad Simpson <jbsimpson@gmail.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 056/173] dm crypt: fix benbi IV constructor crash if used in authenticated mode
Date:   Thu, 13 Feb 2020 07:19:19 -0800
Message-Id: <20200213151948.043880074@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

commit 4ea9471fbd1addb25a4d269991dc724e200ca5b5 upstream.

If benbi IV is used in AEAD construction, for example:
  cryptsetup luksFormat <device> --cipher twofish-xts-benbi --key-size 512 --integrity=hmac-sha256
the constructor uses wrong skcipher function and crashes:

 BUG: kernel NULL pointer dereference, address: 00000014
 ...
 EIP: crypt_iv_benbi_ctr+0x15/0x70 [dm_crypt]
 Call Trace:
  ? crypt_subkey_size+0x20/0x20 [dm_crypt]
  crypt_ctr+0x567/0xfc0 [dm_crypt]
  dm_table_add_target+0x15f/0x340 [dm_mod]

Fix this by properly using crypt_aead_blocksize() in this case.

Fixes: ef43aa38063a6 ("dm crypt: add cryptographic data integrity protection (authenticated encryption)")
Cc: stable@vger.kernel.org # v4.12+
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=941051
Reported-by: Jerad Simpson <jbsimpson@gmail.com>
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -485,8 +485,14 @@ static int crypt_iv_essiv_gen(struct cry
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs = crypto_skcipher_blocksize(any_tfm(cc));
-	int log = ilog2(bs);
+	unsigned bs;
+	int log;
+
+	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags))
+		bs = crypto_aead_blocksize(any_tfm_aead(cc));
+	else
+		bs = crypto_skcipher_blocksize(any_tfm(cc));
+	log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
 	 * to get the cipher block count, we use this shift in _gen */


