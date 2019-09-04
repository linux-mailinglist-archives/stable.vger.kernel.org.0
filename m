Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF088A90CC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbfIDSLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfIDSLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4AD2087E;
        Wed,  4 Sep 2019 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620707;
        bh=2+lDASw6thM+eORtmapA7D8758mNopZ9lXcWqgfi+5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdhyAnDBdVMXztfBVDTzszZeBYQIp7CAfUJE/tQ1xTuivNYDGefXUO5wpobkRj4Yp
         yo58Mp0ufjTGdLiSVUkePPW1MHer4yAwzKcul73HZHjiBaV/YW7HIaXWqcHxyGoqwp
         +Y1yIoovGcVk56hTjuRAmerwNvJB7XgkWP8WgvLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 066/143] ALSA: usb-audio: Add implicit fb quirk for Behringer UFX1604
Date:   Wed,  4 Sep 2019 19:53:29 +0200
Message-Id: <20190904175316.650655704@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1a15718b41df026cffd0e42cfdc38a1384ce19f9 upstream.

Behringer UFX1604 requires the similar quirk to apply implicit fb like
another Behringer model UFX1204 in order to fix the noisy playback.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204631
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -339,6 +339,7 @@ static int set_sync_ep_implicit_fb_quirk
 		ep = 0x81;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x1397, 0x0001): /* Behringer UFX1604 */
 	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */
 		ep = 0x81;
 		ifnum = 1;


