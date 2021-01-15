Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB53B2F7958
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbhAOMfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbhAOMfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8FD4223E0;
        Fri, 15 Jan 2021 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714061;
        bh=74DnXYi3dJKiO9/TTjPEXWKdhmw8xpPkv/GNiT1DeLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ib1pNHZJt5f8y4k0NmzL4pm5LJ+JANchcEKtHK5DimjzHJurgq+M50NeU1ay9lv2
         IhPe96uWe2tSZ4IxXH8ntuc+QGOQwbqJ+4B+5LIuJwZKJKvbpjOQMNzUBDC0G6+hZO
         8nbJqhXnIauQc694USwtiG3Dd7OpQTxtd7iVRJOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>
Subject: [PATCH 5.4 29/62] exfat: Month timestamp metadata accidentally incremented
Date:   Fri, 15 Jan 2021 13:27:51 +0100
Message-Id: <20210115121959.811767878@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Valdis Klētnieks" <valdis.kletnieks@vt.edu>

The staging/exfat driver has departed, but a lot of distros are still tracking
5.4-stable, so we should fix this.

There was an 0/1 offset error in month handling for file metadata, causing
the month to get incremented on each reference to the file.

Thanks to Sebastian Gurtler for troubleshooting this, and Arpad Mueller
for bringing it to my attention.

Relevant discussions:
https://bugzilla.kernel.org/show_bug.cgi?id=210997
https://bugs.launchpad.net/ubuntu/+source/ubuntu-meta/+bug/1872504

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/exfat/exfat_super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/exfat/exfat_super.c
+++ b/drivers/staging/exfat/exfat_super.c
@@ -59,7 +59,7 @@ static void exfat_write_super(struct sup
 /* Convert a FAT time/date pair to a UNIX date (seconds since 1 1 70). */
 static void exfat_time_fat2unix(struct timespec64 *ts, struct date_time_t *tp)
 {
-	ts->tv_sec = mktime64(tp->Year + 1980, tp->Month + 1, tp->Day,
+	ts->tv_sec = mktime64(tp->Year + 1980, tp->Month, tp->Day,
 			      tp->Hour, tp->Minute, tp->Second);
 
 	ts->tv_nsec = tp->MilliSecond * NSEC_PER_MSEC;


