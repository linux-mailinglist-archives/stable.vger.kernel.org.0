Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C094690645
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjBILPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBILPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136F247402;
        Thu,  9 Feb 2023 03:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9260B820F0;
        Thu,  9 Feb 2023 11:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389C2C433D2;
        Thu,  9 Feb 2023 11:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941309;
        bh=5d+9PlcVs72/SwBwickPbffpbNEh+EgpSD5hr+nLxRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5jmaAsQ12W8PyjZVCICZ3hO18c1RzNpFIJIukcWijgbhrROGvUrF/sfZVlUKpLSl
         gRtLlO/ISvAXeRJ+3QE7W8EufeYSTtHnWu8IOl9SvMEBI1gOWyE/jfwvDqLgvmTQlO
         s+Sf74AVX0ILE+d2I90Cv3dizf03UF0m3cIEZop+iEVPwGVtKPP70EQNxChjCbXDxo
         yWbl7Jz5AQtNX3SgJdgQ1jTvRjn/3PJhsBcEvcEO8d0dyoC2cVIDVvgpFeWvnMWrxk
         vgpfTf0Z0eugLbxKbQ0ri2bDMpPLhTr4M8DGU/TiJiVnMiUVta3aRVCsDOUsbsOrh+
         bGaIhIYptUpXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, sdoregor@sdore.me,
        aichao@kylinos.cn, cyrozap@gmail.com, john-linux@pelago.org.uk,
        jussi@sonarnerd.net, connerknoxpublic@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 03/38] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum610 Wireless
Date:   Thu,  9 Feb 2023 06:14:22 -0500
Message-Id: <20230209111459.1891941-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dfd5fe19db7dc7006642f8109ee8965e5d031897 ]

JBL Quantum610 Wireless (0ecb:205c) requires the same workaround that
was used for JBL Quantum810 for limiting the sample rate.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216798
Link: https://lore.kernel.org/r/20230118165947.22317-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 3d13fdf7590cd..3ecd1ba7fd4b1 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
 		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
+	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 
-- 
2.39.0

