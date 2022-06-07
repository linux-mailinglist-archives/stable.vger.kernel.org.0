Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E87D540A49
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349939AbiFGSTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352125AbiFGSQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289F5DF50;
        Tue,  7 Jun 2022 10:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A89B822CD;
        Tue,  7 Jun 2022 17:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D64C34115;
        Tue,  7 Jun 2022 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624233;
        bh=n8/GnrtqBN+ElbM5hRTEvorINHVSuxJ+d0Ck/aQi8+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD4zT4h13TIHqxKtgPyQadvXFK9KUixtCgyghNu7mpQOMf9kAbkhmdWkdDvo2udKz
         +XiyzpBYk8loyCUh7M4yK/PXSgjInZDOVPSPqLJYvpHubO3OLK81yCenpceGbpmjPZ
         ghV632MWEVEvXAH9r4yv0nDs/RrQbQEdPEGEAGDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/667] scsi: iscsi: Fix harmless double shift bug
Date:   Tue,  7 Jun 2022 18:58:37 +0200
Message-Id: <20220607164942.341894739@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 565138ac5f8a5330669a20e5f94759764e9165ec ]

These flags are supposed to be bit numbers.  Right now they cause a double
shift bug where we use BIT(BIT(2)) instead of BIT(2).  Fortunately, the bit
numbers are small and it's done consistently so it does not cause an issue
at run time.

Link: https://lore.kernel.org/r/YmFyWHf8nrrx+SHa@kili
Fixes: 5bd856256f8c ("scsi: iscsi: Merge suspend fields")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/libiscsi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d1e282f0d6f1..6ad01d7de480 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -53,9 +53,9 @@ enum {
 #define ISID_SIZE			6
 
 /* Connection flags */
-#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
-#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-#define ISCSI_CONN_FLAG_BOUND		BIT(2)
+#define ISCSI_CONN_FLAG_SUSPEND_TX	0
+#define ISCSI_CONN_FLAG_SUSPEND_RX	1
+#define ISCSI_CONN_FLAG_BOUND		2
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.35.1



