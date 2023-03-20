Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E14D6C0895
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCTBf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCTBfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:35:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E176B3;
        Sun, 19 Mar 2023 18:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18CADB80D4F;
        Mon, 20 Mar 2023 00:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDCAC433EF;
        Mon, 20 Mar 2023 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273686;
        bh=S92CcyWhvxH5rDjNGNtndcNeQr7FnAOumVDxLSX/x6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqKd6T9ZOdxacCNLCOxiZ+pjpfT3U7+dxUqS1gcI4mcevx+vooeTbIUDiPaVvXmUN
         EfpDqcQ2KS19xrQwZehR39/rwhj8253kGUjQST9ziBHmREpgaOL+rKNqSJrIwH0h0G
         NmYR2doIY4Tk1/VonvC4YBFPR+J03bK9pM+juRY6hqIS7H3eutfl3FjByUQHHfdF0v
         T12z/JbRv4Bm9TX1aajBZp7TKl6CFAdHBjvUOAbs69CSUWh6D3BpnfsHg1DPOK113S
         Lu0Fn0SYVDULQ2YuJTuOxXq5NABz92q7Wh9Qv1D612VAu/QHFzMZ8sxJeyuWykiqN6
         6sxjkWTugc3rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Koschel <jkl820.git@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 14/29] scsi: lpfc: Avoid usage of list iterator variable after loop
Date:   Sun, 19 Mar 2023 20:53:56 -0400
Message-Id: <20230320005413.1428452-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 43e06bb917e77..b44bb3ae22ad9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21886,20 +21886,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
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

