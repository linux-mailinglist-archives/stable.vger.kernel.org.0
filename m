Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BBE4EF55E
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352001AbiDAPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350684AbiDAPAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A53BA57;
        Fri,  1 Apr 2022 07:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D69AB8250F;
        Fri,  1 Apr 2022 14:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD7C340F2;
        Fri,  1 Apr 2022 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824536;
        bh=u9t8ec+R60dscpY1RNsPdumAnADN3VqVPPwLgkkCueM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVPm/6sUa7GjE6c6fGNUy5s/ficJVCVq6OI06q9wZwq4MUeE/MiHKtayaq2HwVs8P
         6eYBtewa6xDylp2Q2XLvkCo0JUGYPrG6kcErfoI/3BFqy3wAa600QQyyLFh0wAsCAS
         Lk29yFOM+SWCfK7Aztmg83rTVkxzr5JsJn/4S/B0g6I5TxsJ2uE7xkLu+jR2b0P81w
         zKjuL+VgfRZ8/TVGlDLgyIP5jiKwj0L5GGnbDQ72zNv3v70QTtkYGD9sdBr722H0xU
         j8ZRYAU7hjpuvBZNuHU7MKMQkv3v2dDPVvM9NeyLwPbAarxMgajvG4cHX/oycbeGqF
         lN0BmxUwwc3WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/16] scsi: libfc: Fix use after free in fc_exch_abts_resp()
Date:   Fri,  1 Apr 2022 10:48:23 -0400
Message-Id: <20220401144827.1955845-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144827.1955845-1-sashal@kernel.org>
References: <20220401144827.1955845-1-sashal@kernel.org>
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
index 59fd6101f188..177e494b5e47 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1663,6 +1663,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
-- 
2.34.1

