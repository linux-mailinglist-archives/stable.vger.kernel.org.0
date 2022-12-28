Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CB658036
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiL1QP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiL1QPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:15:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4435213F5A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE400B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513FEC433EF;
        Wed, 28 Dec 2022 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243962;
        bh=/Jz+4lxrnwABy4dVl/qgCo+M40vkFR934u+DyWQuS08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWWOU0O+3jXUbFGEPoKoDsuDz3p7S6Ff7U6gLax6fCO70E7mJo69cWO0pHudnUq9J
         EnZhJT5tnCdJGz4pWHoLdO0AUmFAJTZGyG96vY3824MKCTW5sjwFB5izHTJC8kqp+W
         hLJ7jwe3SZKgdWfysd140npxQ6sa4LIkOOxkVMFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0623/1073] scsi: scsi_debug: Fix a warning in resp_report_zones()
Date:   Wed, 28 Dec 2022 15:36:51 +0100
Message-Id: <20221228144344.965783619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 077782eb55e7..3452fef3f749 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4504,7 +4504,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 
 	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC);
+	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.35.1



