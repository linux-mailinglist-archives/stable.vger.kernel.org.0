Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD52171F0
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgGGP07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgGGP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1209020663;
        Tue,  7 Jul 2020 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135617;
        bh=yDWefRkMe9qUEJoLyvTql1Q8OuXw7bj+6Z9/PVE7/3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKtDu4Xwa0ePraPYRs667tcuePTpRQ7NkdzuraCyci5V2vkDCQdLoEjZJpxmoEGdH
         6hLA70mEhgaWOHEYIVdiG1cJYwS4occzsAXmdZmEwmE0yDF+6fSzyOx13Ul1Ys7+48
         Y/y4fwEb0/OUyXsZozvJW29mcGGmg/cu1P9OQ/AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.7 111/112] dm zoned: assign max_io_len correctly
Date:   Tue,  7 Jul 2020 17:17:56 +0200
Message-Id: <20200707145806.250219721@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.

The unit of max_io_len is sector instead of byte (spotted through
code review), so fix it.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/md/dm-zoned-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -790,7 +790,7 @@ static int dmz_ctr(struct dm_target *ti,
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dev->zone_nr_sectors << 9;
+	ti->max_io_len = dev->zone_nr_sectors;
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;


