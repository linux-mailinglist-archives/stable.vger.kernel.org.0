Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78A23A40B
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHCMWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgHCMWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516BD2076B;
        Mon,  3 Aug 2020 12:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457324;
        bh=Ra0sNR3wVYMaJ2vnp53y3iy9sBigv+XID83l4LIHiJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqQ8Qu1ji+goK4z4XZjO8SxV9bqFzu3DFSGIun3EjytOUFRD//2V5kpVFtXtw8vWm
         H6DmMDfa3AO9aS/ueixpb/5oNJerpUuba2kOz2xULsg1yod/bffjIjb3SUOuMNSuui
         eW4jg+kMuW7JCJ31FSeXYkf0PuVule7glkcMr3NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry <dpavlushko@gmail.com>,
        Laurence Tratt <laurie@tratt.net>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 003/120] ALSA: usb-audio: Add implicit feedback quirk for SSL2
Date:   Mon,  3 Aug 2020 14:17:41 +0200
Message-Id: <20200803121903.032661965@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurence Tratt <laurie@tratt.net>

commit 3da87ec67a491b9633a82045896c076b794bf938 upstream.

As expected, this requires the same quirk as the SSL2+ in order for the
clock to sync. This was suggested by, and tested on an SSL2, by Dmitry.

Suggested-by: Dmitry <dpavlushko@gmail.com>
Signed-off-by: Laurence Tratt <laurie@tratt.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200621075005.52mjjfc6dtdjnr3h@overdrive.tratt.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -367,6 +367,7 @@ static int set_sync_ep_implicit_fb_quirk
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+	case USB_ID(0x31e9, 0x0001): /* Solid State Logic SSL2 */
 	case USB_ID(0x31e9, 0x0002): /* Solid State Logic SSL2+ */
 	case USB_ID(0x0d9a, 0x00df): /* RTX6001 */
 		ep = 0x81;


