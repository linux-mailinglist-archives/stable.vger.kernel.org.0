Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4696D9DF1
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395172AbfJPVzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395146AbfJPVzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:04 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37CD21D7A;
        Wed, 16 Oct 2019 21:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262904;
        bh=6kvh2ljFqUDYi5wwuIe97TZ/HrGcR9V7uAH6Lgc/6cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mafp7UBviZpeyLRW93IGrpSr8je++0AEtPs8z0f0cOIcxp1NSH9DGeKDjRk7RePMe
         LFChMKaaKQwTzLFOSV5Kdg52yBAOX2bVdmNAtFRBlYShdbGgCwLBmxY6snZ/Iu86vX
         OcceGXeme1Dd/HKu9Qax8OE4kz+Yv8CsxYgVb/vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 64/92] USB: microtek: fix info-leak at probe
Date:   Wed, 16 Oct 2019 14:50:37 -0700
Message-Id: <20191016214841.239423777@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 177238c3d47d54b2ed8f0da7a4290db492f4a057 upstream.

Add missing bulk-in endpoint sanity check to prevent uninitialised stack
data from being reported to the system log and used as endpoint
addresses.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20191003070931.17009-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/image/microtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -724,6 +724,10 @@ static int mts_usb_probe(struct usb_inte
 
 	}
 
+	if (ep_in_current != &ep_in_set[2]) {
+		MTS_WARNING("couldn't find two input bulk endpoints. Bailing out.\n");
+		return -ENODEV;
+	}
 
 	if ( ep_out == -1 ) {
 		MTS_WARNING( "couldn't find an output bulk endpoint. Bailing out.\n" );


