Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB94B4727
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbiBNJrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343766AbiBNJq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5776B0AC;
        Mon, 14 Feb 2022 01:39:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B294611DE;
        Mon, 14 Feb 2022 09:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE73C36AE2;
        Mon, 14 Feb 2022 09:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831595;
        bh=P3qbYayGFjFb/gkQnpdVwoJRURSj299ER3xrYVzQ6Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTey1wGd+ABT8Uhdpd8I652Pd4z02SCzxxCSwX9jXF11IVInIbFBMlGQL6dmqLkaF
         EIAkcxagKMd6Xms/HvWQVZ4kFuhtbGtxPmfr0fb/1S9edSBhGri6qufyaI7zrmYowI
         Adu+7jWbIxu/Y0MfUscG9d3j/MPONUsS1s32E0+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Tong Zhang <ztong0001@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/116] scsi: myrs: Fix crash in error case
Date:   Mon, 14 Feb 2022 10:25:30 +0100
Message-Id: <20220214092459.767457421@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 4db09593af0b0b4d7d4805ebb3273df51d7cc30d ]

In myrs_detect(), cs->disable_intr is NULL when privdata->hw_init() fails
with non-zero. In this case, myrs_cleanup(cs) will call a NULL ptr and
crash the kernel.

[    1.105606] myrs 0000:00:03.0: Unknown Initialization Error 5A
[    1.105872] myrs 0000:00:03.0: Failed to initialize Controller
[    1.106082] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.110774] Call Trace:
[    1.110950]  myrs_cleanup+0xe4/0x150 [myrs]
[    1.111135]  myrs_probe.cold+0x91/0x56a [myrs]
[    1.111302]  ? DAC960_GEM_intr_handler+0x1f0/0x1f0 [myrs]
[    1.111500]  local_pci_probe+0x48/0x90

Link: https://lore.kernel.org/r/20220123225717.1069538-1-ztong0001@gmail.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 78c41bbf67562..e6a6678967e52 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2272,7 +2272,8 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	myrs_unmap(cs);
 
 	if (cs->mmio_base) {
-		cs->disable_intr(cs);
+		if (cs->disable_intr)
+			cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
 		cs->mmio_base = NULL;
 	}
-- 
2.34.1



