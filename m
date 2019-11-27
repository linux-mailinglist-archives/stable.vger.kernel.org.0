Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD50010B7E8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfK0UiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:38:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbfK0UiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:38:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCCE215A5;
        Wed, 27 Nov 2019 20:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887082;
        bh=8I63cHGEo6Hyc38/WiEx2WOGdfG7LCz56iii/e2WbxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOi6S5X+f1+DBH8qbYYxaML1dNhrutf0jFtOp5//XH8wwJXPSP0D+AAwN6cSfpfYm
         gm8yZEXKAJizr7vIEdUeMpgZjwTSDObU4flneUwreI6klBr9kB+G3vLSc8iQDq9+lM
         /N/w9/amWuBiwYGTqkHCw8B0s8+98EIFcsT7vrww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 105/132] mmc: block: Fix tag condition with packed writes
Date:   Wed, 27 Nov 2019 21:31:36 +0100
Message-Id: <20191127203025.855011718@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit d806b46e5f496a6335ebd7f8432d2533507ce9a2 upstream.

Apparently a cut-and-paste error, 'do_data_tag' is using 'brq' for data
size even though 'brq' has not been set up. Instead use blk_rq_sectors().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1772,8 +1772,7 @@ static void mmc_blk_packed_hdr_wrq_prep(
 		do_data_tag = (card->ext_csd.data_tag_unit_size) &&
 			(prq->cmd_flags & REQ_META) &&
 			(rq_data_dir(prq) == WRITE) &&
-			((brq->data.blocks * brq->data.blksz) >=
-			 card->ext_csd.data_tag_unit_size);
+			blk_rq_bytes(prq) >= card->ext_csd.data_tag_unit_size;
 		/* Argument of CMD23 */
 		packed_cmd_hdr[(i * 2)] = cpu_to_le32(
 			(do_rel_wr ? MMC_CMD23_ARG_REL_WR : 0) |


