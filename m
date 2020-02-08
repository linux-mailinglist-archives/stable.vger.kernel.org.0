Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C822156695
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgBHSfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34076 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgBHS3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fR-PD; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CRa-Ht; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oneukum@suse.com>
Date:   Sat, 08 Feb 2020 18:20:39 +0000
Message-ID: <lsq.1581185940.747726275@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 100/148] USB: uas: heed CAPACITY_HEURISTICS
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 335cbbd5762d5e5c67a8ddd6e6362c2aa42a328f upstream.

There is no need to ignore this flag. We should be as close
to storage in that regard as makes sense, so honor flags whose
cost is tiny.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20191114112758.32747-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/uas.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1004,6 +1004,12 @@ static int uas_slave_configure(struct sc
 		sdev->fix_capacity = 1;
 
 	/*
+	 * in some cases we have to guess
+	 */
+	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
+		sdev->guess_capacity = 1;
+
+	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
 	 * is write-protected.  Now that we tell the sd driver

