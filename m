Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20B21FE430
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgFRCQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgFRBUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68A320776;
        Thu, 18 Jun 2020 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443216;
        bh=ntKiBIZMtY5kAgd0PwdkPq8s81UQr8qwyF3AL0qhMXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbB5WaoGTEAglbrWaw//py7BJAdnvb3spvP4aWFMZJ6soE9QhREG0QAPHRQ6YRkCc
         hJLiBM2z368bm/r725mq2mK1hVFp8QfxrhImazJsOsFAP7W2U9H0CF5f3lGazPSdKB
         MZw2EFatpWKzzc8+XJ19lkitSj6NTlGSqVISfKdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 172/266] dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone
Date:   Wed, 17 Jun 2020 21:14:57 -0400
Message-Id: <20200618011631.604574-172-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 489dc0f06a5837f87482c0ce61d830d24e17082e ]

The only case where dmz_get_zone_for_reclaim() cannot return a zone is
if the respective lists are empty. So we should just return a simple
NULL value here as we really don't have an error code which would make
sense.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 drivers/md/dm-zoned-reclaim.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index e0a6cf9239f1..e6b0039d07aa 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1589,7 +1589,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 			return dzone;
 	}
 
-	return ERR_PTR(-EBUSY);
+	return NULL;
 }
 
 /*
@@ -1609,7 +1609,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
 			return zone;
 	}
 
-	return ERR_PTR(-EBUSY);
+	return NULL;
 }
 
 /*
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index e7ace908a9b7..d50817320e8e 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -349,8 +349,8 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 
 	/* Get a data zone */
 	dzone = dmz_get_zone_for_reclaim(zmd);
-	if (IS_ERR(dzone))
-		return PTR_ERR(dzone);
+	if (!dzone)
+		return -EBUSY;
 
 	start = jiffies;
 
-- 
2.25.1

