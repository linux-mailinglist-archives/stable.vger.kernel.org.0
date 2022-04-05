Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B144F3A8A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381537AbiDELqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354894AbiDEKQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5F01EC70;
        Tue,  5 Apr 2022 03:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC2961673;
        Tue,  5 Apr 2022 10:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E194C385A3;
        Tue,  5 Apr 2022 10:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153015;
        bh=VyPMBV7TTks1pk5+FCIN8TMQLHba/6ctFX8uhteFhYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LskSVzGlRmjzi4YGfA0SUg3U9G6ZcjRYvz/RZBwaaqJL+Bqrdtq/hAQrHWSZ/XciP
         fteWlj1DWBNgIUrVltra7ris/xaMVEAgg0TynX3uTrRyFIEVaMg4R2t3uerF/uxX1C
         tA87DZB7/RSIWhbIKKQkasWXKSKM6uAitFzAyQ3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 070/599] ALSA: cs4236: fix an incorrect NULL check on list iterator
Date:   Tue,  5 Apr 2022 09:26:04 +0200
Message-Id: <20220405070300.909450661@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 0112f822f8a6d8039c94e0bc9b264d7ffc5d4704 upstream.

The bug is here:
	err = snd_card_cs423x_pnp(dev, card->private_data, pdev, cdev);

The list iterator value 'cdev' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'cdev' as a dedicated pointer
to point to the found element. And snd_card_cs423x_pnp() itself
has NULL check for cdev.

Cc: stable@vger.kernel.org
Fixes: c2b73d1458014 ("ALSA: cs4236: cs4232 and cs4236 driver merge to solve PnP BIOS detection")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327060822.4735-1-xiam0nd.tong@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/cs423x/cs4236.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -544,7 +544,7 @@ static int snd_cs423x_pnpbios_detect(str
 	static int dev;
 	int err;
 	struct snd_card *card;
-	struct pnp_dev *cdev;
+	struct pnp_dev *cdev, *iter;
 	char cid[PNP_ID_LEN];
 
 	if (pnp_device_is_isapnp(pdev))
@@ -560,9 +560,11 @@ static int snd_cs423x_pnpbios_detect(str
 	strcpy(cid, pdev->id[0].id);
 	cid[5] = '1';
 	cdev = NULL;
-	list_for_each_entry(cdev, &(pdev->protocol->devices), protocol_list) {
-		if (!strcmp(cdev->id[0].id, cid))
+	list_for_each_entry(iter, &(pdev->protocol->devices), protocol_list) {
+		if (!strcmp(iter->id[0].id, cid)) {
+			cdev = iter;
 			break;
+		}
 	}
 	err = snd_cs423x_card_new(&pdev->dev, dev, &card);
 	if (err < 0)


