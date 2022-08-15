Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20959593D64
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240761AbiHOUC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346109AbiHOUBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596117C1B6;
        Mon, 15 Aug 2022 11:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33EE61228;
        Mon, 15 Aug 2022 18:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CB0C433D7;
        Mon, 15 Aug 2022 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589626;
        bh=GSRSy1yZuQhA2CaBbz79GviUyu39lfhsVDrX4xOYh84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB/aqPbppJptO5MIb12Ixghb7OQ7XflOyjGfmNVIGVXvx3kbfjtjKrMchr6d0EkKo
         +Tjvr/Jg/zCJj3hN94uCg3DRwwwCkt07HGYPRwDJIEvLfInYtTdZSW7ELV8m4H/DmZ
         YK2Cfu2SGgtObx87K8DcjIEcP8tTR4GeD3WP45hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 778/779] scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
Date:   Mon, 15 Aug 2022 20:07:02 +0200
Message-Id: <20220815180410.626739527@linuxfoundation.org>
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

commit 84c6f99e39074d45f75986e42ca28e27c140fd0d upstream.

The prior commit that moved from iocb elements to explicit wqe elements
missed a name change.

Correct __lpfc_sli_release_iocbq_s4() to reference wqe rather than iocb.

Link: https://lore.kernel.org/r/20220506035519.50908-2-jsmart2021@gmail.com
Fixes: a680a9298e7b ("scsi: lpfc: SLI path split: Refactor lpfc_iocbq")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1384,7 +1384,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
+	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 


