Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA26568B38A
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 02:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBFBD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 20:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBFBDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 20:03:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108C5D537;
        Sun,  5 Feb 2023 17:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675645405; x=1707181405;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p3cJbdfBQzbXgLwCpMurOEl3oekEj08Qxoo3cX7rCec=;
  b=X5XV5SF7dVYfv53QwVVGbEhdhn4OT71WXRkFOX8nhVyBJ2+Ja407c0Bs
   TFKgzn6X1Aiw0yC4T3+vxvVIYnymDbCjHNVXEaCuiLZQTseU+f7nx0+wr
   V8G0r1jiorHVAWHcEeVVvAPXjmN/nafADqKP+Rbqp6EVY5hj1FciAP1Z7
   ViP6u/gWCxZuNH8IdaOxDR0NPI/lOOuQoQ5Hn0w8vtQ8LwTzf+40w3wZv
   Dn+an039/64w6HArMtcFMxi5ifEC9lQiw16tG1/7gX4Yu2o+6yBuJTKGb
   lP0ZIhtaLU7jfCBAzDGK1bHjtEAu9U7MXOSQa6/ZjMziR+i73UwfnDBHz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="312763215"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="312763215"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 17:03:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="616291328"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616291328"
Received: from mkrysak-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.255.187])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 17:03:24 -0800
Subject: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Date:   Sun, 05 Feb 2023 17:03:24 -0800
Message-ID: <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A passthrough decoder is a decoder that maps only 1 target. It is a
special case because it does not impose any constraints on the
interleave-math as compared to a decoder with multiple targets. Extend
the passthrough case to multi-target-capable decoders that only have one
target selected. I.e. the current code was only considering passthrough
*ports* which are only a subset of the potential passthrough decoder
scenarios.

Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c82d3b6f3d1f..34cf95217901 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1019,10 +1019,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 		int i, distance;
 
 		/*
-		 * Passthrough ports impose no distance requirements between
+		 * Passthrough decoders impose no distance requirements between
 		 * peers
 		 */
-		if (port->nr_dports == 1)
+		if (cxl_rr->nr_targets == 1)
 			distance = 0;
 		else
 			distance = p->nr_targets / cxl_rr->nr_targets;

