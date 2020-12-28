Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACA2E381B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgL1NFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730639AbgL1NFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:05:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E4A22582;
        Mon, 28 Dec 2020 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160693;
        bh=cuG2EWNI1cFolkhOiqv8KOvsbGLH9LY64J4Fo3gkaJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2f7cqKNjgzflsxL3huHFxuRDHt0HX5rbqJznZDlZ9lZOLuU6S0Nf3bnxW0fYvjP0L
         RwuF5gudu7vHuTlDMP0xank96r8M0BvcvU3c7uehjfgWh63MnMZH2GZp7air/0EYTI
         zrOKo4oo+8nyjAqh5T2m36zmOIYg+DbfW3bNp6GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 138/175] ALSA: usb-audio: Disable sample read check if firmware doesnt give back
Date:   Mon, 28 Dec 2020 13:49:51 +0100
Message-Id: <20201228124859.934142007@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -327,6 +327,12 @@ static int set_sample_rate_v1(struct snd
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


