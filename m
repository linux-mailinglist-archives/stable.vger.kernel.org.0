Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76261304AE7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbhAZEyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbhAYSsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E41221E7;
        Mon, 25 Jan 2021 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600455;
        bh=vvNPzA5gFqMlfLh1Gwv+n1spkcI5mvi58KhI6LfV4Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UN/TvPEMoUVXs7ZiJAajcex/DAmSPeF3J1fB4O66oVk+kssqJea2njZFVzjX2695T
         UFB7l+wo3yBCXPBRv3eyq92XcJyh6W2MPAjsvrKn2/TgfQgkHEkLsmYVxOaM70sPwX
         Slv22/vg4XxeDhh5zVuyguD0D/I6Kz6TXucWTm2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 021/199] mmc: core: dont initialize block size from ext_csd if not present
Date:   Mon, 25 Jan 2021 19:37:23 +0100
Message-Id: <20210125183217.153861551@linuxfoundation.org>
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

From: Peter Collingbourne <pcc@google.com>

commit b503087445ce7e45fabdee87ca9e460d5b5b5168 upstream.

If extended CSD was not available, the eMMC driver would incorrectly
set the block size to 0, as the data_sector_size field of ext_csd
was never initialized. This issue was exposed by commit 817046ecddbc
("block: Align max_hw_sectors to logical blocksize") which caused
max_sectors and max_hw_sectors to be set to 0 after setting the block
size to 0, resulting in a kernel panic in bio_split when attempting
to read from the device. Fix it by only reading the block size from
ext_csd if it is available.

Fixes: a5075eb94837 ("mmc: block: Allow disabling 512B sector size emulation")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Link: https://linux-review.googlesource.com/id/If244d178da4d86b52034459438fec295b02d6e60
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210114201405.2934886-1-pcc@google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/queue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -384,8 +384,10 @@ static void mmc_setup_queue(struct mmc_q
 		     "merging was advertised but not possible");
 	blk_queue_max_segments(mq->queue, mmc_get_max_segments(host));
 
-	if (mmc_card_mmc(card))
+	if (mmc_card_mmc(card) && card->ext_csd.data_sector_size) {
 		block_size = card->ext_csd.data_sector_size;
+		WARN_ON(block_size != 512 && block_size != 4096);
+	}
 
 	blk_queue_logical_block_size(mq->queue, block_size);
 	/*


