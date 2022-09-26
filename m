Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB7E5EA3C5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiIZLcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiIZLb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528B95466D;
        Mon, 26 Sep 2022 03:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A176B809E3;
        Mon, 26 Sep 2022 10:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45DCC43470;
        Mon, 26 Sep 2022 10:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188958;
        bh=b9f2K4jDQN+CYAqLoJZBA29j1gsqykkI4OOEG+gEnIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ssw7fjHvvByNYVTZ5LaOkmD8qSL+vaNyvPFwtX2DUSn2vYpSy1gdX3U38hO1uLz4R
         HO5CfxwHlytDPu6YZ6SeIVt3x8YV1T8KWSvJcWwHRVkqFQ/3yfbAgv+T05cCOnGkBw
         UxIFIsJlWbcWaORVZTsjH0d1D01EknDtLiVFSjwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 027/207] ALSA: hda/tegra: set depop delay for tegra
Date:   Mon, 26 Sep 2022 12:10:16 +0200
Message-Id: <20220926100807.698959137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

commit 3c4d8c24fb6c44f426e447b04800b0ed61a7b5ae upstream.

Reduce the suspend time by setting depop delay to 10ms for
tegra.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913053641.23299-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3984,6 +3984,7 @@ static int tegra_hdmi_init(struct hda_co
 
 	generic_hdmi_init_per_pins(codec);
 
+	codec->depop_delay = 10;
 	codec->patch_ops.build_pcms = tegra_hdmi_build_pcms;
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;


