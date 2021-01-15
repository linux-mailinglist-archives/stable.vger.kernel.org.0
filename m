Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70F22F7BC6
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbhAONFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732647AbhAOMba (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B1723370;
        Fri, 15 Jan 2021 12:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713863;
        bh=nuIHiwNqJXh2xY9skYdyFQFpAYUgosbDWknWX8Xop+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07ZESMtFalBz/1TyooNfdSwG3idb4XlTz4FDplTKcmBd7d1ORtWjY6LireNxcjwwR
         IXiRF0+O8SAeHLsykoFsZmGClC2DTb7S5aGMxRK8mKBBJKlbLkTrIuf8CjMOMmqtQ0
         jxiJgKadgpIyZGsAMIlEGSFzSyLGucEfqusH0RSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 12/28] iio: imu: st_lsm6dsx: flip irq return logic
Date:   Fri, 15 Jan 2021 13:27:49 +0100
Message-Id: <20210115121957.363993114@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit ec76d918f23034f9f662539ca9c64e2ae3ba9fba upstream

No need for using reverse logic in the irq return,
fix this by flip things around.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -401,7 +401,7 @@ static irqreturn_t st_lsm6dsx_handler_th
 	count = st_lsm6dsx_read_fifo(hw);
 	mutex_unlock(&hw->fifo_lock);
 
-	return !count ? IRQ_NONE : IRQ_HANDLED;
+	return count ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_buffer_preenable(struct iio_dev *iio_dev)


