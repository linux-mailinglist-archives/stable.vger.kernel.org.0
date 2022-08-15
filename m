Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059DB593D33
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243845AbiHOTvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345328AbiHOTte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:49:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AFA72EE3;
        Mon, 15 Aug 2022 11:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C98ECB810A2;
        Mon, 15 Aug 2022 18:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC13C433D7;
        Mon, 15 Aug 2022 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589390;
        bh=ev8eCZf7nG2UYA4LnbFQTNpzxmmKDb0z0eXAbIoA9Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3F9mYkahY6QsODM9Z1HXds+xaWtMVfbiTJX1uIVKSD4dshiefHHdYViS7F8RSVFI
         0siRjOda+dWG9rRSIpGSNCffEcYeNDvHbDmO83sMF6maDrUeYMaoMVlk/BLu5lUqPG
         VbF78yd/+gtphOyWijxB4HR/gx+ecHb7+Wi0dVRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 704/779] scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
Date:   Mon, 15 Aug 2022 20:05:48 +0200
Message-Id: <20220815180407.487035010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 0948a9c5386095baae4012190a6b65aba684a907 ]

VMID introduced an extra increment of cmd_pending, causing double-counting
of the I/O. The normal increment ios performed in lpfc_get_scsi_buf.

Link: https://lore.kernel.org/r/20220701211425.2708-5-jsmart2021@gmail.com
Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b43dfcb81185..7da8e4c845df 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5707,7 +5707,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
 	}
-	atomic_inc(&ndlp->cmd_pending);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
-- 
2.35.1



