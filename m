Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8754FD17A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351400AbiDLG6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352248AbiDLGzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA09739831;
        Mon, 11 Apr 2022 23:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DA2360B2F;
        Tue, 12 Apr 2022 06:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FF1C385A8;
        Tue, 12 Apr 2022 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745908;
        bh=gUKXk+hWheaOgzDSX+D/mI1rrSeyQxeOxJTfwxHC4fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3eU9R8N2cj67uGYIeGXv3vpM94uJhaj76fiuOmOMZ8vblOvZjGtwjhrWHkK60mWL
         8QJNY9skocvcNkj6ObVAUxygOqDI0MrDVHQES0r9yd6MgKuRbSLPMcCV+sQXRDdwK/
         KJKkPi7ryu1AWVQ0SGDllE8Fzdb1Lj2doybXVHsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/277] scsi: mpi3mr: Fix memory leaks
Date:   Tue, 12 Apr 2022 08:27:37 +0200
Message-Id: <20220412062943.613191667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit d44b5fefb22e139408ae12b864da1ecb9ad9d1d2 ]

Fix memory leaks related to operational reply queue's memory segments which
are not getting freed while unloading the driver.

Link: https://lore.kernel.org/r/20220210095817.22828-9-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5af36c54cb59..3ef6b6edef46 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1275,7 +1275,7 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 			    MPI3MR_MAX_SEG_LIST_SIZE,
 			    mrioc->req_qinfo[q_idx].q_segment_list,
 			    mrioc->req_qinfo[q_idx].q_segment_list_dma);
-			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
+			mrioc->req_qinfo[q_idx].q_segment_list = NULL;
 		}
 	} else
 		size = mrioc->req_qinfo[q_idx].segment_qd *
-- 
2.35.1



