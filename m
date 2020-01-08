Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F47134C05
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgAHTs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43614 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730439AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006ov-BY; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnR-Fk; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Will Deacon" <will.deacon@arm.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "James Morse" <james.morse@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Date:   Wed, 08 Jan 2020 19:43:35 +0000
Message-ID: <lsq.1578512578.174710898@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 37/63] PM / Hibernate: Call flush_icache_range() on
 pages restored in-place
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit f6cf0545ec697ddc278b7457b7d0c0d86a2ea88e upstream.

Some architectures require code written to memory as if it were data to be
'cleaned' from any data caches before the processor can fetch them as new
instructions.

During resume from hibernate, the snapshot code copies some pages directly,
meaning these architectures do not get a chance to perform their cache
maintenance. Modify the read and decompress code to call
flush_icache_range() on all pages that are restored, so that the restored
in-place pages are guaranteed to be executable on these architectures.

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
[will: make clean_pages_on_* static and remove initialisers]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/power/swap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -36,6 +36,14 @@
 #define HIBERNATE_SIG	"S1SUSPEND"
 
 /*
+ * When reading an {un,}compressed image, we may restore pages in place,
+ * in which case some architectures need these pages cleaning before they
+ * can be executed. We don't know which pages these may be, so clean the lot.
+ */
+static bool clean_pages_on_read;
+static bool clean_pages_on_decompress;
+
+/*
  *	The swap map is a data structure used for keeping track of each page
  *	written to a swap partition.  It consists of many swap_map_page
  *	structures that contain each an array of MAP_PAGE_ENTRIES swap entries.
@@ -244,6 +252,9 @@ static void hib_end_io(struct bio *bio,
 
 	if (bio_data_dir(bio) == WRITE)
 		put_page(page);
+	else if (clean_pages_on_read)
+		flush_icache_range((unsigned long)page_address(page),
+				   (unsigned long)page_address(page) + PAGE_SIZE);
 
 	if (error && !hb->error)
 		hb->error = error;
@@ -1052,6 +1063,7 @@ static int load_image(struct swap_map_ha
 
 	hib_init_batch(&hb);
 
+	clean_pages_on_read = true;
 	printk(KERN_INFO "PM: Loading image data pages (%u pages)...\n",
 		nr_to_read);
 	m = nr_to_read / 10;
@@ -1127,6 +1139,10 @@ static int lzo_decompress_threadfn(void
 		d->unc_len = LZO_UNC_SIZE;
 		d->ret = lzo1x_decompress_safe(d->cmp + LZO_HEADER, d->cmp_len,
 		                               d->unc, &d->unc_len);
+		if (clean_pages_on_decompress)
+			flush_icache_range((unsigned long)d->unc,
+					   (unsigned long)d->unc + d->unc_len);
+
 		atomic_set(&d->stop, 1);
 		wake_up(&d->done);
 	}
@@ -1192,6 +1208,8 @@ static int load_image_lzo(struct swap_ma
 	}
 	memset(crc, 0, offsetof(struct crc_data, go));
 
+	clean_pages_on_decompress = true;
+
 	/*
 	 * Start the decompression threads.
 	 */

