Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94A49C9C1
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbiAZMeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbiAZMeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:34:17 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6A6C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:34:16 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b13so68963776edn.0
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1dwsJCAPb1P/HcP8Kg9GOfdaBr2EftYWRHb6NY7CWNw=;
        b=EDv46DQ/12BGIQ9tEckP6fhz+JvUW46OKtuvF4Bp38q48LgXjwZQcT+zxV550+cewy
         AawkcFCxgIKvPnTofnOGz+nKts9yhAHxeXF7yVSrYb68ajcJzT0FiHyQTv5WUilfKm7v
         phdauqvVOtAbKuHLIuSf789ApagdM/GNRXR2A5hpgsFN++bw0HAqfHs3QoE7x+S5T2li
         jVtd6882Lkd1RhLHH5lESwCIoDhqZSGoTcBZprA95ik1LOEkODMkCFA3lEkQwz+/8HXX
         La38YxHgN+QzuRH7w18EVtn8eOJ2TYBlALCYvHWUxdxq6hzhFcU01BjIjkRO8/v8Kzvf
         R3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1dwsJCAPb1P/HcP8Kg9GOfdaBr2EftYWRHb6NY7CWNw=;
        b=DWMIbXdnDsoNhTP6/yImNT1NQ/WUGtXfnDCl7M4n3irIGXPpXKvq+/NLL4/rzKCSr5
         xAdSMyxJ8SxeS7gKY+i9qMlpqnb1FKdfGvJrZaJHdc6pqDML4RUeX/Z1NTwBFpUjye7Y
         D/Ngpce0jnF4dP7J6b5i8UUBP0Zn+mbkuSkHvzjP0BRYwq/o+G7ywCVWrzQ2eVOF28a4
         IHBoEb3skUUv7ozS85kI0Yasz8Ekz9zHF9QvnMMKQQhQ0x7v1sVxD48Gj5JBpcy1vrN3
         sd4SRcvk0yzzikSVjbsapXXhog/6fczQT6aSoTVq6UZepxXHtuOd3CwRLGzW43iGc6So
         WjBA==
X-Gm-Message-State: AOAM531RQWA0L0VmrqOJtmvrltoR6KcWl68NFXIXYEhPeysPE7SbwJ5U
        R9ji5fdkfFXG1ycqsmWFe8vjqA==
X-Google-Smtp-Source: ABdhPJwzCSmgc3mcnfhGw2pteAXoy304jeWbkXmXeOqdRPPO5XOtQD7KieBSl5QbYHe3S0z7ffk0oA==
X-Received: by 2002:a05:6402:b44:: with SMTP id bx4mr24609349edb.409.1643200455364;
        Wed, 26 Jan 2022 04:34:15 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net (200116b8456296008c7d481e51c2d66f.dip.versatel-1u1.de. [2001:16b8:4562:9600:8c7d:481e:51c2:d66f])
        by smtp.gmail.com with ESMTPSA id r23sm3765530eju.134.2022.01.26.04.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:34:15 -0800 (PST)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: [stable-5.10] MD: Fix up backport of MD io stats revert
Date:   Wed, 26 Jan 2022 13:34:14 +0100
Message-Id: <20220126123414.46953-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backport to 5.10.92:
commit c39d68ab3836 ("md: revert io stats accounting") is slightly
different with upstream, remove unrelated change to be in sync
with upstream.

Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cc3876500c4b..887f07beed1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -485,21 +485,11 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	/*
-	 * save the sectors now since our bio can
-	 * go away inside make_request
-	 */
-	sectors = bio_sectors(bio);
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 
-	part_stat_lock();
-	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
-	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
-	part_stat_unlock();
-
 	return BLK_QC_T_NONE;
 }
 
-- 
2.25.1

