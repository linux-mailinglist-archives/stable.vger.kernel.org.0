Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690CF5B7182
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiIMOnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiIMOmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51646DACF;
        Tue, 13 Sep 2022 07:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A1BAB80F9B;
        Tue, 13 Sep 2022 14:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0756BC433C1;
        Tue, 13 Sep 2022 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078511;
        bh=1JNDSZ159f0NlIgztWiRuPXGCSt4cspPdHdovCGDwX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6G1Rq98VVy/B2HUs5y3/R3gIjFgavPMH1w16kZ9VnG+5KmFnzXVFEhL1WUCfYhgb
         qvDoSR5tuuFnYG74m2qQNNR0x/9LjT4qAAi1tI0ClKuO1kbTaiXumYvYUIeefcyRW1
         Ia59gKCAshR0Uw1gqL9be3r3Y9V3sMavJjkkvDco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 169/192] iommu/amd: use full 64-bit value in build_completion_wait()
Date:   Tue, 13 Sep 2022 16:04:35 +0200
Message-Id: <20220913140418.452069037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: John Sperbeck <jsperbeck@google.com>

[ Upstream commit 94a568ce32038d8ff9257004bb4632e60eb43a49 ]

We started using a 64 bit completion value.  Unfortunately, we only
stored the low 32-bits, so a very large completion value would never
be matched in iommu_completion_wait().

Fixes: c69d89aff393 ("iommu/amd: Use 4K page for completion wait write-back semaphore")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Link: https://lore.kernel.org/r/20220801192229.3358786-1-jsperbeck@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 840831d5d2ad9..a0924144bac80 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -874,7 +874,8 @@ static void build_completion_wait(struct iommu_cmd *cmd,
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0] = lower_32_bits(paddr) | CMD_COMPL_WAIT_STORE_MASK;
 	cmd->data[1] = upper_32_bits(paddr);
-	cmd->data[2] = data;
+	cmd->data[2] = lower_32_bits(data);
+	cmd->data[3] = upper_32_bits(data);
 	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
 }
 
-- 
2.35.1



