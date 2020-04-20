Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58A61B0BF0
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgDTMlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgDTMlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:41:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109AF2070B;
        Mon, 20 Apr 2020 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386464;
        bh=GP35ms7s6eukRrP35V2qI8Cv1wypBlHoorzFyo/mSfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zm9X5bmObiFPiQ8hZ7KtUXe3fVdTh+xy7Tv/7BdxJuWNZeiO9fCIVe95UzxQnjda5
         p2BdS5BbAcFK108SeAcMWeWEHw/FXlvnBkNZAcgXr+/e4oBYaPZbL4GESBwoX+LX6B
         soonqB2ALvrRsePGJ6aJRs0qiBsmrLXeXkbtVLlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.5 32/65] HID: lg-g15: Do not fail the probe when we fail to disable F# emulation
Date:   Mon, 20 Apr 2020 14:38:36 +0200
Message-Id: <20200420121513.180593904@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit b8a75eaddae9410767c7d95a1c5f3a547aae7b81 upstream.

By default the G1-G12 keys on the Logitech gaming keyboards send
F1 - F12 when in "generic HID" mode.

The first thing the hid-lg-g15 driver does is disable this behavior.

We have received a bugreport that this does not work when the keyboard
is connected through an Aten KVM switch. Using a gaming keyboard with
a KVM is a bit weird setup, but still we can try to fail a bit more
gracefully here.

On the G510 keyboards the same USB-interface which is used for the gaming
keys is also used for the media-keys. Before this commit we would call
hid_hw_stop() on failure to disable the F# emulation and then exit the
probe method with an error code.

This not only causes us to not handle the gaming-keys, but this also
breaks the media keys which is a regression compared to the situation
when these keyboards where handled by the generic hidinput driver.

This commit changes the error handling to clear the hiddev drvdata
(to disable our .raw_event handler) and then returning from the probe
method with success.

The net result of this is that, when connected through a KVM, things
work as well as they did before the hid-lg-g15 driver was introduced.

Fixes: ad4203f5a243 ("HID: lg-g15: Add support for the G510 keyboards' gaming keys")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1806321
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg-g15.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-lg-g15.c
+++ b/drivers/hid/hid-lg-g15.c
@@ -803,8 +803,10 @@ static int lg_g15_probe(struct hid_devic
 	}
 
 	if (ret < 0) {
-		hid_err(hdev, "Error disabling keyboard emulation for the G-keys\n");
-		goto error_hw_stop;
+		hid_err(hdev, "Error %d disabling keyboard emulation for the G-keys, falling back to generic hid-input driver\n",
+			ret);
+		hid_set_drvdata(hdev, NULL);
+		return 0;
 	}
 
 	/* Get initial brightness levels */


