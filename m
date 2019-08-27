Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E6C9E1F9
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfH0Hyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbfH0Hyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:54:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9F4217F5;
        Tue, 27 Aug 2019 07:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892477;
        bh=Ojiw9cviong+gOk0b1dDRq8ifWqinuxu2WAYzxvhGso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODgdSnGXAdb/pl3w05FB6123gyTxqwk0+IH0xIYZRweSU03vnXXMTvkJ5/EZ1Tk6P
         S1TWNxrGF1m67JgRKssEgdIk8NYZ7rLWEppXgVK2D6CIze1RTWuj/2qtK1+LIUB7LU
         S+wjss4okF8SShkYWhjObOjMiSDMcXMA3p0n2Rx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 61/62] dm zoned: fix potential NULL dereference in dmz_do_reclaim()
Date:   Tue, 27 Aug 2019 09:51:06 +0200
Message-Id: <20190827072704.012827908@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e0702d90b79d430b0ccc276ead4f88440bb51352 ]

This function is supposed to return error pointers so it matches the
dmz_get_rnd_zone_for_reclaim() function.  The current code could lead to
a NULL dereference in dmz_do_reclaim()

Fixes: b234c6d7a703 ("dm zoned: improve error handling in reclaim")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index ccf17eb6adaa2..b322821a6323b 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1579,7 +1579,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
 	struct dm_zone *zone;
 
 	if (list_empty(&zmd->map_seq_list))
-		return NULL;
+		return ERR_PTR(-EBUSY);
 
 	list_for_each_entry(zone, &zmd->map_seq_list, link) {
 		if (!zone->bzone)
@@ -1588,7 +1588,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
 			return zone;
 	}
 
-	return NULL;
+	return ERR_PTR(-EBUSY);
 }
 
 /*
-- 
2.20.1



