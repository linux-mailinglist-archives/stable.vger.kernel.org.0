Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E497106C64
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfKVKvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45518 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729187AbfKVKvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id z10so7997169wrs.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=en22Qz+GY6oZwRgNSeL3wdglbjbmHRAr7MDxv/V2MP8=;
        b=ImlxrSHDuMxLPzF3ssEu96SgSAOzmmKxeushivYhKfcF1a6j243TAAoSwWGCKdqeI+
         qNHcUnz1EqqoWOEVie5BpvoY+7RDTOqcc3v/9K5DUa6UicVma/71ezoK77tNblU7hoA/
         0gJaQFbCNI1BMKO11oMuDJjN0Bd3/4mf03BlAnzogVGUiipBXxgnRtVXS5BztsbxTxXm
         o3xMyD1C1Ymt/VhH0P1xBJgOegO8e62yYrv52ZT/DbQxBNByiWHV+VPd3bt2JWFLqf4A
         9S3OdqEvgZKwpJW2pL5aizEWRUv6mLq4KmnEqlAZFznvc58EJbS5YjMkBYFRZ2qNfI9M
         u/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=en22Qz+GY6oZwRgNSeL3wdglbjbmHRAr7MDxv/V2MP8=;
        b=MzgJWw6GTwOt7hB+rzJiQI+aKGofkak9+wZPkhbdfWxYT8+ZazxmoSFB+sH5n3+kpW
         jKb8DvK3Nj3TvbwjAnXIN+UOJOabO4jXtpStClHZOvEaP1Kec5VBlc8LF2r8reCjGvFg
         VxjTOjlLHPmOaRaylRSaTGU4mTq4kNntK9hgkAp8ctzre3XJPIvu0CB4+AJaLSSUfz3/
         ON3aaMxBV5qMLX7aiUHcfXvSLlyhrejyLgeoQQ/ZwR8EvLbdKr9khuD7fHpIdSLcmOmF
         IwrlG/aWzivRLCtY91DkaUHIUUZEEe9P3WK9Yz4nyz4iwIua026zIR3s1dAPUb6vVn7x
         XZpg==
X-Gm-Message-State: APjAAAXr0tqAVc0pp0HTyBauklbXFfQbTYenDgrPKhxWin8Ra7SoUZb4
        8LoqcZ9/4nfTEOH3kC7mWsfCnw==
X-Google-Smtp-Source: APXvYqyU4eFbXFCMIhiig6LXk0JVMBTzolT4iE2W7vbgNJbRVqjFSPBrgir82f9zODvLMVvvtw9kQw==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr16130223wro.253.1574419902585;
        Fri, 22 Nov 2019 02:51:42 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 7/9] mmc: block: Fix tag condition with packed writes
Date:   Fri, 22 Nov 2019 10:51:11 +0000
Message-Id: <20191122105113.11213-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
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

