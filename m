Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEBE65D9F0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjADQex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbjADQMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA21208E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76A29B81722
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FDDC433F0;
        Wed,  4 Jan 2023 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848711;
        bh=g3brnivwCae+NI6FEA9bb3QTupOuCmTBIq1xre1B51o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0ZJVLxYjxTXezsCO3ppNV+yJJTjgh1vs2xZOeLvAeGYrSCGxBVm2uQSmqzuSNcBt
         eM0J9Guj0q0rTuB22gOUS1Um+JgnvvYEMCruazyDgGXKGb60U94+JgEnldF0wOXtN/
         kfW5kyjOKyx86MZ1KP58oDQDKIUSdwfclbC4aEZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/207] ALSA: hda/cirrus: Add extra 10 ms delay to allow PLL settle and lock.
Date:   Wed,  4 Jan 2023 17:05:12 +0100
Message-Id: <20230104160513.622171578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

[ Upstream commit 9fb9fa18fb50d1a33a1bd947681fce96fc2c8db6 ]

New HW platforms with multiple CS42L42 parts, faster CPU and i2c
requre some extra delay to allow PLL to settle and lock. Adding
extra 10ms delay.

Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221205145713.23852-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index 754aa8ddd2e4..0ba1fbcbb21e 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -888,7 +888,7 @@ static void cs42l42_resume(struct sub_codec *cs42l42)
 
 	/* Initialize CS42L42 companion codec */
 	cs8409_i2c_bulk_write(cs42l42, cs42l42->init_seq, cs42l42->init_seq_num);
-	usleep_range(20000, 25000);
+	usleep_range(30000, 35000);
 
 	/* Clear interrupts, by reading interrupt status registers */
 	cs8409_i2c_bulk_read(cs42l42, irq_regs, ARRAY_SIZE(irq_regs));
-- 
2.35.1



