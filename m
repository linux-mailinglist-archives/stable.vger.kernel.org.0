Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D10304BE3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbhAZV5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390856AbhAZSA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 13:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611683941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i3m7L7t4Xv6mq7etY0enKbP3qm76KT2iti3OojSAAJI=;
        b=YuFp9lXkBwfeTPFLeYpsptvFDE/7eY56/UNDgpeeWfRCZZCzwgaX3P6CAAWLGQK7aY9Fsb
        Itpl9ypBpPybGm28R+XNiJKwGx+vymEpxCGtuCuzk9kb4zet3/h/PjjhPLhDvEdg11hm24
        PiZi5j0RDKDV0ntSQPn1HizhsOgT9UQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-pa1IbNM0OaC_ekq9no7T5g-1; Tue, 26 Jan 2021 12:58:59 -0500
X-MC-Unique: pa1IbNM0OaC_ekq9no7T5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45295180A092;
        Tue, 26 Jan 2021 17:58:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13EBF10023AB;
        Tue, 26 Jan 2021 17:58:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 10QHwshT021070;
        Tue, 26 Jan 2021 12:58:54 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 10QHwskQ021066;
        Tue, 26 Jan 2021 12:58:54 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 26 Jan 2021 12:58:54 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     dg@emlix.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm integrity: conditionally disable
 "recalculate" feature" failed to apply to 4.19-stable tree
In-Reply-To: <161149490013291@kroah.com>
Message-ID: <alpine.LRH.2.02.2101261258110.17343@file01.intranet.prod.int.rdu2.redhat.com>
References: <161149490013291@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Sun, 24 Jan 2021, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

Here I'm submitting the updated patch for the 4.19 kernel.

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

Index: linux-stable/drivers/md/dm-integrity.c
===================================================================
--- linux-stable.orig/drivers/md/dm-integrity.c
+++ linux-stable/drivers/md/dm-integrity.c
@@ -240,6 +240,7 @@ struct dm_integrity_c {
 
 	bool journal_uptodate;
 	bool just_formatted;
+	bool legacy_recalculate;
 
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
@@ -345,6 +346,14 @@ static int dm_integrity_failed(struct dm
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
@@ -2503,6 +2512,7 @@ static void dm_integrity_status(struct d
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
+		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, (unsigned long long)ic->start,
 		       ic->tag_size, ic->mode, arg_count);
 		if (ic->meta_dev)
@@ -2516,6 +2526,8 @@ static void dm_integrity_status(struct d
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
 		DMEMIT(" journal_watermark:%u", (unsigned)watermark_percentage);
 		DMEMIT(" commit_time:%u", ic->autocommit_msec);
+		if (ic->legacy_recalculate)
+			DMEMIT(" legacy_recalculate");
 
 #define EMIT_ALG(a, n)							\
 		do {							\
@@ -3118,7 +3130,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 15, "Invalid number of feature args"},
+		{0, 12, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool recalculate;
@@ -3248,6 +3260,8 @@ static int dm_integrity_ctr(struct dm_ta
 				goto bad;
 		} else if (!strcmp(opt_string, "recalculate")) {
 			recalculate = true;
+		} else if (!strcmp(opt_string, "legacy_recalculate")) {
+			ic->legacy_recalculate = true;
 		} else {
 			r = -EINVAL;
 			ti->error = "Invalid argument";
@@ -3517,6 +3531,14 @@ try_smaller_buffer:
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
Index: linux-stable/Documentation/device-mapper/dm-integrity.txt
===================================================================
--- linux-stable.orig/Documentation/device-mapper/dm-integrity.txt
+++ linux-stable/Documentation/device-mapper/dm-integrity.txt
@@ -146,6 +146,13 @@ block_size:number
 	Supported values are 512, 1024, 2048 and 4096 bytes.  If not
 	specified the default block size is 512 bytes.
 
+legacy_recalculate
+	Allow recalculating of volumes with HMAC keys. This is disabled by
+	default for security reasons - an attacker could modify the volume,
+	set recalc_sector to zero, and the kernel would not detect the
+	modification.
+
+
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time can
 be changed when reloading the target (load an inactive table and swap the
 tables with suspend and resume). The other arguments should not be changed

