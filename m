Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D06103F6A
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfKTPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52796 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730019AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004b8-O3; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004Hm-M5; Wed, 20 Nov 2019 15:40:11 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Sakamoto" <o-takashi@sakamocchi.jp>,
        "Wenwen Wang" <wenwen@cs.uga.edu>, "Takashi Iwai" <tiwai@suse.de>
Date:   Wed, 20 Nov 2019 15:37:39 +0000
Message-ID: <lsq.1574264230.903988427@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 29/83] ALSA: firewire: fix a memory leak bug
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wenwen Wang <wenwen@cs.uga.edu>

commit 1be3c1fae6c1e1f5bb982b255d2034034454527a upstream.

In iso_packets_buffer_init(), 'b->packets' is allocated through
kmalloc_array(). Then, the aligned packet size is checked. If it is
larger than PAGE_SIZE, -EINVAL will be returned to indicate the error.
However, the allocated 'b->packets' is not deallocated on this path,
leading to a memory leak.

To fix the above issue, free 'b->packets' before returning the error code.

Fixes: 31ef9134eb52 ("ALSA: add LaCie FireWire Speakers/Griffin FireWave Surround driver")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/firewire/packets-buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/packets-buffer.c
+++ b/sound/firewire/packets-buffer.c
@@ -37,7 +37,7 @@ int iso_packets_buffer_init(struct iso_p
 	packets_per_page = PAGE_SIZE / packet_size;
 	if (WARN_ON(!packets_per_page)) {
 		err = -EINVAL;
-		goto error;
+		goto err_packets;
 	}
 	pages = DIV_ROUND_UP(count, packets_per_page);
 

