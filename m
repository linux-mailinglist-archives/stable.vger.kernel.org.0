Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF797304AC9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbhAZE6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731055AbhAYStY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95D92075B;
        Mon, 25 Jan 2021 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600548;
        bh=3WQ4TWdDfTGlpfHk1Z82IGVxdGnBaaVtMMiqEt9kHRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwbHhhNw+0/c7/y6MK5uJ219+gQX2IZwh/umLmaWghIRkoqBi50cS1pnsU1+8sqV4
         9OqCPHyCTuHQLlHEVHsy3cIamo9J6icxNrmlXjTWIOb/6T6VH9F0GICtnvJi+suusA
         /56nTC/wdnNEWfTolVD1YQd2fHlCn0w++/NXs+Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Daniel Glockner <dg@emlix.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 027/199] dm integrity: conditionally disable "recalculate" feature
Date:   Mon, 25 Jan 2021 19:37:29 +0100
Message-Id: <20210125183217.402457614@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5c02406428d5219c367c5f53457698c58bc5f917 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |   12 +++++-
 drivers/md/dm-integrity.c                                |   26 +++++++++++++--
 2 files changed, 33 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -177,14 +177,20 @@ bitmap_flush_interval:number
 	The bitmap flush interval in milliseconds. The metadata buffers
 	are synchronized when this interval expires.
 
+allow_discards
+	Allow block discard requests (a.k.a. TRIM) for the integrity device.
+	Discards are only allowed to devices using internal hash.
+
 fix_padding
 	Use a smaller padding of the tag area that is more
 	space-efficient. If this option is not present, large padding is
 	used - that is for compatibility with older kernels.
 
-allow_discards
-	Allow block discard requests (a.k.a. TRIM) for the integrity device.
-	Discards are only allowed to devices using internal hash.
+legacy_recalculate
+	Allow recalculating of volumes with HMAC keys. This is disabled by
+	default for security reasons - an attacker could modify the volume,
+	set recalc_sector to zero, and the kernel would not detect the
+	modification.
 
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
 allow_discards can be changed when reloading the target (load an inactive
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -257,8 +257,9 @@ struct dm_integrity_c {
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
-	bool fix_padding;
 	bool discard;
+	bool fix_padding;
+	bool legacy_recalculate;
 
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
@@ -386,6 +387,14 @@ static int dm_integrity_failed(struct dm
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
@@ -3140,6 +3149,7 @@ static void dm_integrity_status(struct d
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
+		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
 		       ic->tag_size, ic->mode, arg_count);
 		if (ic->meta_dev)
@@ -3163,6 +3173,8 @@ static void dm_integrity_status(struct d
 		}
 		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
 			DMEMIT(" fix_padding");
+		if (ic->legacy_recalculate)
+			DMEMIT(" legacy_recalculate");
 
 #define EMIT_ALG(a, n)							\
 		do {							\
@@ -3792,7 +3804,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 15, "Invalid number of feature args"},
+		{0, 16, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;
@@ -3940,6 +3952,8 @@ static int dm_integrity_ctr(struct dm_ta
 			ic->discard = true;
 		} else if (!strcmp(opt_string, "fix_padding")) {
 			ic->fix_padding = true;
+		} else if (!strcmp(opt_string, "legacy_recalculate")) {
+			ic->legacy_recalculate = true;
 		} else {
 			r = -EINVAL;
 			ti->error = "Invalid argument";
@@ -4243,6 +4257,14 @@ try_smaller_buffer:
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


