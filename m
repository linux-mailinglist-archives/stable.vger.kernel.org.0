Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735923E1B5A
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhHESba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 14:31:30 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34694 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238354AbhHESba (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 14:31:30 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 175IUtew022438;
        Thu, 5 Aug 2021 20:30:55 +0200
Date:   Thu, 5 Aug 2021 20:30:55 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210805183055.GA21961@1wt.eu>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <20210805164254.GG17808@1wt.eu>
 <20210805172949.GA3691426@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805172949.GA3691426@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 10:29:49AM -0700, Guenter Roeck wrote:
> > It looks like a typical "works for me" regression. The best thing that
> > could possibly be done to limit such occurrences would be to wait "long
> > enough" before backporting them, in hope to catch breakage reports before
> > the backport, but here there were already 3 weeks between the patch was
> > submitted and it was backported.
> 
> No. The patch is wrong. It just _looks_ correct at first glance.

So that's the core of the problem. Stable maintainers cannot be tasked
to try to analyse each patch in its finest details to figure whether a
maintainer that's expected to be more knowledgeable than them on their
driver did something wrong.

Then in my opinion we should encourage *not* to use "Fixes:" on untested
patches (untested patches will always happen due to hardware availability
or lack of a reliable reproducer).

What about this to try to improve the situation in this specific case ?

Willy


From ef646bae2139ba005de78940064c464126c430e6 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Thu, 5 Aug 2021 20:24:30 +0200
Subject: docs: process: submitting-patches.rst: recommend against 'Fixes:' if
 untested

'Fixes:' usually is taken as authority and often results in a backport. If
a patch couldn't be tested although it looks perfectly valid, better not
add this tag to leave a final chance for backporters to ask about the
relevance of the backport or to check for future tests.

Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Documentation/process/submitting-patches.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index 0852bcf73630..54782b0e2f4c 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -140,6 +140,15 @@ An example call::
 	$ git log -1 --pretty=fixes 54a4f0239f2e
 	Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return the number of pages it actually freed")
 
+Please note that a 'Fixes:' tag will most often result in your patch being
+automatically backported to stable branches. If for any reason you could not
+test that it really fixes the problem (for example, because the bug is not
+reproducible, or because you did not have access to the required hardware
+at the time of writing the patch to verify it does not cause regressions),
+even if you are absolutely certain of your patch's validity, do not include
+a 'Fixes:' tag and instead explain the situation in the commit message in
+plain English.
+
 .. _split_changes:
 
 Separate your changes
-- 
2.17.5

