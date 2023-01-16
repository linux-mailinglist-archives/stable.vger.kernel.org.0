Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C566CBD8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbjAPRTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjAPRSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:18:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2FA2C663
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A1C61055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C464EC433D2;
        Mon, 16 Jan 2023 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888277;
        bh=ermBIJuKq6MVNzmRSivKUMIfW6T7kHME4U41VF0/+iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FttSDPwXKyptUUDMibx1RBTYEu6kQ8i72MW4ldabkMTeEEDBnolYZLOjqytHtIxvi
         VuhBXyS9E38MNYsSjgxlWy3TTHCAfE3jJNNDNncNZhqDYMdOhQwV3v4hNjhN+bYQm9
         bEinxFOKEAViGTPQ4Qu1DH+SZuYXAqcSN6FIsKU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Clement Lecigne <clecigne@google.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        stable@kernel.org
Subject: [PATCH 4.19 468/521] ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF
Date:   Mon, 16 Jan 2023 16:52:10 +0100
Message-Id: <20230116154908.118583798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Clement Lecigne <clecigne@google.com>

[ Note: this is a fix that works around the bug equivalently as the
  two upstream commits:
   1fa4445f9adf ("ALSA: control - introduce snd_ctl_notify_one() helper")
   56b88b50565c ("ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF")
  but in a simpler way to fit with older stable trees -- tiwai ]

Add missing locking in ctl_elem_read_user/ctl_elem_write_user which can be
easily triggered and turned into an use-after-free.

Example code paths with SNDRV_CTL_IOCTL_ELEM_READ:

64-bits:
snd_ctl_ioctl
  snd_ctl_elem_read_user
    [takes controls_rwsem]
    snd_ctl_elem_read [lock properly held, all good]
    [drops controls_rwsem]

32-bits (compat):
snd_ctl_ioctl_compat
  snd_ctl_elem_write_read_compat
    ctl_elem_write_read
      snd_ctl_elem_read [missing lock, not good]

CVE-2023-0266 was assigned for this issue.

Signed-off-by: Clement Lecigne <clecigne@google.com>
Cc: stable@kernel.org # 5.12 and older
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control_compat.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -319,7 +319,9 @@ static int ctl_elem_read_user(struct snd
 	err = snd_power_wait(card, SNDRV_CTL_POWER_D0);
 	if (err < 0)
 		goto error;
+	down_read(&card->controls_rwsem);
 	err = snd_ctl_elem_read(card, data);
+	up_read(&card->controls_rwsem);
 	if (err < 0)
 		goto error;
 	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);
@@ -347,7 +349,9 @@ static int ctl_elem_write_user(struct sn
 	err = snd_power_wait(card, SNDRV_CTL_POWER_D0);
 	if (err < 0)
 		goto error;
+	down_write(&card->controls_rwsem);
 	err = snd_ctl_elem_write(card, file, data);
+	up_write(&card->controls_rwsem);
 	if (err < 0)
 		goto error;
 	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);


