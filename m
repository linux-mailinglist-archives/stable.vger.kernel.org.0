Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792454FD8DE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353065AbiDLHqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356933AbiDLHjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9924AE23;
        Tue, 12 Apr 2022 00:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA703B81B4F;
        Tue, 12 Apr 2022 07:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4305EC385A5;
        Tue, 12 Apr 2022 07:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747429;
        bh=ROcSE4hl0LuGq9CRnKIb3ozIiz0n9mh+Gy8XDHNAMQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWru7+pb70nOWJ7AGygYR2yby7Pj8oRCe5h0UVJpEJwmuQj36NZzaNue9oJg1n6aG
         HYOSlB8U797QGRdZ+ZsWXlwm2QXeB3LnGk+4T16412KYPhz0iYMDuegaF+W8RaNA1b
         iVdSFu+WAsw4GAoCr7W6MDywSkwjrfZn94OR7HTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 077/343] scsi: mpi3mr: Fix memory leaks
Date:   Tue, 12 Apr 2022 08:28:15 +0200
Message-Id: <20220412062953.322673660@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 7193b983ee3b..e44868230197 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1520,7 +1520,7 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
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



