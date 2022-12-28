Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12849657B7C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiL1PXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiL1PWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3EA13F54
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18E97B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB21C433EF;
        Wed, 28 Dec 2022 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240932;
        bh=+DYwgNKZyaPCUdVD2IEIt6RJcz7jns/DQexItOurSeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnV72PY4G7WZ26UmcTOcAATfo7DU18r9OVGtwyiuiQ0tD9fz18IYFhqk+/7UKtA0R
         LdGPsTq64sPT+kJpbS8kJmzKoz2L2iBNYpARDl978K24BOxwHXbcNS9SiPmdpsZXdh
         DBA1KKvPVNIiMTMci5Dz6ajcUFcgIDGOm6t/Erew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/731] scsi: scsi_debug: Fix a warning in resp_report_zones()
Date:   Wed, 28 Dec 2022 15:38:39 +0100
Message-Id: <20221228144308.515316588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 07f2ca139d9a7a1ba71c4c03997c8de161db2346 ]

As 'alloc_len' is user controlled data, if user tries to allocate memory
larger than(>=) MAX_ORDER, then kcalloc() will fail, it creates a stack
trace and messes up dmesg with a warning.

Add __GFP_NOWARN in order to avoid too large allocation warning.  This is
detected by static analysis using smatch.

Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221112070612.2121535-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6ca3205a0bf5..5624bb6a64a3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4367,7 +4367,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
 			    max_zones);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC);
+	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.35.1



