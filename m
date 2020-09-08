Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C126168B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgIHRNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731794AbgIHQTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117672485F;
        Tue,  8 Sep 2020 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579929;
        bh=1BZhO4+UQ67mZNfApbi5PQu9vhFmjk3MHNhnyVGGy3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V3dYgjRVNfMIlQKCyLjgRL5hfHeC/xduEAn92GQXYamRmVQsvE76AksEss/qq4V9
         QewW+Je9vjkDc8v+qF+AAOFuQAYI+GYkg8LxJioITWeZxLrkDBzEcSfuaMcRX1P5Kj
         Qk8QqRzot6vH/52MHqyuh5THnmssANyNHvS40908=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Sivec <sivec@posteo.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 091/129] ALSA: usb-audio: Add implicit feedback quirk for UR22C
Date:   Tue,  8 Sep 2020 17:25:32 +0200
Message-Id: <20200908152234.284393777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Sivec <sivec@posteo.net>

commit 7c5b892e0871655fea3294ffac6fa3cc3400b60d upstream.

This uses the same quirk as the Motu and SSL2 devices.
Tested on the UR22C.

Fixes bug 208851.

Signed-off-by: Joshua Sivec <sivec@posteo.net>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208851
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200825165515.8239-1-sivec@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -356,6 +356,7 @@ static int set_sync_ep_implicit_fb_quirk
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
 	case USB_ID(0x31e9, 0x0001): /* Solid State Logic SSL2 */
 	case USB_ID(0x31e9, 0x0002): /* Solid State Logic SSL2+ */
+	case USB_ID(0x0499, 0x172f): /* Steinberg UR22C */
 	case USB_ID(0x0d9a, 0x00df): /* RTX6001 */
 		ep = 0x81;
 		ifnum = 2;


