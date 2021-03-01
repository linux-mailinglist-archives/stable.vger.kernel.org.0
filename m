Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE2328E2F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241441AbhCATZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241392AbhCATVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82F865127;
        Mon,  1 Mar 2021 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618206;
        bh=4sHXrqDz9kVEAjtox2y2yr6ns0ba4hNjeAYi0ZHiqAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlXpdfmTq4QoDG1qqt07R5cIksz+QcuFrCWvuGSoYtDR0MPp0sLW3hREaW755oVlN
         nqUlUgkwoJj+2rWnqCF1IOkPHPquw0fwOnAfzhB6vY3WLHq1brKSzWjLSxO8MyEWki
         BWnBvvGSBt6qxHjx09m8UfCcsJ2vdrwWetlAHZds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 329/340] dm era: only resize metadata in preresume
Date:   Mon,  1 Mar 2021 17:14:33 +0100
Message-Id: <20210301161104.485543932@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit cca2c6aebe86f68103a8615074b3578e854b5016 upstream.

Metadata resize shouldn't happen in the ctr. The ctr loads a temporary
(inactive) table that will only become active upon resume. That is why
resize should always be done in terms of resume. Otherwise a load (ctr)
whose inactive table never becomes active will incorrectly resize the
metadata.

Also, perform the resize directly in preresume, instead of using the
worker to do it.

The worker might run other metadata operations, e.g., it could start
digestion, before resizing the metadata. These operations will end up
using the old size.

This could lead to errors, like:

  device-mapper: era: metadata_digest_transcribe_writeset: dm_array_set_value failed
  device-mapper: era: process_old_eras: digest step failed, stopping digestion

The reason of the above error is that the worker started the digestion
of the archived writeset using the old, larger size.

As a result, metadata_digest_transcribe_writeset tried to write beyond
the end of the era array.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1501,15 +1501,6 @@ static int era_ctr(struct dm_target *ti,
 	}
 	era->md = md;
 
-	era->nr_blocks = calc_nr_blocks(era);
-
-	r = metadata_resize(era->md, &era->nr_blocks);
-	if (r) {
-		ti->error = "couldn't resize metadata";
-		era_destroy(era);
-		return -ENOMEM;
-	}
-
 	era->wq = alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM);
 	if (!era->wq) {
 		ti->error = "could not create workqueue for metadata object";
@@ -1586,9 +1577,17 @@ static int era_preresume(struct dm_targe
 	dm_block_t new_size = calc_nr_blocks(era);
 
 	if (era->nr_blocks != new_size) {
-		r = in_worker1(era, metadata_resize, &new_size);
-		if (r)
+		r = metadata_resize(era->md, &new_size);
+		if (r) {
+			DMERR("%s: metadata_resize failed", __func__);
+			return r;
+		}
+
+		r = metadata_commit(era->md);
+		if (r) {
+			DMERR("%s: metadata_commit failed", __func__);
 			return r;
+		}
 
 		era->nr_blocks = new_size;
 	}


