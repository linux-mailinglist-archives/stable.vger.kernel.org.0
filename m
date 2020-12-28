Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACA22E3BBF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407402AbgL1NyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407400AbgL1NyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3ACB205CB;
        Mon, 28 Dec 2020 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163606;
        bh=szQs4ZqUCDQKYF2cv1WOcuBpGMFzvkTRpW1YLoJOZkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJdlHFeKGItOnlfDODBcYVKfhYN9xccxrSdnH1j+YwXySqmEZ50fnLDK+UDX5EbNW
         Z09d6LB0cDt2yczVA+TXNN8YLN5Er4se2qRSb26Ue7hFWfNJ2vdw26tKHZjhBaPGUa
         T0NpWi9h/EiIplAtrwPiJvNiVdNCT40f/OSLS8to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 345/453] ALSA: usb-audio: Disable sample read check if firmware doesnt give back
Date:   Mon, 28 Dec 2020 13:49:41 +0100
Message-Id: <20201228124953.821547919@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9df28edce7c6ab38050235f6f8b43dd7ccd01b6d upstream.

Some buggy firmware don't give the current sample rate but leaves
zero.  Handle this case more gracefully without warning but just skip
the current rate verification from the next time.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201218145858.2357-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/clock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -531,6 +531,12 @@ static int set_sample_rate_v1(struct snd
 	}
 
 	crate = data[0] | (data[1] << 8) | (data[2] << 16);
+	if (!crate) {
+		dev_info(&dev->dev, "failed to read current rate; disabling the check\n");
+		chip->sample_rate_read_error = 3; /* three strikes, see above */
+		return 0;
+	}
+
 	if (crate != rate) {
 		dev_warn(&dev->dev, "current rate %d is different from the runtime rate %d\n", crate, rate);
 		// runtime->rate = crate;


