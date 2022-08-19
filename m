Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BE59A164
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiHSQGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351581AbiHSQGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:06:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F9B107AD5;
        Fri, 19 Aug 2022 08:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 333CAB8281C;
        Fri, 19 Aug 2022 15:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9184EC433C1;
        Fri, 19 Aug 2022 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924530;
        bh=34hWI5LEAXPOy5D+UkA90PyfWHytamfK+RNcrZmgBb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smZCXevWEHbQCC183XBdYJmrj3LKqb8CWfFRB2XAOkQI4Jf07SzLudUXGP692aKEK
         W8EiN+ncHT16c2J7K8YsiXAfYP2WYdvemQ9l1B7NjHpQtA7zhE1jvgjFG72ogacLjK
         uaOw4jNqu9QtElf4OZ26Z5g9XsgBDVmV9okSlis0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/545] drm/vc4: hdmi: Avoid full hdmi audio fifo writes
Date:   Fri, 19 Aug 2022 17:39:30 +0200
Message-Id: <20220819153838.337762307@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 1c594eeccf92368177c2e22f1d3ee4933dfb8567 ]

We are getting occasional VC4_HD_MAI_CTL_ERRORF in
HDMI_MAI_CTL which seem to correspond with audio dropouts.

Reduce the threshold where we deassert DREQ to avoid the fifo
overfilling

Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-21-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 6acc34f1e095..9a90f22df3d2 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1033,10 +1033,10 @@ static int vc4_hdmi_audio_hw_params(struct snd_pcm_substream *substream,
 
 	/* Set the MAI threshold */
 	HDMI_WRITE(HDMI_MAI_THR,
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICHIGH) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICLOW) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_DREQHIGH) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_DREQLOW));
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICHIGH) |
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICLOW) |
+		   VC4_SET_FIELD(0x06, VC4_HD_MAI_THR_DREQHIGH) |
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_DREQLOW));
 
 	HDMI_WRITE(HDMI_MAI_CONFIG,
 		   VC4_HDMI_MAI_CONFIG_BIT_REVERSE |
-- 
2.35.1



