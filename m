Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4B49954C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392537AbiAXUv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390780AbiAXUqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B610960B28;
        Mon, 24 Jan 2022 20:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CECC340E5;
        Mon, 24 Jan 2022 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057176;
        bh=q18wRBnCv2k58Fxjm5AjDgHriZlgmiylV6kF/Ik9r9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdILDd0l38CpkMuPzRuNG5oOiq0xMQjq79t4e9Od/knxCma98pJzF9XrziM/gBSZR
         JksDR0XYo0G317WpMq0H4elj3SinG6fWY78v1ZrJCuDpZg8oGMkyuyFd5SHsM+zqG0
         PEwspGjszNCGbTH3Z8dCZqMlDwtVfze0Vw4fIuYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 5.15 727/846] ath11k: qmi: avoid error messages when dma allocation fails
Date:   Mon, 24 Jan 2022 19:44:04 +0100
Message-Id: <20220124184126.083992973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

commit b9b5948cdd7bc8d9fa31c78cbbb04382c815587f upstream.

qmi tries to allocate a large contiguous dma memory at first,
on the AMD Ryzen platform it fails, then retries with small slices.
So set flag GFP_NOWARN to avoid flooding dmesg.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210823063258.37747-1-aaron.ma@canonical.com
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1770,7 +1770,7 @@ static int ath11k_qmi_alloc_target_mem_c
 		chunk->vaddr = dma_alloc_coherent(ab->dev,
 						  chunk->size,
 						  &chunk->paddr,
-						  GFP_KERNEL);
+						  GFP_KERNEL | __GFP_NOWARN);
 		if (!chunk->vaddr) {
 			if (ab->qmi.mem_seg_count <= ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,


