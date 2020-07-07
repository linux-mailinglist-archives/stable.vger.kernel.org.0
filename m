Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF981217072
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGGPRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgGGPRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:17:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 976F220663;
        Tue,  7 Jul 2020 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135027;
        bh=g1YPOiapB8xx6KVZwvvF7K1+yVd3HG9sagiVKT3VVdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tib2XvlNV5L+jgyEA4FveUFS5kB62TdUfI7TmY9Oi6dMq2+ttrWrgCgT2z7nsd2jU
         bliI3wfkdQ4hSIV1tj71OeulXQWL0iiahSj5CjFHxDivYiW/Nqoot3LfCvnNW/i0p5
         fc0mcNN0aKvmywXXER9qCNKDW7GQAOtYLdOXwhVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 26/27] dm zoned: assign max_io_len correctly
Date:   Tue,  7 Jul 2020 17:15:53 +0200
Message-Id: <20200707145750.192249323@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
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
@@ -789,7 +789,7 @@ static int dmz_ctr(struct dm_target *ti,
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dev->zone_nr_sectors << 9;
+	ti->max_io_len = dev->zone_nr_sectors;
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;


