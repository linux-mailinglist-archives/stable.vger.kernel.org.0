Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373FDA6F42
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfICQbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731109AbfICQ2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530EF238C5;
        Tue,  3 Sep 2019 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528102;
        bh=69HaPlmuyFK7cykVSPEjEiFOabnH7gqUReKQ5BDCWys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qpj5ADqudtknxFPtWlYJkAQYyFOq97jww+vTytjFZWVGGyMXegUA2CqUiXKZtP88I
         av/l5MPs00/geAQf3aacJOTUVii0rM7h4tAItndqoTiUgGH8qOxgtI5z3SdvEfgRWt
         jPmmFIYzg91hoMoj+DEE4h3IjQq0ShaVKkc6lMOw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 110/167] dm crypt: move detailed message into debug level
Date:   Tue,  3 Sep 2019 12:24:22 -0400
Message-Id: <20190903162519.7136-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

[ Upstream commit 7a1cd7238fde6ab367384a4a2998cba48330c398 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-crypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f3dcc7640319e..34f5de13a93d1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -949,6 +949,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *bi = blk_get_integrity(cc->dev->bdev->bd_disk);
+	struct mapped_device *md = dm_table_get_md(ti->table);
 
 	/* From now we require underlying device with our integrity profile */
 	if (!bi || strcasecmp(bi->profile->name, "DM-DIF-EXT-TAG")) {
@@ -968,7 +969,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 
 	if (crypt_integrity_aead(cc)) {
 		cc->integrity_tag_size = cc->on_disk_tag_size - cc->integrity_iv_size;
-		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
+		DMDEBUG("%s: Integrity AEAD, tag size %u, IV size %u.", dm_device_name(md),
 		       cc->integrity_tag_size, cc->integrity_iv_size);
 
 		if (crypto_aead_setauthsize(any_tfm_aead(cc), cc->integrity_tag_size)) {
@@ -976,7 +977,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 			return -EINVAL;
 		}
 	} else if (cc->integrity_iv_size)
-		DMINFO("Additional per-sector space %u bytes for IV.",
+		DMDEBUG("%s: Additional per-sector space %u bytes for IV.", dm_device_name(md),
 		       cc->integrity_iv_size);
 
 	if ((cc->integrity_tag_size + cc->integrity_iv_size) != bi->tag_size) {
-- 
2.20.1

