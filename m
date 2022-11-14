Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E58627F4F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiKNM52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbiKNM51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:57:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC07327CF5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591AD61154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC76C433D6;
        Mon, 14 Nov 2022 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430645;
        bh=t7zT8+wEbJWt0aZp/zsZWDeomMN4gQ6fjDyC64xiFVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q60/d0x1puEMMT5P18/0OMSMLRIwCi1U8rEs6qUZ5H3KjApGNGFdOdYlGZDuurC9e
         74Hpd0xAQ5Tk3Plan8hwRASfQNA1aHkgINzVjyB0tOyDxmemum6IHKIKEYBeXCDcO6
         K6GbtcVn6ddvgyb1pxcZHWkxN4dGV8nM2nuBdliM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 089/131] ALSA: hda/hdmi - enable runtime pm for more AMD display audio
Date:   Mon, 14 Nov 2022 13:45:58 +0100
Message-Id: <20221114124452.489753000@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit fdcc4c22b7ab20e90b97f8bc6225d876b72b8f16 upstream.

We are able to power down the GPU and audio via the GPU driver
so flag these asics as supporting runtime pm.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221108084746.583058-1-evan.quan@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2687,6 +2687,9 @@ static const struct pci_device_id azx_id
 	{ PCI_DEVICE(0x1002, 0xab28),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_DEVICE(0x1002, 0xab30),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },


