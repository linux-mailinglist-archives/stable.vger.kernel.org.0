Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129C62F005
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfE3D7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731585AbfE3DSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96C82475F;
        Thu, 30 May 2019 03:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186313;
        bh=Npxmw6nnvgD0ZjvtCKn1B+RkWhFeIgCUudF25HHwcB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuDYpk/LUMqDsPLFXlQ4P45lDuzfzKIQfxAbuxTTyn5e2sqNB5ufhJZWDPLXqY7ng
         B2ajfskZAqL/h3ZpVyYKkzzjxej/JX9aIFztxoySOdU92JpphiSXfdDtx2rylM2q6F
         LlVcom8lFRD1mLjMo9EAzdh0JDG6zjoHMybYGpYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4.14 015/193] gfs2: Fix sign extension bug in gfs2_update_stats
Date:   Wed, 29 May 2019 20:04:29 -0700
Message-Id: <20190530030450.062891747@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 5a5ec83d6ac974b12085cd99b196795f14079037 upstream.

Commit 4d207133e9c3 changed the types of the statistic values in struct
gfs2_lkstats from s64 to u64.  Because of that, what should be a signed
value in gfs2_update_stats turned into an unsigned value.  When shifted
right, we end up with a large positive value instead of a small negative
value, which results in an incorrect variance estimate.

Fixes: 4d207133e9c3 ("gfs2: Make statistics unsigned, suitable for use with do_div()")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/lock_dlm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -31,9 +31,10 @@
  * @delta is the difference between the current rtt sample and the
  * running average srtt. We add 1/8 of that to the srtt in order to
  * update the current srtt estimate. The variance estimate is a bit
- * more complicated. We subtract the abs value of the @delta from
- * the current variance estimate and add 1/4 of that to the running
- * total.
+ * more complicated. We subtract the current variance estimate from
+ * the abs value of the @delta and add 1/4 of that to the running
+ * total.  That's equivalent to 3/4 of the current variance
+ * estimate plus 1/4 of the abs of @delta.
  *
  * Note that the index points at the array entry containing the smoothed
  * mean value, and the variance is always in the following entry
@@ -49,7 +50,7 @@ static inline void gfs2_update_stats(str
 	s64 delta = sample - s->stats[index];
 	s->stats[index] += (delta >> 3);
 	index++;
-	s->stats[index] += ((abs(delta) - s->stats[index]) >> 2);
+	s->stats[index] += (s64)(abs(delta) - s->stats[index]) >> 2;
 }
 
 /**


