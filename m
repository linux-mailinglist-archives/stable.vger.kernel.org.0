Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA827594640
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350620AbiHOWTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbiHOWPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA06811FD0F;
        Mon, 15 Aug 2022 12:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62908B81136;
        Mon, 15 Aug 2022 19:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33A8C433C1;
        Mon, 15 Aug 2022 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592391;
        bh=R8yxeifnW/C+ZIsn9QhQpqxpvBGG+oGcICoWCpEV/dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmXvvNj4v2K6aSNexxoYvIpU8/LQXs/0kim9tWB3bIcvcHJyevs1n4qRURDRN2zuE
         nL+eJx0Jl2Jc1dPn/Yxx61kNnTfhwoK0Q767/sSkAejWAq4ROhi3NLb8lWAhXJKJ+I
         FMs7XFPousoyKqLHBzHRfiCfxm8y4qwi8EnoQsrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 0103/1157] scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
Date:   Mon, 15 Aug 2022 19:50:59 +0200
Message-Id: <20220815180443.752948029@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

commit 0948a9c5386095baae4012190a6b65aba684a907 upstream.

VMID introduced an extra increment of cmd_pending, causing double-counting
of the I/O. The normal increment ios performed in lpfc_get_scsi_buf.

Link: https://lore.kernel.org/r/20220701211425.2708-5-jsmart2021@gmail.com
Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5456,7 +5456,6 @@ lpfc_queuecommand(struct Scsi_Host *shos
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
 	}
-	atomic_inc(&ndlp->cmd_pending);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))


