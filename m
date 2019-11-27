Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7DF10AB07
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfK0HV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37983 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfK0HV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so25433892wro.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=en22Qz+GY6oZwRgNSeL3wdglbjbmHRAr7MDxv/V2MP8=;
        b=w9vJW1EnK+g6MeSQKgpBzWbqwgwZgvJVM6yxCn3GCkNWxr68xRj8SEakKGSxOrJ4Sl
         fa80J+t367tRd0olbeb2UJZqGDpfm5qOiHRlRPLGKeVLXcM3SYLwsMhOpB8iLyFuak8i
         qQplTEdykxtSGX17DZCjBjQDMVpWMVVqb7rEqOfwyH20InEEowS/kbPIp0+yT7kdzP4b
         cC3PxeS2HU6zDJUueRnnnO7r2cOHmWkzxMOcPsue9Nt5WIu8AcHA1Ehjc+JH8JT+kYSq
         eWPTpFcRcuYZltwTLjRlUCZe5dgAHn3M+soEsL589ar+AI4JGAA1qq6C5g64g5wNYm35
         kfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=en22Qz+GY6oZwRgNSeL3wdglbjbmHRAr7MDxv/V2MP8=;
        b=fu+K/WPF7Q5tWsYQmQ8ELUmVk7U98YFqg3SdMQbLEz5BGj5iaPw45+K8zAwRhF/XCg
         aK/PjCh7j6ZFwEGNvgIQAjzK+9oTonCTKAk9dg7B8fmuii0+V/dkA/Bl4X5T2YJp5Qq9
         K9LMnMtO6CBOoEOdz4I46YnWHU42veRewumydFmlsKzRUzk3y8+nK5ic208kCqrgcoWU
         MCxXMq40sQHdoiGCQDoO0dbo70k8fWWSKf18wRuyEfaT54PcmoBFyekvwtURIFZZGNoj
         idbGQ0l5n0Na4cn1OOUOdhBS+U9afmAfeAoTV42n+EJdN4qjAHRilSgiLWDhCD9LxUs5
         yxvQ==
X-Gm-Message-State: APjAAAXwj6pbx48Mkv5d8FINxew3cE4hxdHHHID1ghVgyunzniKjzuaR
        oVQSZ1WhxGbJIAuaBDLe6WJFIj3PtHo=
X-Google-Smtp-Source: APXvYqz8PzkYBmYCAc9owZ4aJcOYtCLB/abegIdTpnb7EgsB6XAWS8aVtSYt5125nHh4c8y+A5fV4w==
X-Received: by 2002:adf:db01:: with SMTP id s1mr38451271wri.372.1574839312771;
        Tue, 26 Nov 2019 23:21:52 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:52 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 5/6] mmc: block: Fix tag condition with packed writes
Date:   Wed, 27 Nov 2019 07:21:23 +0000
Message-Id: <20191127072124.30445-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
References: <20191127072124.30445-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d806b46e5f496a6335ebd7f8432d2533507ce9a2 ]

Apparently a cut-and-paste error, 'do_data_tag' is using 'brq' for data
size even though 'brq' has not been set up. Instead use blk_rq_sectors().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/card/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f600bdcaf5b4..07592e428755 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1772,8 +1772,7 @@ static void mmc_blk_packed_hdr_wrq_prep(struct mmc_queue_req *mqrq,
 		do_data_tag = (card->ext_csd.data_tag_unit_size) &&
 			(prq->cmd_flags & REQ_META) &&
 			(rq_data_dir(prq) == WRITE) &&
-			((brq->data.blocks * brq->data.blksz) >=
-			 card->ext_csd.data_tag_unit_size);
+			blk_rq_bytes(prq) >= card->ext_csd.data_tag_unit_size;
 		/* Argument of CMD23 */
 		packed_cmd_hdr[(i * 2)] = cpu_to_le32(
 			(do_rel_wr ? MMC_CMD23_ARG_REL_WR : 0) |
-- 
2.24.0

