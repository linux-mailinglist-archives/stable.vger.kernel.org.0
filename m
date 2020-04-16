Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEE1AC32C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896831AbgDPNjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897931AbgDPNjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2AC421BE5;
        Thu, 16 Apr 2020 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044358;
        bh=rYEbbTZpOvYM3lyWTrWeTlys/rHzSaPGXH+mvSyaYi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRp9yvR+QbyQqA4XsLuEB8LdG4Hy47ey6TpbT9sGh/G7tYqQ+z0O0aaOkpbdD3mms
         a56qJd2Ng/qDPn60rPOxn1PR3VPSDZlghzSu8+9ceGPQ2DBMsWcxnfz1hdLF6k9+K3
         CYz5+XwN9r1sxK4kfNxaEe3VXdplCqqQaAL/T4D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 185/257] dm clone: Add overflow check for number of regions
Date:   Thu, 16 Apr 2020 15:23:56 +0200
Message-Id: <20200416131349.450708706@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit cd481c12269b4d276f1a52eda0ebd419079bfe3a upstream.

Add overflow check for clone->nr_regions variable, which holds the
number of regions of the target.

The overflow can occur with sufficiently large devices, if BITS_PER_LONG
== 32. E.g., if the region size is 8 sectors (4K), the overflow would
occur for device sizes > 34359738360 sectors (~16TB).

This could result in multiple device sectors wrongly mapping to the same
region number, due to the truncation from 64 bits to 32 bits, which
would lead to data corruption.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-clone-target.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1790,6 +1790,7 @@ error:
 static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
+	sector_t nr_regions;
 	struct clone *clone;
 	struct dm_arg_set as;
 
@@ -1831,7 +1832,16 @@ static int clone_ctr(struct dm_target *t
 		goto out_with_source_dev;
 
 	clone->region_shift = __ffs(clone->region_size);
-	clone->nr_regions = dm_sector_div_up(ti->len, clone->region_size);
+	nr_regions = dm_sector_div_up(ti->len, clone->region_size);
+
+	/* Check for overflow */
+	if (nr_regions != (unsigned long)nr_regions) {
+		ti->error = "Too many regions. Consider increasing the region size";
+		r = -EOVERFLOW;
+		goto out_with_source_dev;
+	}
+
+	clone->nr_regions = nr_regions;
 
 	r = validate_nr_regions(clone->nr_regions, &ti->error);
 	if (r)


