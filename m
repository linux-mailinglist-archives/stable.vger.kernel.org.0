Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C36D4861
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjDCO2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjDCO2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40964191F3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD65B81C23
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BFAC433EF;
        Mon,  3 Apr 2023 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532086;
        bh=ofs2jD6JL/nr2hVtNEEt4cyqmDWgNc/8F3k/RHHvP8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHaOwbzBRWL5Dn/ozHkfE+tKrO72E5PlpEkSLoheaY/bD3kX/31KOqgi2Rr18XwMB
         BHro62TgUCXUfe1CNYzCqchau4hPBCxZnEQ20V7OcKVay2RFwTbTzyPR0SCPhyv9r1
         4z2bhaxKspdsM54pEhaNY8HA9+BgBDmdX0y7CbdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH 5.10 080/173] usb: gadget: u_audio: dont let userspace block driver unbind
Date:   Mon,  3 Apr 2023 16:08:15 +0200
Message-Id: <20230403140417.008576908@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

commit 6c67ed9ad9b83e453e808f9b31a931a20a25629b upstream.

In the unbind callback for f_uac1 and f_uac2, a call to snd_card_free()
via g_audio_cleanup() will disconnect the card and then wait for all
resources to be released, which happens when the refcount falls to zero.
Since userspace can keep the refcount incremented by not closing the
relevant file descriptor, the call to unbind may block indefinitely.
This can cause a deadlock during reboot, as evidenced by the following
blocked task observed on my machine:

  task:reboot  state:D stack:0   pid:2827  ppid:569    flags:0x0000000c
  Call trace:
   __switch_to+0xc8/0x140
   __schedule+0x2f0/0x7c0
   schedule+0x60/0xd0
   schedule_timeout+0x180/0x1d4
   wait_for_completion+0x78/0x180
   snd_card_free+0x90/0xa0
   g_audio_cleanup+0x2c/0x64
   afunc_unbind+0x28/0x60
   ...
   kernel_restart+0x4c/0xac
   __do_sys_reboot+0xcc/0x1ec
   __arm64_sys_reboot+0x28/0x30
   invoke_syscall+0x4c/0x110
   ...

The issue can also be observed by opening the card with arecord and
then stopping the process through the shell before unbinding:

  # arecord -D hw:UAC2Gadget -f S32_LE -c 2 -r 48000 /dev/null
  Recording WAVE '/dev/null' : Signed 32 bit Little Endian, Rate 48000 Hz, Stereo
  ^Z[1]+  Stopped                    arecord -D hw:UAC2Gadget -f S32_LE -c 2 -r 48000 /dev/null
  # echo gadget.0 > /sys/bus/gadget/drivers/configfs-gadget/unbind
  (observe that the unbind command never finishes)

Fix the problem by using snd_card_free_when_closed() instead, which will
still disconnect the card as desired, but defer the task of freeing the
resources to the core once userspace closes its file descriptor.

Fixes: 132fcb460839 ("usb: gadget: Add Audio Class 2.0 Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Reviewed-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20230302163648.3349669-1-alvin@pqrs.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -613,7 +613,7 @@ void g_audio_cleanup(struct g_audio *g_a
 	uac = g_audio->uac;
 	card = uac->card;
 	if (card)
-		snd_card_free(card);
+		snd_card_free_when_closed(card);
 
 	kfree(uac->p_prm.ureq);
 	kfree(uac->c_prm.ureq);


