Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3A66D95FB
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbjDFLjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbjDFLiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:38:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46ADA252;
        Thu,  6 Apr 2023 04:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C3586459A;
        Thu,  6 Apr 2023 11:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C48C433A1;
        Thu,  6 Apr 2023 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780855;
        bh=HZdSU6TfsnvdRjAw33V5sBgUHmkBviQoYhRzyGztA4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouc+B/fSN9qR6jMjYQfCwA+9ZHYbvSMFfAyJSp6HNmWhh+uko+OsijRA1tvwO3CkE
         +5C2NfQfBddZNet+YMFkn8tsEuCde9bssc9tMLuhbK+7+fCENacF7UgYdab/ZN6Dwy
         IfMbMoLTT3cBunfQqIFtIt8KXZnzguWH+HC7/8pH2xjmHHb0gLrd/n9M2NZW9P/3Je
         VQvsv4FsA/mCCfafyYkT4Ul3nFm5G2x70hvd3lWFG8R+KCCG9HYTb2WkgdvDnq5K/e
         p9VfBb2vdj8anwOp0TPVXwyuh3qIj+CGq4YAmRhBQ8jtvBKBexY16YItu+ilyokpsy
         7hdaznnktNNZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/8] scsi: megaraid_sas: Fix fw_crash_buffer_show()
Date:   Thu,  6 Apr 2023 07:33:56 -0400
Message-Id: <20230406113400.649038-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113400.649038-1-sashal@kernel.org>
References: <20230406113400.649038-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 0808ed6ebbc292222ca069d339744870f6d801da ]

If crash_dump_buf is not allocated then crash dump can't be available.
Replace logical 'and' with 'or'.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230324135249.9733-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8877a21102f1d..8d1df03386b4f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3032,7 +3032,7 @@ megasas_fw_crash_buffer_show(struct device *cdev,
 
 	spin_lock_irqsave(&instance->crashdump_lock, flags);
 	buff_offset = instance->fw_crash_buffer_offset;
-	if (!instance->crash_dump_buf &&
+	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
-- 
2.39.2

