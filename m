Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECF46C0821
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjCTBGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCTBEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821B624113;
        Sun, 19 Mar 2023 17:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF36D611FE;
        Mon, 20 Mar 2023 00:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E19C4339B;
        Mon, 20 Mar 2023 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273816;
        bh=75h4lD0mk5zmLz+UDOKXhH8iMe3itMJ/s4s7lr3PM7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmCF66oi6qWSoyOED/IZ5/c0QH9Ryhxo1/71rHTv0EUC4TCjUhgD0FOBwa8i2qwql
         GXPAFKpgcU8FKWET0ZDAkYjJ9Bzrh9rHylEwMrd5ltUAep6HXzn0yKicTonexGqvMI
         8cr0LgHrgj1MIAX2JUDd7nPiHkJ3XtAekenOmjHlIuhyTv98kXWGVkEIKfjXSotaL2
         xzl+dNBnchsBzuYEPJLHwmfK/pjpAIR/xV60+GlAkrWEysFk0CU98DtWMYyjHt+nZU
         ksfiKIzxyv7fnqGnlIbIUQywqwvNnBIDJ7dVBpsSSRDwSwK0/Mvnxx00iDkX7peNmf
         uOK97CqhkV+2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Koschel <jkl820.git@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/12] scsi: lpfc: Avoid usage of list iterator variable after loop
Date:   Sun, 19 Mar 2023 20:56:31 -0400
Message-Id: <20230320005636.1429242-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jkl820.git@gmail.com>

[ Upstream commit 2850b23e9f9ae3696e472d2883ea1b43aafa884e ]

If the &epd_pool->list is empty when executing
lpfc_get_io_buf_from_expedite_pool() the function would return an invalid
pointer. Even in the case if the list is guaranteed to be populated, the
iterator variable should not be used after the loop to be more robust for
future changes.

Linus proposed to avoid any use of the list iterator variable after the
loop, in the attempt to move the list iterator variable declaration into
the macro to avoid any potential misuse after the loop [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Link: https://lore.kernel.org/r/20230301-scsi-lpfc-avoid-list-iterator-after-loop-v1-1-325578ae7561@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bd908dd273078..e489c68cfb631 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20407,20 +20407,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
 static struct lpfc_io_buf *
 lpfc_get_io_buf_from_expedite_pool(struct lpfc_hba *phba)
 {
-	struct lpfc_io_buf *lpfc_ncmd;
+	struct lpfc_io_buf *lpfc_ncmd = NULL, *iter;
 	struct lpfc_io_buf *lpfc_ncmd_next;
 	unsigned long iflag;
 	struct lpfc_epd_pool *epd_pool;
 
 	epd_pool = &phba->epd_pool;
-	lpfc_ncmd = NULL;
 
 	spin_lock_irqsave(&epd_pool->lock, iflag);
 	if (epd_pool->count > 0) {
-		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+		list_for_each_entry_safe(iter, lpfc_ncmd_next,
 					 &epd_pool->list, list) {
-			list_del(&lpfc_ncmd->list);
+			list_del(&iter->list);
 			epd_pool->count--;
+			lpfc_ncmd = iter;
 			break;
 		}
 	}
-- 
2.39.2

