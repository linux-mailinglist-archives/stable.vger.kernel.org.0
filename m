Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21B2F58D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfE3EsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbfE3DLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107832446F;
        Thu, 30 May 2019 03:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185881;
        bh=1rPMMUnAEw/PbwAbQkw+rWsgCAavxUsZNbw2R/Ydn20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTc3lsLrLm62iZY+gqwKc6fuTIQUTsXfzprQmSRlKjG5QZzB5cDtYSAak7Q8Mwxjl
         7GklO4sjt2Xp1WgkpwyfJa8DRyRdfBRZIsuzDKh+6xR4i99exJC+i/C3AFgtuDYl3B
         ixPIaYwLfKzD0x8hjtNM8d3cDnPx1giGl4ekacTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Scott Bauer <sbauer@plzdonthack.me>,
        David Kozub <zub@linux.fjfi.cvut.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 231/405] block: sed-opal: fix IOC_OPAL_ENABLE_DISABLE_MBR
Date:   Wed, 29 May 2019 20:03:49 -0700
Message-Id: <20190530030552.717932372@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78bf47353b0041865564deeed257a54f047c2fdc ]

The implementation of IOC_OPAL_ENABLE_DISABLE_MBR handled the value
opal_mbr_data.enable_disable incorrectly: enable_disable is expected
to be one of OPAL_MBR_ENABLE(0) or OPAL_MBR_DISABLE(1). enable_disable
was passed directly to set_mbr_done and set_mbr_enable_disable where
is was interpreted as either OPAL_TRUE(1) or OPAL_FALSE(0). The end
result was that calling IOC_OPAL_ENABLE_DISABLE_MBR with OPAL_MBR_ENABLE
actually disabled the shadow MBR and vice versa.

This patch adds correct conversion from OPAL_MBR_DISABLE/ENABLE to
OPAL_FALSE/TRUE. The change affects existing programs using
IOC_OPAL_ENABLE_DISABLE_MBR but this is typically used only once when
setting up an Opal drive.

Acked-by: Jon Derrick <jonathan.derrick@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Scott Bauer <sbauer@plzdonthack.me>
Signed-off-by: David Kozub <zub@linux.fjfi.cvut.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/sed-opal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/sed-opal.c b/block/sed-opal.c
index e0de4dd448b3c..1196408972937 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -2095,13 +2095,16 @@ static int opal_erase_locking_range(struct opal_dev *dev,
 static int opal_enable_disable_shadow_mbr(struct opal_dev *dev,
 					  struct opal_mbr_data *opal_mbr)
 {
+	u8 enable_disable = opal_mbr->enable_disable == OPAL_MBR_ENABLE ?
+		OPAL_TRUE : OPAL_FALSE;
+
 	const struct opal_step mbr_steps[] = {
 		{ opal_discovery0, },
 		{ start_admin1LSP_opal_session, &opal_mbr->key },
-		{ set_mbr_done, &opal_mbr->enable_disable },
+		{ set_mbr_done, &enable_disable },
 		{ end_opal_session, },
 		{ start_admin1LSP_opal_session, &opal_mbr->key },
-		{ set_mbr_enable_disable, &opal_mbr->enable_disable },
+		{ set_mbr_enable_disable, &enable_disable },
 		{ end_opal_session, },
 		{ NULL, }
 	};
@@ -2221,7 +2224,7 @@ static int __opal_lock_unlock(struct opal_dev *dev,
 
 static int __opal_set_mbr_done(struct opal_dev *dev, struct opal_key *key)
 {
-	u8 mbr_done_tf = 1;
+	u8 mbr_done_tf = OPAL_TRUE;
 	const struct opal_step mbrdone_step [] = {
 		{ opal_discovery0, },
 		{ start_admin1LSP_opal_session, key },
-- 
2.20.1



