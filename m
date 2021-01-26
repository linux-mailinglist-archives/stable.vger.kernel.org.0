Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8958A304BE2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbhAZV45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:56:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392438AbhAZR7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611683876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p9VIkEjgV6LmYhA2YGMiaRvwDiPVcCHIF5TfSu17MrE=;
        b=OqgOi4DKHIS4R+x8vi5gs9MlLeLmWO0G2tlMIYrUcwjsfnlzZy5adpJ3XbilmXqW47AfsX
        FOCEQIx/cQrtCvXMSXjBIfF9yuuDpOXcTp1XRgNu2+1Q9B9WnGbYkLgFDdijR1d9uSPaOW
        /0orcXhUqEYKJ4k1gFPMY73JQVil18c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-22wtDDh0M9G_517SDnTkgA-1; Tue, 26 Jan 2021 12:57:54 -0500
X-MC-Unique: 22wtDDh0M9G_517SDnTkgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED8808017FB;
        Tue, 26 Jan 2021 17:57:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEFAD10023AB;
        Tue, 26 Jan 2021 17:57:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 10QHvnZJ021031;
        Tue, 26 Jan 2021 12:57:49 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 10QHvmdg021028;
        Tue, 26 Jan 2021 12:57:48 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 26 Jan 2021 12:57:48 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     dg@emlix.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm integrity: conditionally disable
 "recalculate" feature" failed to apply to 5.4-stable tree
In-Reply-To: <161149489911460@kroah.com>
Message-ID: <alpine.LRH.2.02.2101261256560.17343@file01.intranet.prod.int.rdu2.redhat.com>
References: <161149489911460@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Here I'm submitting the updated patch for the 5.4 branch.

Mikulas



commit 5c02406428d5219c367c5f53457698c58bc5f917
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Jan 20 13:59:11 2021 -0500

    dm integrity: conditionally disable "recalculate" feature
    
    Otherwise a malicious user could (ab)use the "recalculate" feature
    that makes dm-integrity calculate the checksums in the background
    while the device is already usable. When the system restarts before all
    checksums have been calculated, the calculation continues where it was
    interrupted even if the recalculate feature is not requested the next
    time the dm device is set up.
    
    Disable recalculating if we use internal_hash or journal_hash with a
    key (e.g. HMAC) and we don't have the "legacy_recalculate" flag.
    
    This may break activation of a volume, created by an older kernel,
    that is not yet fully recalculated -- if this happens, the user should
    add the "legacy_recalculate" flag to constructor parameters.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Reported-by: Daniel Glockner <dg@emlix.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-stable/Documentation/admin-guide/device-mapper/dm-integrity.rst
===================================================================
--- linux-stable.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ linux-stable/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -177,6 +177,12 @@ bitmap_flush_interval:number
 	The bitmap flush interval in milliseconds. The metadata buffers
 	are synchronized when this interval expires.
 
+legacy_recalculate
+	Allow recalculating of volumes with HMAC keys. This is disabled by
+	default for security reasons - an attacker could modify the volume,
+	set recalc_sector to zero, and the kernel would not detect the
+	modification.
+
 
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time can
 be changed when reloading the target (load an inactive table and swap the
Index: linux-stable/drivers/md/dm-integrity.c
===================================================================
--- linux-stable.orig/drivers/md/dm-integrity.c
+++ linux-stable/drivers/md/dm-integrity.c
@@ -254,6 +254,7 @@ struct dm_integrity_c {
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
+	bool legacy_recalculate;
 
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
@@ -381,6 +382,14 @@ static int dm_integrity_failed(struct dm
 	return READ_ONCE(ic->failed);
 }
 
+static bool dm_integrity_disable_recalculate(struct dm_integrity_c *ic)
+{
+	if ((ic->internal_hash_alg.key || ic->journal_mac_alg.key) &&
+	    !ic->legacy_recalculate)
+		return true;
+	return false;
+}
+
 static commit_id_t dm_integrity_commit_id(struct dm_integrity_c *ic, unsigned i,
 					  unsigned j, unsigned char seq)
 {
@@ -2998,6 +3007,7 @@ static void dm_integrity_status(struct d
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
+		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, (unsigned long long)ic->start,
 		       ic->tag_size, ic->mode, arg_count);
 		if (ic->meta_dev)
@@ -3017,6 +3027,8 @@ static void dm_integrity_status(struct d
 			DMEMIT(" sectors_per_bit:%llu", (unsigned long long)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit);
 			DMEMIT(" bitmap_flush_interval:%u", jiffies_to_msecs(ic->bitmap_flush_interval));
 		}
+		if (ic->legacy_recalculate)
+			DMEMIT(" legacy_recalculate");
 
 #define EMIT_ALG(a, n)							\
 		do {							\
@@ -3625,7 +3637,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 15, "Invalid number of feature args"},
+		{0, 14, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;
@@ -3769,6 +3781,8 @@ static int dm_integrity_ctr(struct dm_ta
 				goto bad;
 		} else if (!strcmp(opt_string, "recalculate")) {
 			ic->recalculate_flag = true;
+		} else if (!strcmp(opt_string, "legacy_recalculate")) {
+			ic->legacy_recalculate = true;
 		} else {
 			r = -EINVAL;
 			ti->error = "Invalid argument";
@@ -4061,6 +4075,14 @@ try_smaller_buffer:
 		}
 	}
 
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+	    le64_to_cpu(ic->sb->recalc_sector) < ic->provided_data_sectors &&
+	    dm_integrity_disable_recalculate(ic)) {
+		ti->error = "Recalculating with HMAC is disabled for security reasons - if you really need it, use the argument \"legacy_recalculate\"";
+		r = -EOPNOTSUPP;
+		goto bad;
+	}
+
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
 			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
 	if (IS_ERR(ic->bufio)) {

