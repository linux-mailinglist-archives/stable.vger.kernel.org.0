Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D00396141
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhEaOho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhEaOfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AEBC61C43;
        Mon, 31 May 2021 13:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469060;
        bh=nyc10DwBaetmEFQ6b1FKSSzvX7sk3sts3UMZXY6bnJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UPTP5t87/+3iXiwrRumUtDVCZL9QCIriTYW7s0To2R+FibAvqZ8ZL71TK2jqMcNR
         ycDYvPyT76fugXX8QtD3uWHxQR4Q6uiNVWRZiyuccCiZMJm6v2dwdogb2RBQ4VE6eS
         NstLOT61v5jiCvZmxLonBih7YFwvk7yEBNAHHNmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Dazinger <spam02@dazinger.net>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Subject: [PATCH 5.12 053/296] md/raid5: remove an incorrect assert in in_chunk_boundary
Date:   Mon, 31 May 2021 15:11:48 +0200
Message-Id: <20210531130705.606176292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit cc146267914950b12c2bdee68c1e9e5453c81cde upstream.

Now that the original bdev is stored in the bio this assert is incorrect
and will trigger for any partitioned raid5 device.

Reported-by: Florian Dazinger <spam02@dazinger.net>
Tested-by: Florian Dazinger <spam02@dazinger.net>
Cc: stable@vger.kernel.org # 5.12
Fixes: 309dca309fc3 ("block: store a block_device pointer in struct bio"),
Reviewed-by:  Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5310,8 +5310,6 @@ static int in_chunk_boundary(struct mdde
 	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bio_sectors(bio);
 
-	WARN_ON_ONCE(bio->bi_bdev->bd_partno);
-
 	chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
 	return  chunk_sectors >=
 		((sector & (chunk_sectors - 1)) + bio_sectors);


