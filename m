Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5B49407
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfFQVXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbfFQVXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBAA0208E4;
        Mon, 17 Jun 2019 21:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806594;
        bh=LoHlJZBEv0RrFbmc7NuM7XQI0oTKz8RtuWr9Qov2/a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiOOsKcfTlkoXaeB4OV4SGRQ9cXii+zNYs7wHD+ZBhKxds1TXepqzpCx5VQtB+EGl
         TVyEa3j4FMVhcYvGR1AvnXPuil9hAkGT6DZUyXwbffM108P8tYQlyXrMAgnpfv1crH
         2gS+OGS1bOmmr5JRHc/Q3OCeEQg1CHn/Nq7U55VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: [PATCH 5.1 107/115] RAS/CEC: Fix binary search function
Date:   Mon, 17 Jun 2019 23:10:07 +0200
Message-Id: <20190617210805.428973654@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit f3c74b38a55aefe1004200d15a83f109b510068c upstream.

Switch to using Donald Knuth's binary search algorithm (The Art of
Computer Programming, vol. 3, section 6.2.1). This should've been done
from the very beginning but the author must've been smoking something
very potent at the time.

The problem with the current one was that it would return the wrong
element index in certain situations:

  https://lkml.kernel.org/r/CAM_iQpVd02zkVJ846cj-Fg1yUNuz6tY5q1Vpj4LrXmE06dPYYg@mail.gmail.com

and the noodling code after the loop was fishy at best.

So switch to using Knuth's binary search. The final result is much
cleaner and straightforward.

Fixes: 011d82611172 ("RAS: Add a Corrected Errors Collector")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ras/cec.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -181,32 +181,38 @@ static void cec_work_fn(struct work_stru
  */
 static int __find_elem(struct ce_array *ca, u64 pfn, unsigned int *to)
 {
+	int min = 0, max = ca->n - 1;
 	u64 this_pfn;
-	int min = 0, max = ca->n;
 
-	while (min < max) {
-		int tmp = (max + min) >> 1;
+	while (min <= max) {
+		int i = (min + max) >> 1;
 
-		this_pfn = PFN(ca->array[tmp]);
+		this_pfn = PFN(ca->array[i]);
 
 		if (this_pfn < pfn)
-			min = tmp + 1;
+			min = i + 1;
 		else if (this_pfn > pfn)
-			max = tmp;
-		else {
-			min = tmp;
-			break;
+			max = i - 1;
+		else if (this_pfn == pfn) {
+			if (to)
+				*to = i;
+
+			return i;
 		}
 	}
 
+	/*
+	 * When the loop terminates without finding @pfn, min has the index of
+	 * the element slot where the new @pfn should be inserted. The loop
+	 * terminates when min > max, which means the min index points to the
+	 * bigger element while the max index to the smaller element, in-between
+	 * which the new @pfn belongs to.
+	 *
+	 * For more details, see exercise 1, Section 6.2.1 in TAOCP, vol. 3.
+	 */
 	if (to)
 		*to = min;
 
-	this_pfn = PFN(ca->array[min]);
-
-	if (this_pfn == pfn)
-		return min;
-
 	return -ENOKEY;
 }
 


