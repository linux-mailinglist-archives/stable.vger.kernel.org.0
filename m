Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4362B64C6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgKQNtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732390AbgKQNdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89DF9207BC;
        Tue, 17 Nov 2020 13:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620000;
        bh=tj7CpmiYuztjJCVbxzgEbijWI2DDoAEPu6rbYaOk9WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ua+0c1SVTMDXtJzvsEHf/J0bmj/keVluylX7PDk2V9WeWZKpom56n60bYktc9tmVP
         VDO24Wof+EeC/5/Na1YJR5BHN1hjLzIcIGgACO/t11YLINmpa4/wStoIdjei4F09yd
         ZdnhWMd88UqaSxVe2Wn3jB5s3aBJfc4qnEEfPnz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Pujin Shi <shipujin.t@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.9 075/255] scsi: ufs: Fix missing brace warning for old compilers
Date:   Tue, 17 Nov 2020 14:03:35 +0100
Message-Id: <20201117122142.601466285@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pujin Shi <shipujin.t@gmail.com>

commit 6500251e590657066a227dce897a0392f302af24 upstream.

For older versions of gcc, the array = {0}; will cause warnings:

drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_crypto_keyslot_program':
drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^
drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: (near initialization for 'cfg.reg_val') [-Wmissing-braces]
drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_clear_keyslot':
drivers/scsi/ufs/ufshcd-crypto.c:103:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^
2 warnings generated

Link: https://lore.kernel.org/r/20201002063538.1250-1-shipujin.t@gmail.com
Fixes: 70297a8ac7a7 ("scsi: ufs: UFS crypto API")
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd-crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -59,7 +59,7 @@ static int ufshcd_crypto_keyslot_program
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
 	int cap_idx = -1;
-	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg = {};
 	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
@@ -100,7 +100,7 @@ static int ufshcd_clear_keyslot(struct u
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
-	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg = {};
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }


