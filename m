Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35996541B12
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380816AbiFGVm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381409AbiFGVkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1518232A41;
        Tue,  7 Jun 2022 12:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A47EB8220B;
        Tue,  7 Jun 2022 19:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A1C385A2;
        Tue,  7 Jun 2022 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628808;
        bh=Z7yu1bDK0mC1xruvohs/rezvFKpeCucwSrm7QYxW3E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDJxY3e9gLYQQHpFpkR/MURYvI7KsG9dbyVF6c7gwHEgmUq7KJe0D07kjIXkOJOjQ
         uiGnE1CnUCchQbEoxpZQrM3UJoEHc1Guixc9n1w3Qf5edL5iwo1bQw+KtkKOg7oEe7
         piV10xFV2jCq/WwSS7L9xPOltsgAvnx3xa8b8F7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 412/879] scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
Date:   Tue,  7 Jun 2022 18:58:50 +0200
Message-Id: <20220607165014.821351437@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 84c6f99e39074d45f75986e42ca28e27c140fd0d ]

The prior commit that moved from iocb elements to explicit wqe elements
missed a name change.

Correct __lpfc_sli_release_iocbq_s4() to reference wqe rather than iocb.

Link: https://lore.kernel.org/r/20220506035519.50908-2-jsmart2021@gmail.com
Fixes: a680a9298e7b ("scsi: lpfc: SLI path split: Refactor lpfc_iocbq")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 11f907278f09..c307f551d114 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1373,7 +1373,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
+	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-- 
2.35.1



