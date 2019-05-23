Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CAD2890D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392132AbfEWTa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391536AbfEWTa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E002184E;
        Thu, 23 May 2019 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639826;
        bh=iT0JiRhgEl7xmndYDeW3TeBo3b3Aw2K9jQGUo4EXg6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7/OAbGqvmXL/XmH6CoyDQ5UdO+zG744OamUV0R3cxi5SrG4v630KnSsDXZhn4KGa
         zdREg83ckXGmq46lrHWQRs6b2H7a6mS4A4pLNuJhn3hoH8EEUvxHAA8xy7UaRaOM69
         7Iq1bghpeo4vrugp0XHGWMDGZBl1urtHU/xomyQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 106/122] dm crypt: move detailed message into debug level
Date:   Thu, 23 May 2019 21:07:08 +0200
Message-Id: <20190523181719.428392253@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

commit 7a1cd7238fde6ab367384a4a2998cba48330c398 upstream.

The information about tag size should not be printed without debug info
set. Also print device major:minor in the error message to identify the
device instance.

Also use rate limiting and debug level for info about used crypto API
implementaton.  This is important because during online reencryption
the existing message saturates syslog (because we are moving hotzone
across the whole device).

Cc: stable@vger.kernel.org
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -949,6 +949,7 @@ static int crypt_integrity_ctr(struct cr
 {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *bi = blk_get_integrity(cc->dev->bdev->bd_disk);
+	struct mapped_device *md = dm_table_get_md(ti->table);
 
 	/* From now we require underlying device with our integrity profile */
 	if (!bi || strcasecmp(bi->profile->name, "DM-DIF-EXT-TAG")) {
@@ -968,7 +969,7 @@ static int crypt_integrity_ctr(struct cr
 
 	if (crypt_integrity_aead(cc)) {
 		cc->integrity_tag_size = cc->on_disk_tag_size - cc->integrity_iv_size;
-		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
+		DMDEBUG("%s: Integrity AEAD, tag size %u, IV size %u.", dm_device_name(md),
 		       cc->integrity_tag_size, cc->integrity_iv_size);
 
 		if (crypto_aead_setauthsize(any_tfm_aead(cc), cc->integrity_tag_size)) {
@@ -976,7 +977,7 @@ static int crypt_integrity_ctr(struct cr
 			return -EINVAL;
 		}
 	} else if (cc->integrity_iv_size)
-		DMINFO("Additional per-sector space %u bytes for IV.",
+		DMDEBUG("%s: Additional per-sector space %u bytes for IV.", dm_device_name(md),
 		       cc->integrity_iv_size);
 
 	if ((cc->integrity_tag_size + cc->integrity_iv_size) != bi->tag_size) {
@@ -1891,7 +1892,7 @@ static int crypt_alloc_tfms_skcipher(str
 	 * algorithm implementation is used.  Help people debug performance
 	 * problems by logging the ->cra_driver_name.
 	 */
-	DMINFO("%s using implementation \"%s\"", ciphermode,
+	DMDEBUG_LIMIT("%s using implementation \"%s\"", ciphermode,
 	       crypto_skcipher_alg(any_tfm(cc))->base.cra_driver_name);
 	return 0;
 }
@@ -1911,7 +1912,7 @@ static int crypt_alloc_tfms_aead(struct
 		return err;
 	}
 
-	DMINFO("%s using implementation \"%s\"", ciphermode,
+	DMDEBUG_LIMIT("%s using implementation \"%s\"", ciphermode,
 	       crypto_aead_alg(any_tfm_aead(cc))->base.cra_driver_name);
 	return 0;
 }


