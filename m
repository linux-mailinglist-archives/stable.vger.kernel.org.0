Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6151918B59
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEIONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46928 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-00012B-La; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006MZ-Gw; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Dennis Zhou" <dennis@kernel.org>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.661826111@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 10/10] percpu: stop printing kernel addresses
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Croce <mcroce@redhat.com>

commit 00206a69ee32f03e6f40837684dcbe475ea02266 upstream.

Since commit ad67b74d2469d9b8 ("printk: hash addresses printed with %p"),
at boot "____ptrval____" is printed instead of actual addresses:

    percpu: Embedded 38 pages/cpu @(____ptrval____) s124376 r0 d31272 u524288

Instead of changing the print to "%px", and leaking kernel addresses,
just remove the print completely, cfr. e.g. commit 071929dbdd865f77
("arm64: Stop printing the virtual memory layout").

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/percpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1716,8 +1716,8 @@ int __init pcpu_embed_first_chunk(size_t
 #endif
 	}
 
-	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
-		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
+	pr_info("PERCPU: Embedded %zu pages/cpu s%zu r%zu d%zu u%zu\n",
+		PFN_DOWN(size_sum), ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
 	rc = pcpu_setup_first_chunk(ai, base);
@@ -1830,8 +1830,8 @@ int __init pcpu_page_first_chunk(size_t
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu d%zu\n",
-		unit_pages, psize_str, vm.addr, ai->static_size,
+	pr_info("PERCPU: %d %s pages/cpu s%zu r%zu d%zu\n",
+		unit_pages, psize_str, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
 
 	rc = pcpu_setup_first_chunk(ai, vm.addr);

