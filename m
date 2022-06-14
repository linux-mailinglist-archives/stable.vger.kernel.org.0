Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B1D54A405
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348979AbiFNCFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242309AbiFNCEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54BE33E07;
        Mon, 13 Jun 2022 19:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5093F60AD8;
        Tue, 14 Jun 2022 02:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625DEC3411E;
        Tue, 14 Jun 2022 02:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172288;
        bh=GuudOFzGcIiyKA5KR5gswm2awcHdQDRTnz0Xdb4dC+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpX7fZi7QQAvwiTpIrGjD+mYK77431+cKM7I7obeivYvwGoiyEMlTywIj0miA+FkK
         whrhssoKoFlZPpGx3RVmxnN1nMj+iIVXruB2BDeLDhnP6cpvXiRB1WxrRjsluKADp0
         A8mg/vUCT88ST6BzSWjoBiIdeaHjaTldntKpL5xOeZ6zowKlGE0Oo9Ek8jnw82nG0P
         Bh3KRd02n7cIxr5z+vUGJLdi61wvLMapv2DSLBLX6RoxdO8TYEGAcRKikGq9RgW8nq
         K35kRwV+q31xWAVOKDEtFrP+9YlCaSBr0nFvppy8PrYALnZ/rPJ0bJM+zjJhYHaNdW
         LHLmeDzHb9RRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, plai@codeaurora.org,
        bgoswami@codeaurora.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 03/47] ASoC: qcom: lpass-platform: Update VMA access permissions in mmap callback
Date:   Mon, 13 Jun 2022 22:03:56 -0400
Message-Id: <20220614020441.1098348-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit ef8d89b83bf453ea9cc3c4873a84b50ff334f797 ]

Replace page protection permissions from noncashed to writecombine,
in lpass codec DMA path mmp callabck, to support 64 bit chromeOS.
Avoid SIGBUS error in userspace caused by noncached permissions in
64 bit chromeOS.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Link: https://lore.kernel.org/r/1653660608-27245-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 74d62f377dfd..ae2a7837e5cc 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -898,7 +898,7 @@ static int lpass_platform_cdc_dma_mmap(struct snd_pcm_substream *substream,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	unsigned long size, offset;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	size = vma->vm_end - vma->vm_start;
 	offset = vma->vm_pgoff << PAGE_SHIFT;
 	return io_remap_pfn_range(vma, vma->vm_start,
-- 
2.35.1

