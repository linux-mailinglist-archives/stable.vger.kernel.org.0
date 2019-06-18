Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182444984E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 06:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfFRE0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 00:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfFRE0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 00:26:08 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854072084D;
        Tue, 18 Jun 2019 04:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560831967;
        bh=xv/fCdFQ6SfbaJzNr+4Vp5gITAmLP6lf4CXGPgHSad8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R6ur39y7TUbCZ9I9GPNBpsgEq0A7kXynJU20VbzOQGtqant4HGaLMKo1/Qfhk7cr7
         tde33KHi5Y7TxhTaqqC6+HziktP/p9+akYAS8ke5AZ3GOrAwOuR0iaD1yngtP6A7Zt
         xKHocsz345eJckm197hPRlWYwLgBSR8v5C1arUzU=
Date:   Mon, 17 Jun 2019 21:26:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] resource: Fix locking in find_next_iomem_res()
Message-Id: <20190617212605.bb8cc4571ee67879033e1bc4@linux-foundation.org>
In-Reply-To: <20190613045903.4922-2-namit@vmware.com>
References: <20190613045903.4922-1-namit@vmware.com>
        <20190613045903.4922-2-namit@vmware.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Jun 2019 21:59:01 -0700 Nadav Amit <namit@vmware.com> wrote:

> Since resources can be removed, locking should ensure that the resource
> is not removed while accessing it. However, find_next_iomem_res() does
> not hold the lock while copying the data of the resource.

Looks right to me.

> Keep holding the lock while the data is copied. While at it, change the
> return value to a more informative value. It is disregarded by the
> callers.

The kerneldoc needs a resync:

--- a/kernel/resource.c~resource-fix-locking-in-find_next_iomem_res-fix
+++ a/kernel/resource.c
@@ -326,7 +326,7 @@ EXPORT_SYMBOL(release_resource);
  *
  * If a resource is found, returns 0 and @*res is overwritten with the part
  * of the resource that's within [@start..@end]; if none is found, returns
- * -1 or -EINVAL for other invalid parameters.
+ * -ENODEV.  Returns -EINVAL for invalid parameters.
  *
  * This function walks the whole tree and not just first level children
  * unless @first_lvl is true.
_

