Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6464A03D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiLLNWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiLLNWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:22:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83081315
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E89461042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3BFC433EF;
        Mon, 12 Dec 2022 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851334;
        bh=kodpPhPiGEHVncs7lHlgeyBV0cizVTBtEmqJi9UoSh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGGXyAc/ptz5ur42rUEwkO0QD93j6e6h/cclRdpbwy9YA2jhswK7mjR3Vji23AaLF
         fza3KzUcqpKa4H/o3/uN/lfiJ++LSukhvI7TEKxvU3fKzKfYl0C1X6g4qBiM4cSg7r
         v811FbIz2aIBjKVqPCk6JTIqcrCeAcAjALd8sVE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/67] ASoC: soc-pcm: Add NULL check in BE reparenting
Date:   Mon, 12 Dec 2022 14:16:47 +0100
Message-Id: <20221212130918.207563059@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit db8f91d424fe0ea6db337aca8bc05908bbce1498 ]

Add NULL check in dpcm_be_reparent API, to handle
kernel NULL pointer dereference error.
The issue occurred in fuzzing test.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Link: https://lore.kernel.org/r/1669098673-29703-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 1196167364d4..2f1ab70a68fc 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1201,6 +1201,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
-- 
2.35.1



