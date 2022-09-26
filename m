Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC45E9FB3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiIZK2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiIZK0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:26:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F8B1EC4E;
        Mon, 26 Sep 2022 03:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03227B80942;
        Mon, 26 Sep 2022 10:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F87C433C1;
        Mon, 26 Sep 2022 10:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187500;
        bh=rroXjO0hPS+la9RzEK8lIbpNpqMPNTiAv9RECnaoBgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3FTvtzPxBC93tc4WKE89rrG222PRN2JnalcDz1yUZhR79nCbTpWCdf+42IQls5VK
         RYCAbWpI19k8cGe/vl6dzV/g+UascX4AQ35PNQ9YM2/cJmqCmYbA2aPzMw8x2DgrYY
         mt34O0D8GB1FyKUbLOPB32xjrSy/tJiypAgVmiIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 28/58] ALSA: hda/tegra: set depop delay for tegra
Date:   Mon, 26 Sep 2022 12:11:47 +0200
Message-Id: <20220926100742.490384416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
@@ -3455,6 +3455,7 @@ static int patch_tegra_hdmi(struct hda_c
 	if (err)
 		return err;
 
+	codec->depop_delay = 10;
 	codec->patch_ops.build_pcms = tegra_hdmi_build_pcms;
 	spec = codec->spec;
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =


