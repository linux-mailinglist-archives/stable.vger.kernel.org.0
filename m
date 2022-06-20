Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64257551A03
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiFTMyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbiFTMyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7FE17053;
        Mon, 20 Jun 2022 05:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 341EC614B7;
        Mon, 20 Jun 2022 12:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C021C3411B;
        Mon, 20 Jun 2022 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729649;
        bh=GuudOFzGcIiyKA5KR5gswm2awcHdQDRTnz0Xdb4dC+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hJpE4CaA7UkUyMDhWAagZnmVNgEwXu0hIuq0aLVfXGExM91yQFQoIz4Jrq/jC+7h
         pR63rtCoDPsWWRgRlgXmIhmxzFMN/d9t/KVW6T2eFCYNA3lMmNzEzVQMhkcRH8E2mu
         WeKIOMP99CjhDhfph0YtIV1J+R6HdLocZhQzDxlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 007/141] ASoC: qcom: lpass-platform: Update VMA access permissions in mmap callback
Date:   Mon, 20 Jun 2022 14:49:05 +0200
Message-Id: <20220620124729.733286840@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



