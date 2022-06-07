Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEEF540F32
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352052AbiFGTD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353333AbiFGTCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04717156468;
        Tue,  7 Jun 2022 11:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A140C616B6;
        Tue,  7 Jun 2022 18:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6747C385A5;
        Tue,  7 Jun 2022 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625106;
        bh=6pCZfOF14bBwPJFZpSX3t/6Hfln6Scd7Z7sf8NVSHmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUaMi35we3uVZuatWd8cDlHibNPvObPW8Tkc3zVWEYbNPPC/rnwsAUQSsgaHiE7kI
         hprsmdW5aFswJmQoYQziwcvoiR3XTq2VSs5gr0Gasdw6jZJQh8ZzA+UTQB7BufLj3z
         yjCzf+jRh8OB3u8vwtAqYWETZfBFIa7ht3rzQQ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 566/667] scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled
Date:   Tue,  7 Jun 2022 19:03:51 +0200
Message-Id: <20220607164951.669266154@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 8eecddfca30e1651dc1c74531ed5eef21dcce7e3 upstream.

In ufs_qcom_dev_ref_clk_ctrl(), it was noted that the ref_clk needs to be
stable for at least 1us. Even though there is wmb() to make sure the write
gets "completed", there is no guarantee that the write actually reached the
UFS device. There is a good chance that the write could be stored in a
Write Buffer (WB). In that case, even though the CPU waits for 1us, the
ref_clk might not be stable for that period.

So lets do a readl() to make sure that the previous write has reached the
UFS device before udelay().

Also, the wmb() after writel_relaxed() is not really needed. Both writel()
and readl() are ordered on all architectures and the CPU won't speculate
instructions after readl() due to the in-built control dependency with read
value on weakly ordered architectures. So it can be safely removed.

Link: https://lore.kernel.org/r/20220504084212.11605-4-manivannan.sadhasivam@linaro.org
Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Cc: stable@vger.kernel.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-qcom.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -678,8 +678,11 @@ static void ufs_qcom_dev_ref_clk_ctrl(st
 
 		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
 
-		/* ensure that ref_clk is enabled/disabled before we return */
-		wmb();
+		/*
+		 * Make sure the write to ref_clk reaches the destination and
+		 * not stored in a Write Buffer (WB).
+		 */
+		readl(host->dev_ref_clk_ctrl_mmio);
 
 		/*
 		 * If we call hibern8 exit after this, we need to make sure that


