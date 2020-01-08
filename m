Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13A8134BBB
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgAHTqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43810 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730475AbgAHTqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:05 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006ol-AT; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dmx-9q; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Laura Abbott" <labbott@redhat.com>,
        sprd-ind-kernel-group@googlegroups.com,
        sanjeev.yadav@spreadtrum.com, "Arnd Bergmann" <arnd@arndb.de>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        "Colin Cross" <ccross@android.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Rajmal Menariya" <rajmal.menariya@spreadtrum.com>,
        "Android Kernel Team" <kernel-team@android.com>,
        "John Stultz" <john.stultz@linaro.org>
Date:   Wed, 08 Jan 2020 19:43:29 +0000
Message-ID: <lsq.1578512578.378705478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 31/63] staging: ion: Set minimum carveout heap
 allocation order to PAGE_SHIFT
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

From: Rajmal Menariya <rajmal.menariya@spreadtrum.com>

commit 1328d8efef17d5e16bd6e9cfe59130a833674534 upstream.

In carveout heap, change minimum allocation order from 12 to
PAGE_SHIFT. After this change each bit in bitmap (genalloc -
General purpose special memory pool) represents one page size
memory.

Cc: sprd-ind-kernel-group@googlegroups.com
Cc: sanjeev.yadav@spreadtrum.com
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Rajmal Menariya <rajmal.menariya@spreadtrum.com>
[jstultz: Reworked commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Acked-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -168,7 +168,7 @@ struct ion_heap *ion_carveout_heap_creat
 	if (!carveout_heap)
 		return ERR_PTR(-ENOMEM);
 
-	carveout_heap->pool = gen_pool_create(12, -1);
+	carveout_heap->pool = gen_pool_create(PAGE_SHIFT, -1);
 	if (!carveout_heap->pool) {
 		kfree(carveout_heap);
 		return ERR_PTR(-ENOMEM);

