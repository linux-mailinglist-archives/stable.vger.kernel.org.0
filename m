Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D337B61579A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKBCfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKBCfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:35:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3A1958D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36B77CE1F13
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A0CC433D6;
        Wed,  2 Nov 2022 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356508;
        bh=ZpLQM7mj45VKglW85KxYHXZz0cuB5q3FCXUk9y8X4Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYg+xvC6AZhRRgiFAVB5k5afiPuk1lU8UvL9SxFHUdl1ASo6GV8TUX+dF6ruiOepu
         BMtxMsD6BE2grIqKJykYZbC9f4fOLDdnv+gvZhjpeR73OLqho4WsMs5q6Nvx1b5Oxf
         VBkw9qiURy21zxWoA892OdX52V0FpuLtaSws+74o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 012/240] ALSA: emu10k1: Use snd_ctl_rename() to rename a control
Date:   Wed,  2 Nov 2022 03:29:47 +0100
Message-Id: <20221102022111.686478937@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit 36476b81b2b5db1de5adb8ced1f71b8972a9d4dd upstream.

With the recent addition of hashed controls lookup it's not enough to just
update the control name field, the hash entries for the modified control
have to be updated too.

snd_ctl_rename() takes care of that, so use it instead of directly
modifying the control name.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/38b19f019f95ee78a6e4e59d39afb9e2c3379413.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emumixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/emu10k1/emumixer.c b/sound/pci/emu10k1/emumixer.c
index e9c0fe3b8446..3c115f8ab96c 100644
--- a/sound/pci/emu10k1/emumixer.c
+++ b/sound/pci/emu10k1/emumixer.c
@@ -1767,7 +1767,7 @@ static int rename_ctl(struct snd_card *card, const char *src, const char *dst)
 {
 	struct snd_kcontrol *kctl = ctl_find(card, src);
 	if (kctl) {
-		strcpy(kctl->id.name, dst);
+		snd_ctl_rename(card, kctl, dst);
 		return 0;
 	}
 	return -ENOENT;
-- 
2.38.1



