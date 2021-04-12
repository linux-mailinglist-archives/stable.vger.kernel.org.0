Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C8035BD24
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhDLIsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237779AbhDLIq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026A561244;
        Mon, 12 Apr 2021 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217198;
        bh=p2OwqxFHSKfHPF7Uh5dxXGlLivSDO5iVmkwk2ean3h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtxVo/K5tU6u2BZ4SIC+219OlPqqORmcTXh64xFZk98J/heyBsxeN5G3Qo253d3HL
         baHMp0JFpearccCgGHG7Ap9vUjGwqFlVC+6FwZrXvfwM06d67Hk0xsoycTPEedSCJK
         JvLnLp2SIZXvPmb9eTmMh27IMJhuBhu87J4GtLx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 5.4 039/111] usbip: synchronize event handler with sysfs code paths
Date:   Mon, 12 Apr 2021 10:40:17 +0200
Message-Id: <20210412084005.559467972@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -70,6 +70,7 @@ static void event_handler(struct work_st
 	while ((ud = get_event()) != NULL) {
 		usbip_dbg_eh("pending event %lx\n", ud->event);
 
+		mutex_lock(&ud->sysfs_lock);
 		/*
 		 * NOTE: shutdown must come first.
 		 * Shutdown the device.
@@ -90,6 +91,7 @@ static void event_handler(struct work_st
 			ud->eh_ops.unusable(ud);
 			unset_event(ud, USBIP_EH_UNUSABLE);
 		}
+		mutex_unlock(&ud->sysfs_lock);
 
 		wake_up(&ud->eh_waitq);
 	}


