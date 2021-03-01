Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B30F3285EB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhCARAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhCAQyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A1464F59;
        Mon,  1 Mar 2021 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616484;
        bh=/HHHEAURaIWnwAXG4Ir+ZuS7Q8itwrj9biVWrqa6Vg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWM8n32OYBz8b9vZ96x1ITuWuJhx+qA6fvUX++E47cRWz/YnIEN8TOcMkK48cilLu
         2rB8K84PlIJE07VjruFY5wrLb9xo6IFhdgcHZ/uuGP8Uv9LQ1lIGH27MnyVVqZAUAd
         zUXa433+9cTL8Pl47WusNIovgl7Q3nTFhJCSo7wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 168/176] dm era: Reinitialize bitset cache before digesting a new writeset
Date:   Mon,  1 Mar 2021 17:14:01 +0100
Message-Id: <20210301161029.372077834@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 2524933307fd0036d5c32357c693c021ab09a0b0 upstream.

In case of devices with at most 64 blocks, the digestion of consecutive
eras uses the writeset of the first era as the writeset of all eras to
digest, leading to lost writes. That is, we lose the information about
what blocks were written during the affected eras.

The digestion code uses a dm_disk_bitset object to access the archived
writesets. This structure includes a one word (64-bit) cache to reduce
the number of array lookups.

This structure is initialized only once, in metadata_digest_start(),
when we kick off digestion.

But, when we insert a new writeset into the writeset tree, before the
digestion of the previous writeset is done, or equivalently when there
are multiple writesets in the writeset tree to digest, then all these
writesets are digested using the same cache and the cache is not
re-initialized when moving from one writeset to the next.

For devices with more than 64 blocks, i.e., the size of the cache, the
cache is indirectly invalidated when we move to a next set of blocks, so
we avoid the bug.

But for devices with at most 64 blocks we end up using the same cached
data for digesting all archived writesets, i.e., the cache is loaded
when digesting the first writeset and it never gets reloaded, until the
digestion is done.

As a result, the writeset of the first era to digest is used as the
writeset of all the following archived eras, leading to lost writes.

Fix this by reinitializing the dm_disk_bitset structure, and thus
invalidating the cache, every time the digestion code starts digesting a
new writeset.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -755,6 +755,12 @@ static int metadata_digest_lookup_writes
 	ws_unpack(&disk, &d->writeset);
 	d->value = cpu_to_le32(key);
 
+	/*
+	 * We initialise another bitset info to avoid any caching side effects
+	 * with the previous one.
+	 */
+	dm_disk_bitset_init(md->tm, &d->info);
+
 	d->nr_bits = min(d->writeset.nr_bits, md->nr_blocks);
 	d->current_bit = 0;
 	d->step = metadata_digest_transcribe_writeset;
@@ -768,12 +774,6 @@ static int metadata_digest_start(struct
 		return 0;
 
 	memset(d, 0, sizeof(*d));
-
-	/*
-	 * We initialise another bitset info to avoid any caching side
-	 * effects with the previous one.
-	 */
-	dm_disk_bitset_init(md->tm, &d->info);
 	d->step = metadata_digest_lookup_writeset;
 
 	return 0;


