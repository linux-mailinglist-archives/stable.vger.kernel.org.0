Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4556036AD52
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhDZHdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232681AbhDZHdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEB5611CD;
        Mon, 26 Apr 2021 07:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422382;
        bh=zKOSe2vlocg7WUvmY+9ry+wdhhjgyeOWSVPmg63RPYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMY7LYzTmzcidDH9ih2j1Ao2HwA+kM500rIBwjogbvmJDqgS6Yh3BNk/h7MgnbEyn
         /Yyn+6N5K7XAgPMjU3pxauQD6mKf8zrwcTmLL74Zt8giIK+MfB49K0QItV9bp95mFH
         IBj8FH1MnMflBe3h2A5cSw0/u2/4ioqKsTu1kNnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 4.9 27/37] usbip: synchronize event handler with sysfs code paths
Date:   Mon, 26 Apr 2021 09:29:28 +0200
Message-Id: <20210426072818.168255922@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814 upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to synchronize event handler with sysfs paths
in usbip drivers.

Cc: stable@vger.kernel.org # 4.9.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -84,6 +84,7 @@ static void event_handler(struct work_st
 	while ((ud = get_event()) != NULL) {
 		usbip_dbg_eh("pending event %lx\n", ud->event);
 
+		mutex_lock(&ud->sysfs_lock);
 		/*
 		 * NOTE: shutdown must come first.
 		 * Shutdown the device.
@@ -104,6 +105,7 @@ static void event_handler(struct work_st
 			ud->eh_ops.unusable(ud);
 			unset_event(ud, USBIP_EH_UNUSABLE);
 		}
+		mutex_unlock(&ud->sysfs_lock);
 
 		wake_up(&ud->eh_waitq);
 	}


