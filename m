Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB89E69CC3D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjBTNia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjBTNi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E056B747
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7147B80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D8C433D2;
        Mon, 20 Feb 2023 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900306;
        bh=MEpeniDZwoSaV2xAjDmu2ZkFj1SCvu4vIGyWhgcp/Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD781MUNg68X9TljvOXcL1x+T0idSTw96yYNCruMn/Uw5VyuIvjSkju0kKMz5znm3
         ariMhmw+HlwVxR2JCk+4V5YxUa5pk21JeOm4cuToGc0d6qbwI6wvodDXsQL4hKvpOr
         oF+vVHEtiOPLdZmbfQbmbBf//JPTyP8K2PfZ0kgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/53] ALSA: pci: lx6464es: fix a debug loop
Date:   Mon, 20 Feb 2023 14:35:54 +0100
Message-Id: <20230220133549.185252667@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 5dac9f8dc25fefd9d928b98f6477ff3daefd73e3 ]

This loop accidentally reuses the "i" iterator for both the inside and
the outside loop.  The value of MAX_STREAM_BUFFER is 5.  I believe that
chip->rmh.stat_len is in the 2-12 range.  If the value of .stat_len is
4 or more then it will loop exactly one time, but if it's less then it
is a forever loop.

It looks like it was supposed to combined into one loop where
conditions are checked.

Fixes: 8e6320064c33 ("ALSA: lx_core: Remove useless #if 0 .. #endif")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y9jnJTis/mRFJAQp@kili
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/lx6464es/lx_core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index a80684bdc30d6..46f5362096710 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -508,12 +508,11 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 		dev_dbg(chip->card->dev,
 			"CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
-		for (i = 0; i < MAX_STREAM_BUFFER; ++i) {
-			for (i = 0; i != chip->rmh.stat_len; ++i)
-				dev_dbg(chip->card->dev,
-					"  stat[%d]: %x, %x\n", i,
-					    chip->rmh.stat[i],
-					    chip->rmh.stat[i] & MASK_DATA_SIZE);
+		for (i = 0; i < MAX_STREAM_BUFFER && i < chip->rmh.stat_len;
+		     ++i) {
+			dev_dbg(chip->card->dev, "  stat[%d]: %x, %x\n", i,
+				chip->rmh.stat[i],
+				chip->rmh.stat[i] & MASK_DATA_SIZE);
 		}
 	}
 
-- 
2.39.0



