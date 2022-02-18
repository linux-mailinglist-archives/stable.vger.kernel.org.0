Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646B54BBEF0
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbiBRSFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 13:05:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbiBRSFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 13:05:05 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB9217E978
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:04:48 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso9272724pjg.0
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPi9DPzZjlmeLMULlupc+kkTuRwo4vQ/f+aaQWdHAZ8=;
        b=UQp1HZftA3rAXSU5MFiHwN2+rRPcagKN1vo85dUIgB7/q0Zz/7xSLk+dcCK/oAD71h
         +KB6svRafVr/f3daQDS2msOLxg362tzxiBwMatgAxUr1flOyBiy1phC7nFb1QqtSTIF/
         Y7NGtBhgp3xYmfMj/9hhe4dILYr0c8WRqZsJcTT3WJvVMA5RM6o66sKFAC8yJakRKPoN
         Dij35jvSXwgi1sg2odb073V5HEO2PwvnYhzJnXuLfSIQPfUpLN2oDrq6Syp0k1gyuYo+
         9YXBhACGnNgwvbYI+sHHQtgP+aLF7CwVQiqBXhXNcxUDqgZGcOw64/jiSL4Hjskjc+HU
         sQlQ==
X-Gm-Message-State: AOAM531rwCTfsuQSiD+DDmkImxjomR6uzOIX6ZBNI2pq9/7vBjixowAh
        Nb4kx3PMDwbHdb3hLxzmHlA=
X-Google-Smtp-Source: ABdhPJwdkQCQbiSQ8UdD424gvBBbVD3a05fTgY3BtwEF04nRmofIHXFf8RExE4Ikk2YK9vm2XAAK7Q==
X-Received: by 2002:a17:902:bc82:b0:14f:2b9c:4aa with SMTP id bb2-20020a170902bc8200b0014f2b9c04aamr8381474plb.145.1645207488207;
        Fri, 18 Feb 2022 10:04:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q21sm3808745pfu.188.2022.02.18.10.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:04:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: ufs: Remove dead code
Date:   Fri, 18 Feb 2022 10:04:38 -0800
Message-Id: <20220218180439.19858-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218180439.19858-1-bvanassche@acm.org>
References: <20220218180439.19858-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d77ea8226b3be23b0b45aa42851243b62a27bda1 upstream.

Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
conflicts") guarantees that 'tag' is not in use by any SCSI command.
Remove the check that returns early if a conflict occurs.

Link: https://lore.kernel.org/r/20211203231950.193369-6-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f489954e4632..92e4f0dbb791 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6658,11 +6658,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
@@ -6730,8 +6725,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
 	blk_put_request(req);
+
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
