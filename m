Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597621F106
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfEOLTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbfEOLTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4BC20862;
        Wed, 15 May 2019 11:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919185;
        bh=qWglezqHnqwnAG3+q6dzjt0VM7y2yamRGcUyrHCtAZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIVNkEMUBUIIN6wYmI/AscHWSbez/egNZ4aQZKC4zTOh68oUB7wZBm1cZRB33YtH3
         p+TjI6fSbkEtklZTfdHwQ4jiBuE5vgaW68kERsb/8jIM80LVGDnKHX3meWRhWMg2Pr
         M1eygEh0japMbzSBTJef7p7wpX8rYR/Mod5b0/z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        David Jeffery <djeffery@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 097/115] Dont jump to compute_result state from check_result state
Date:   Wed, 15 May 2019 12:56:17 +0200
Message-Id: <20190515090706.227940873@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nigel Croxon <ncroxon@redhat.com>

commit 4f4fd7c5798bbdd5a03a60f6269cf1177fbd11ef upstream.

Changing state from check_state_check_result to
check_state_compute_result not only is unsafe but also doesn't
appear to serve a valid purpose.  A raid6 check should only be
pushing out extra writes if doing repair and a mis-match occurs.
The stripe dev management will already try and do repair writes
for failing sectors.

This patch makes the raid6 check_state_check_result handling
work more like raid5's.  If somehow too many failures for a
check, just quit the check operation for the stripe.  When any
checks pass, don't try and use check_state_compute_result for
a purpose it isn't needed for and is unsafe for.  Just mark the
stripe as in sync for passing its parity checks and let the
stripe dev read/write code and the bad blocks list do their
job handling I/O errors.

Repro steps from Xiao:

These are the steps to reproduce this problem:
1. redefined OPT_MEDIUM_ERR_ADDR to 12000 in scsi_debug.c
2. insmod scsi_debug.ko dev_size_mb=11000  max_luns=1 num_tgts=1
3. mdadm --create /dev/md127 --level=6 --raid-devices=5 /dev/sde1 /dev/sde2 /dev/sde3 /dev/sde5 /dev/sde6
sde is the disk created by scsi_debug
4. echo "2" >/sys/module/scsi_debug/parameters/opts
5. raid-check

It panic:
[ 4854.730899] md: data-check of RAID array md127
[ 4854.857455] sd 5:0:0:0: [sdr] tag#80 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 4854.859246] sd 5:0:0:0: [sdr] tag#80 Sense Key : Medium Error [current]
[ 4854.860694] sd 5:0:0:0: [sdr] tag#80 Add. Sense: Unrecovered read error
[ 4854.862207] sd 5:0:0:0: [sdr] tag#80 CDB: Read(10) 28 00 00 00 2d 88 00 04 00 00
[ 4854.864196] print_req_error: critical medium error, dev sdr, sector 11656 flags 0
[ 4854.867409] sd 5:0:0:0: [sdr] tag#100 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 4854.869469] sd 5:0:0:0: [sdr] tag#100 Sense Key : Medium Error [current]
[ 4854.871206] sd 5:0:0:0: [sdr] tag#100 Add. Sense: Unrecovered read error
[ 4854.872858] sd 5:0:0:0: [sdr] tag#100 CDB: Read(10) 28 00 00 00 2e e0 00 00 08 00
[ 4854.874587] print_req_error: critical medium error, dev sdr, sector 12000 flags 4000
[ 4854.876456] sd 5:0:0:0: [sdr] tag#101 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 4854.878552] sd 5:0:0:0: [sdr] tag#101 Sense Key : Medium Error [current]
[ 4854.880278] sd 5:0:0:0: [sdr] tag#101 Add. Sense: Unrecovered read error
[ 4854.881846] sd 5:0:0:0: [sdr] tag#101 CDB: Read(10) 28 00 00 00 2e e8 00 00 08 00
[ 4854.883691] print_req_error: critical medium error, dev sdr, sector 12008 flags 4000
[ 4854.893927] sd 5:0:0:0: [sdr] tag#166 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 4854.896002] sd 5:0:0:0: [sdr] tag#166 Sense Key : Medium Error [current]
[ 4854.897561] sd 5:0:0:0: [sdr] tag#166 Add. Sense: Unrecovered read error
[ 4854.899110] sd 5:0:0:0: [sdr] tag#166 CDB: Read(10) 28 00 00 00 2e e0 00 00 10 00
[ 4854.900989] print_req_error: critical medium error, dev sdr, sector 12000 flags 0
[ 4854.902757] md/raid:md127: read error NOT corrected!! (sector 9952 on sdr1).
[ 4854.904375] md/raid:md127: read error NOT corrected!! (sector 9960 on sdr1).
[ 4854.906201] ------------[ cut here ]------------
[ 4854.907341] kernel BUG at drivers/md/raid5.c:4190!

raid5.c:4190 above is this BUG_ON:

    handle_parity_checks6()
        ...
        BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */

Cc: <stable@vger.kernel.org> # v3.16+
OriginalAuthor: David Jeffery <djeffery@redhat.com>
Cc: Xiao Ni <xni@redhat.com>
Tested-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: David Jeffy <djeffery@redhat.com>
Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4218,26 +4218,15 @@ static void handle_parity_checks6(struct
 	case check_state_check_result:
 		sh->check_state = check_state_idle;
 
+		if (s->failed > 1)
+			break;
 		/* handle a successful check operation, if parity is correct
 		 * we are done.  Otherwise update the mismatch count and repair
 		 * parity if !MD_RECOVERY_CHECK
 		 */
 		if (sh->ops.zero_sum_result == 0) {
-			/* both parities are correct */
-			if (!s->failed)
-				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
-				/* in contrast to the raid5 case we can validate
-				 * parity, but still have a failure to write
-				 * back
-				 */
-				sh->check_state = check_state_compute_result;
-				/* Returning at this point means that we may go
-				 * off and bring p and/or q uptodate again so
-				 * we make sure to check zero_sum_result again
-				 * to verify if p or q need writeback
-				 */
-			}
+			/* Any parity checked was correct */
+			set_bit(STRIPE_INSYNC, &sh->state);
 		} else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {


