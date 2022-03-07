Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48764CF508
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiCGJY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiCGJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3477366FAD;
        Mon,  7 Mar 2022 01:21:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA13361073;
        Mon,  7 Mar 2022 09:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B7C340F3;
        Mon,  7 Mar 2022 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644892;
        bh=IENnOzCQlJp+UBCrUtJmV2Qib/MihkklYG372lOJDsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yc7a62zEZJwo29iOfi+jJwqSH5MfKJLLsYeG0VOFDv2ABCUKhYtXsmcUt26nfCS/r
         WtrRwhRIJUMNQb/AJVdDQdzAMUq//HIFa2pG4awTdHK32+XJPxckjyjSZSOdasKxpW
         2LvptpIKJUJc5BWZkK5wWjlN2mLKfcHszJYJHcdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Ni <nizhen@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 13/42] ALSA: intel_hdmi: Fix reference to PCM buffer address
Date:   Mon,  7 Mar 2022 10:18:47 +0100
Message-Id: <20220307091636.537139158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Ni <nizhen@uniontech.com>

commit 0aa6b294b312d9710804679abd2c0c8ca52cc2bc upstream.

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The driver needs to refer to substream->runtime->dma_addr
instead for the buffer address.

Signed-off-by: Zhen Ni <nizhen@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220302074241.30469-1-nizhen@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/x86/intel_hdmi_audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1308,7 +1308,7 @@ static int had_pcm_mmap(struct snd_pcm_s
 {
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return remap_pfn_range(vma, vma->vm_start,
-			substream->dma_buffer.addr >> PAGE_SHIFT,
+			substream->runtime->dma_addr >> PAGE_SHIFT,
 			vma->vm_end - vma->vm_start, vma->vm_page_prot);
 }
 


