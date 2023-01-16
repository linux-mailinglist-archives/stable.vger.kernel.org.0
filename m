Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6C766C45E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjAPPyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjAPPyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628E51D908
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E9BB81058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C484C433F0;
        Mon, 16 Jan 2023 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884447;
        bh=qoviJeQPkw9s+/+m31yAATR9iBNueS7boa7BdmifG5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqtO24i3IHbHdg42GOijpkPP0QlX2fcnhDBHg6/HklBHFEHKZXQ1j1FUztkCaHlRM
         i6PW2cEY/4wdnExRVTNZz7uAZcpj0pEjJ3dzN4UNCIV1nkLBLOO3rhntmTPDnkPaMQ
         FEuLux+w5rR8CDiRNbw640ZqtK00zl1uKZGTZmGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Michael Ralston <michael@ralston.id.au>
Subject: [PATCH 6.1 002/183] Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"
Date:   Mon, 16 Jan 2023 16:48:45 +0100
Message-Id: <20230116154803.444059968@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 16f1f838442dc6430d32d51ddda347b8421ec34b upstream.

This reverts commit ac5e2fb425e1121ceef2b9d1b3ffccc195d55707.

The commit caused a regression on Behringer UMC404HD (and likely
others).  As the change was meant only as a minor optimization, it's
better to revert it to address the regression.

Reported-and-tested-by: Michael Ralston <michael@ralston.id.au>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com
Link: https://lore.kernel.org/r/20230104150944.24918-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1222,6 +1222,12 @@ static int __snd_usb_parse_audio_interfa
 			if (err < 0)
 				return err;
 		}
+
+		/* try to set the interface... */
+		usb_set_interface(chip->dev, iface_no, 0);
+		snd_usb_init_pitch(chip, fp);
+		snd_usb_init_sample_rate(chip, fp, fp->rate_max);
+		usb_set_interface(chip->dev, iface_no, altno);
 	}
 	return 0;
 }


