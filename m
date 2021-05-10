Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88067378154
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhEJKZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhEJKZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C572F6147E;
        Mon, 10 May 2021 10:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642256;
        bh=sP2dQjHD2FueC4m/bS+QFiIvXArU9tbnHjslAyBS4zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVZaKfHG2rJn7/SGTpJhD9CyXbYKJpu0aUGwHbmRjyHO7uxfZPJ+vKGe3rzs2BBpn
         PtPEWAHzrRSRB1yYUfxOQdX7NcZzcIUnoi6ubqx3zKpYEZihqNCE7arQHnKbBOqIA9
         nio51eArUeZ8RP/+dJTaIq54GfET18+tTvE3VfJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seunghui Lee <sh043.lee@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 022/184] mmc: core: Set read only for SD cards with permanent write protect bit
Date:   Mon, 10 May 2021 12:18:36 +0200
Message-Id: <20210510101950.966246678@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seunghui Lee <sh043.lee@samsung.com>

commit 917a5336f2c27928be270226ab374ed0cbf3805d upstream.

Some of SD cards sets permanent write protection bit in their CSD register,
due to lifespan or internal problem. To avoid unnecessary I/O write
operations, let's parse the bits in the CSD during initialization and mark
the card as read only for this case.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
Link: https://lore.kernel.org/r/20210222083156.19158-1-sh043.lee@samsung.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -135,6 +135,9 @@ static int mmc_decode_csd(struct mmc_car
 			csd->erase_size = UNSTUFF_BITS(resp, 39, 7) + 1;
 			csd->erase_size <<= csd->write_blkbits - 9;
 		}
+
+		if (UNSTUFF_BITS(resp, 13, 1))
+			mmc_card_set_readonly(card);
 		break;
 	case 1:
 		/*
@@ -169,6 +172,9 @@ static int mmc_decode_csd(struct mmc_car
 		csd->write_blkbits = 9;
 		csd->write_partial = 0;
 		csd->erase_size = 1;
+
+		if (UNSTUFF_BITS(resp, 13, 1))
+			mmc_card_set_readonly(card);
 		break;
 	default:
 		pr_err("%s: unrecognised CSD structure version %d\n",


