Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2117E8D902
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfHNREi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfHNREe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765B1214DA;
        Wed, 14 Aug 2019 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802273;
        bh=LPfPacdqzNLUM0fy/JrApmF/4SQTkvNzeA5k+KvbKKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpvMPPlvGZoxiMDaPCZoJQinVJvrWYDuIUyVDTzxzL3LntyikZbEq1kHYIWqmxcEp
         u6xcMJKQTXGI6ssq6EXubBYpJSrg13u7pSVz50wZzCnQw3KCP4p+mKYPalaQWyHIR+
         OJDAj4mILNLfKWjaxsOfK32/g+TSu8VRYtUaagqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.2 036/144] genirq/affinity: Create affinity mask for single vector
Date:   Wed, 14 Aug 2019 18:59:52 +0200
Message-Id: <20190814165801.335390862@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 491beed3b102b6e6c0e7734200661242226e3933 upstream.

Since commit c66d4bd110a1f8 ("genirq/affinity: Add new callback for
(re)calculating interrupt sets"), irq_create_affinity_masks() returns
NULL in case of single vector. This change has caused regression on some
drivers, such as lpfc.

The problem is that single vector requests can happen in some generic cases:

  1) kdump kernel

  2) irq vectors resource is close to exhaustion.

If in that situation the affinity mask for a single vector is not created,
every caller has to handle the special case.

There is no reason why the mask cannot be created, so remove the check for
a single vector and create the mask.

Fixes: c66d4bd110a1f8 ("genirq/affinity: Add new callback for (re)calculating interrupt sets")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190805011906.5020-1-ming.lei@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/affinity.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -253,11 +253,9 @@ irq_create_affinity_masks(unsigned int n
 	 * Determine the number of vectors which need interrupt affinities
 	 * assigned. If the pre/post request exhausts the available vectors
 	 * then nothing to do here except for invoking the calc_sets()
-	 * callback so the device driver can adjust to the situation. If there
-	 * is only a single vector, then managing the queue is pointless as
-	 * well.
+	 * callback so the device driver can adjust to the situation.
 	 */
-	if (nvecs > 1 && nvecs > affd->pre_vectors + affd->post_vectors)
+	if (nvecs > affd->pre_vectors + affd->post_vectors)
 		affvecs = nvecs - affd->pre_vectors - affd->post_vectors;
 	else
 		affvecs = 0;


