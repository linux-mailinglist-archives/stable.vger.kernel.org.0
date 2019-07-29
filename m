Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7F794AA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388261AbfG2TeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388245AbfG2TeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D9F2171F;
        Mon, 29 Jul 2019 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428850;
        bh=JTbbLUrqNFcBTWKuNtawhRcJdyH9435aAAWqmKj3o2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDA2ejk42ePxmcfd6iyh8zRiGAVBFpMOYd3Se2WkppzlRoLYS1916fVlFVFrJJgXP
         DPxxr7wAbZuqN26XntPlBauxpbYSEhv9EMgUp8PtcwUMEIuyosZz49MtveDbQ7iSXa
         LsSUk2ykxR05tz8Kb9wXJKayGIphxkdhdsPyEWtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 4.14 206/293] dma-buf: Discard old fence_excl on retrying get_fences_rcu for realloc
Date:   Mon, 29 Jul 2019 21:21:37 +0200
Message-Id: <20190729190840.230106531@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f5b07b04e5f090a85d1e96938520f2b2b58e4a8e upstream.

If we have to drop the seqcount & rcu lock to perform a krealloc, we
have to restart the loop. In doing so, be careful not to lose track of
the already acquired exclusive fence.

Fixes: fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: stable@vger.kernel.org #v4.10
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190604125323.21396-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/reservation.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -394,6 +394,10 @@ int reservation_object_get_fences_rcu(st
 					   GFP_NOWAIT | __GFP_NOWARN);
 			if (!nshared) {
 				rcu_read_unlock();
+
+				dma_fence_put(fence_excl);
+				fence_excl = NULL;
+
 				nshared = krealloc(shared, sz, GFP_KERNEL);
 				if (nshared) {
 					shared = nshared;


