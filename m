Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B598168105D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbjA3OC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbjA3OCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9D23A86C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D820EB80E78
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8E4C433D2;
        Mon, 30 Jan 2023 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087349;
        bh=U3azTgYrE328S2huq7Sl8qLwkjNklnwVXuDkI9kvEic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIl8Tf/wB63YiL9z287AjXojTV8EO/JqgDgSbyghfAkcDw6v6r9kP4bmFi4lErT+g
         nJGVbvuGBlMeB1Phez7CAKWtJ7qI/N3U7zlgPnZfzhFjCwQvfe5gmCwwKoRl//668O
         AQ76VLIRWFDA8gBVsunpXLMkvnJoDfB3n5m8CAz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xingui Yang <yangxingui@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/313] scsi: hisi_sas: Use abort task set to reset SAS disks when discovered
Date:   Mon, 30 Jan 2023 14:50:14 +0100
Message-Id: <20230130134345.025453464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 037b48057e8b485a8d72f808122796aeadbbee32 ]

Currently clear task set is used to abort all commands remaining in the
disk when the SAS disk is discovered, and if the disk is discovered by two
initiators, other I_T nexuses are also affected. So use abort task set
instead and take effect only on the specified I_T nexus.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 699b07abb6b0..34870b3286ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -714,7 +714,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		int_to_scsilun(0, &lun);
 
 		while (retry-- > 0) {
-			rc = sas_clear_task_set(device, lun.scsi_lun);
+			rc = sas_abort_task_set(device, lun.scsi_lun);
 			if (rc == TMF_RESP_FUNC_COMPLETE) {
 				hisi_sas_release_task(hisi_hba, device);
 				break;
-- 
2.39.0



