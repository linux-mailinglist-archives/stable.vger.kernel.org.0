Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E939812C510
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfL2Rde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbfL2Rde (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E555207FD;
        Sun, 29 Dec 2019 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640813;
        bh=tuRipZte5EqskJXk8kD1/fPZoHKEC/8f/pLxDLZ6hIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bURsVCl9+Rui7rCzX+5Ewe6WTDVExQC9FWnVI0+Jzxc1vgTFzi1c/1IZW8Y3mkOM3
         crfZe2Ba8xqnTKTikc7KN3BIa3fZnPPUDC60ElI77XKjAS6vOi+R8UWa+cKMaIhTzy
         7J+imMxIMEc9mRc5MQ0a02KhHeEHlE3IIThwZlJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/219] EDAC/ghes: Fix grain calculation
Date:   Sun, 29 Dec 2019 18:19:11 +0100
Message-Id: <20191229162530.890383917@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

[ Upstream commit 7088e29e0423d3195e09079b4f849ec4837e5a75 ]

The current code to convert a physical address mask to a grain
(defined as granularity in bytes) is:

	e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);

This is broken in several ways:

1) It calculates to wrong grain values. E.g., a physical address mask
of ~0xfff should give a grain of 0x1000. Without considering
PAGE_MASK, there is an off-by-one. Things are worse when also
filtering it with ~PAGE_MASK. This will calculate to a grain with the
upper bits set. In the example it even calculates to ~0.

2) The grain does not depend on and is unrelated to the kernel's
page-size. The page-size only matters when unmapping memory in
memory_failure(). Smaller grains are wrongly rounded up to the
page-size, on architectures with a configurable page-size (e.g. arm64)
this could round up to the even bigger page-size of the hypervisor.

Fix this with:

	e->grain = ~mem_err->physical_addr_mask + 1;

The grain_bits are defined as:

	grain = 1 << grain_bits;

Change also the grain_bits calculation accordingly, it is the same
formula as in edac_mc.c now and the code can be unified.

The value in ->physical_addr_mask coming from firmware is assumed to
be contiguous, but this is not sanity-checked. However, in case the
mask is non-contiguous, a conversion to grain_bits effectively
converts the grain bit mask to a power of 2 by rounding it up.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20191106093239.25517-11-rrichter@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ghes_edac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 574bce603337..78c339da19b5 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -210,6 +210,7 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 	/* Cleans the error report buffer */
 	memset(e, 0, sizeof (*e));
 	e->error_count = 1;
+	e->grain = 1;
 	strcpy(e->label, "unknown label");
 	e->msg = pvt->msg;
 	e->other_detail = pvt->other_detail;
@@ -305,7 +306,7 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 
 	/* Error grain */
 	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
-		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+		e->grain = ~mem_err->physical_addr_mask + 1;
 
 	/* Memory error location, mapped on e->location */
 	p = e->location;
@@ -412,8 +413,13 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 	if (p > pvt->other_detail)
 		*(p - 1) = '\0';
 
+	/* Sanity-check driver-supplied grain value. */
+	if (WARN_ON_ONCE(!e->grain))
+		e->grain = 1;
+
+	grain_bits = fls_long(e->grain - 1);
+
 	/* Generate the trace event */
-	grain_bits = fls_long(e->grain);
 	snprintf(pvt->detail_location, sizeof(pvt->detail_location),
 		 "APEI location: %s %s", e->location, e->other_detail);
 	trace_mc_event(type, e->msg, e->label, e->error_count,
-- 
2.20.1



