Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A4FB1F3E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389354AbfIMNRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389067AbfIMNRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:21 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16714206A5;
        Fri, 13 Sep 2019 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380640;
        bh=tyz9EDC0TzptZ+ClxDdX/l0wChzdsOy41JFyVkHDeqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjTTqmIAAcfmXucD1pVGoGgEtGOzYEoIQX5aNRvfA+vJ0d0piBlsGXGsRvh3wfUcN
         94RiSLZD8DxQ7SxfEpqGTCxD4zKr11tWKt28u92QzLBaVImVbHtzWoN/2cEjKxIY2M
         zaKkEdBqir89CNeXWJnTIPn4LcIkucuBxrrYr11s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/190] dm crypt: move detailed message into debug level
Date:   Fri, 13 Sep 2019 14:06:26 +0100
Message-Id: <20190913130610.418799348@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



