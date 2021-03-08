Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529A5330E1C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCHMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhCHMfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8EBA651C9;
        Mon,  8 Mar 2021 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206901;
        bh=r6N5Zhyem6HwrLfimFVavGfkEULHdCoK2CqW5nji3LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6X6nB8EWmLv7e1AT79NZe6agIqhHfB7UBZFuhRI9v+cX1lrNeypMPMc78kji4SJr
         EXXbOY0mud2a05GsNVycRf6LaI49mCy3uu4idkfx1oSmVNyqKz7NYJtmcLw06ccqMz
         rUMlnzHfum0YcOapVA64OwPHY/j8RDfSSp29vTkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 19/42] dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size
Date:   Mon,  8 Mar 2021 13:30:45 +0100
Message-Id: <20210308122719.074645706@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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


