Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1864EF2E8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351606AbiDAPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350026AbiDAO6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A2817C438;
        Fri,  1 Apr 2022 07:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C381C60AC0;
        Fri,  1 Apr 2022 14:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68764C34113;
        Fri,  1 Apr 2022 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824357;
        bh=7+fl+5KI2HLiQc9ZhTDUoUDKUEeoId2FXhuByBCZFuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K38FbCoMy52gObO/fr4LC1qmAbTvHqbnOUIjZ3BxPIyzXUuPEDgJlpg0EjLXXQqXi
         ZUDLr95f6WGr/OB7a/UmNklouwLOmVFVM2mV48IUcIcI2uwEpvELPxnmGIVNVkDVug
         qtmty8bGAFivNmcMUK64MjqRQQxT9NGd62HblfI4SYs+HvfUwdCv3p8DxBJOWjiK2l
         VuN4EoFIBUZgi+DxVcRhI2nzrwidoBEdTm410fPEnPxRxwvZC1I8OGWK19g4jc52+v
         xADpXpzl2eibGwHnw/93pC3MijXXp0c2FTXk2+mqHIj6FlqFE5ZT8c5cu28mfK63QS
         Izhr9ypYRjaNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/37] scsi: libfc: Fix use after free in fc_exch_abts_resp()
Date:   Fri,  1 Apr 2022 10:44:40 -0400
Message-Id: <20220401144446.1954694-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 271add11994ba1a334859069367e04d2be2ebdd4 ]

fc_exch_release(ep) will decrease the ep's reference count. When the
reference count reaches zero, it is freed. But ep is still used in the
following code, which will lead to a use after free.

Return after the fc_exch_release() call to avoid use after free.

Link: https://lore.kernel.org/r/20220303015115.459778-1-niejianglei2021@163.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index e5b18e5d46da..6e2a36eeb12a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1697,6 +1697,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
-- 
2.34.1

