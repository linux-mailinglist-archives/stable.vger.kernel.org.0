Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2059A130F41
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 10:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgAFJL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 04:11:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgAFJL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 04:11:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so14483212wmj.4
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 01:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM1VzsIoBWrlvP2NSpmP8Omm91/74PDolu8QUxa7RBY=;
        b=PHfUFuWs3i3ma1mpjEb9qrtnLVC9kW21KHrzzxDvU+rdesx+MQRLbBvDHY9Vswfaim
         9+7DQ4VeAw+qDgJ1F+Wpen9QipqAQpgUN0eepmSnIUrxm7Ne/QC7fXwWRxut7oKiqjnk
         VUEGxp+Ppdl4sQ1+WPj5Y0mYQGALbYDuDUwV9W6zvpgnQ46myTbh8adSbjvrbfl8mWiV
         1tnxApjulQRjDIteU9WSlGx7hp6rpVH3CtGsJ8QxB5CM8jvwxlM7riL5ZpL/zbOf0Q2b
         MVTqMZpdSN9Vyygw+1bIxjRE9nsAHdLcNfKk/Ep62I7bjD17uZWyd2z1uJimiaH/cTeQ
         A2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM1VzsIoBWrlvP2NSpmP8Omm91/74PDolu8QUxa7RBY=;
        b=QfarjXvHiGC97ge1ZVt7qIE+ef24+OL5BvpB1Q+EtlM6HBrMNCWrEskPTNWS8nH3kM
         2KJQDyphtgPSjGLvx5QMzI5BLDzLsnzxQ9t5ALQrT0Nnc6Pr9DCxUl+ExJTs79Gve18V
         6n1hyN081ocMhSU9SYKKnQ86z7lmNX4m4f4jEU1JWTRujpPNrvwbLkOqIn0PWxAt6geB
         +D15F7IItiDLAJ+YgVeHvieZlKAsYJRqlv4s7rLwjvNXYivXlrx9bOwGxOI4uZEBjogL
         GSzE0Jstdv7rmk4dGiUT0ube7+nTmUOu4TTkYCwhDIEhCDbQdCIu4TLDGthXv94pCiQI
         k9Cw==
X-Gm-Message-State: APjAAAVkYJeZiQW49DoIAxH0i+LOuGFIuXR+9whKmJiht2/ka/nUoXtb
        IqGD6OvbaJkgF7KIG21Yujg=
X-Google-Smtp-Source: APXvYqw3A8GGKWLMALEJJehnapKa5swreJ+fkS5eACW8yvmxGfiCdW8Bpfd9U8fVifLNTEUEYy3R4g==
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr32074397wmg.74.1578301917037;
        Mon, 06 Jan 2020 01:11:57 -0800 (PST)
Received: from merlot.mazyland.net (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.googlemail.com with ESMTPSA id a14sm76348433wrx.81.2020.01.06.01.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 01:11:56 -0800 (PST)
From:   Milan Broz <gmazyland@gmail.com>
To:     dm-devel@redhat.com
Cc:     Milan Broz <gmazyland@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dm-crypt: Fix benbi IV constructor if used in authenticated mode
Date:   Mon,  6 Jan 2020 10:11:47 +0100
Message-Id: <20200106091147.1485292-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If benbi IV is used in AEAD constructionm for example
  cryptsetup luksFormat <device> --cipher twofish-xts-benbi --key-size 512 --integrity=hmac-sha256
the constructor ues wrong skcipher function and crashes.

 BUG: kernel NULL pointer dereference, address: 00000014
 ...
 EIP: crypt_iv_benbi_ctr+0x15/0x70 [dm_crypt]
 Call Trace:
  ? crypt_subkey_size+0x20/0x20 [dm_crypt]
  crypt_ctr+0x567/0xfc0 [dm_crypt]
  dm_table_add_target+0x15f/0x340 [dm_mod]

This patch fixes the problem with properly using crypt_aead_blocksize() in this case.

Reported in https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=941051

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Cc: <stable@vger.kernel.org> # v4.12+
---
 drivers/md/dm-crypt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f9370a1a574b..fd30143dca91 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -343,8 +343,14 @@ static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
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
-- 
2.25.0.rc1

