Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A36B330E52
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhCHMg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232346AbhCHMgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC32651FF;
        Mon,  8 Mar 2021 12:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206976;
        bh=G4hjZ3pTt/gyN4ds4qkwqIP5gSY2c06+DqtESeOAgIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1jvaDO37rWWDFyKhs41psUEEiV16Lqi5kWcTo1JUggiI+OxAKT01BtpJQZYdwgtC
         vCKtzXZWQIVgN8R8YBNlr6devHwKDA6qn8ECj7KYqJUS71yZvay0zd6FRMEXfGGTdP
         KMvw3Owv/OhhOr/Kv70gl4g6RPj6CNbEGn02nlsc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 23/44] dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size
Date:   Mon,  8 Mar 2021 13:35:01 +0100
Message-Id: <20210308122719.718755688@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Mikulas Patocka <mpatocka@redhat.com>

commit a14e5ec66a7a66e57b24e2469f9212a78460207e upstream.

dm_bufio_get_device_size returns the device size in blocks. Before
returning the value, we must subtract the nubmer of starting
sectors. The number of starting sectors may not be divisible by block
size.

Note that currently, no target is using dm_bufio_set_sector_offset and
dm_bufio_get_device_size simultaneously, so this change has no effect.
However, an upcoming dm-verity-fec fix needs this change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1526,6 +1526,10 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_siz
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (s >= c->start)
+		s -= c->start;
+	else
+		s = 0;
 	if (likely(c->sectors_per_block_bits >= 0))
 		s >>= c->sectors_per_block_bits;
 	else


