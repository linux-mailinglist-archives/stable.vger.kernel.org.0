Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8965FE009
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiJMSDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiJMSCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADA916F426;
        Thu, 13 Oct 2022 11:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 807FAB82049;
        Thu, 13 Oct 2022 17:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9611C433D7;
        Thu, 13 Oct 2022 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683922;
        bh=VG1Ib82ny6UYrmzLQZzTBUrQrO8XhzWhgh+5XQUH54w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ag5Of/KA63u7kufQNaGnbndbprrHG+hA/plb2tpNidkUcIE4CHL8C2sfFjLMCiNZV
         /3U1itKqsDnKLUQrSM3DCvylnx/hVrFNmEBWaHD7g6lWBkOBbdXSDhmR1ajn1wibRK
         NUXJcE3OhXV7eZJ7OiRUoYyKmQEgNPPh17SKyA2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 08/27] ALSA: hda: Fix position reporting on Poulsbo
Date:   Thu, 13 Oct 2022 19:52:37 +0200
Message-Id: <20221013175143.828749143@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 56e696c0f0c71b77fff921fc94b58a02f0445b2c upstream.

Hans reported that his Sony VAIO VPX11S1E showed the broken sound
behavior at the start of the stream for a couple of seconds, and it
turned out that the position_fix=1 option fixes the issue.  It implies
that the position reporting is inaccurate, and very likely hitting on
all Poulsbo devices.

The patch applies the workaround for Poulsbo generically to switch to
LPIB mode instead of the default position buffer.

Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3e8697e1-87c6-7a7b-d2e8-b21f1d2f181b@redhat.com
Link: https://lore.kernel.org/r/20221001142124.7241-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2523,7 +2523,8 @@ static const struct pci_device_id azx_id
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE |
+	  AZX_DCAPS_POSFIX_LPIB },
 	/* Oaktrail */
 	{ PCI_DEVICE(0x8086, 0x080a),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },


