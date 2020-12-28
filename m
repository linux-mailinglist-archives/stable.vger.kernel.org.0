Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55272E3F22
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgL1Ofm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504973AbgL1OdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35990225AB;
        Mon, 28 Dec 2020 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165983;
        bh=6JxeLSvVfNl3d8vdNUwnJStAh6gVTC73te8NftzIOWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgGXl31AcOBdFbeYVCmw/Mzrll5FOTNg7mLWsraoIr6Xyq0Pz8PVCr5cxSfOhX4Qz
         Xynrh0AFqYlcbVa5ZgRHO/kSzUJyQvgwz/PupeDvmBkRjC0zViVeHeDf93v3w50ehH
         tBy1vjctBQZ+wf8c0CK0URce9p8D323w15mWLfzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 717/717] null_blk: Fail zone append to conventional zones
Date:   Mon, 28 Dec 2020 13:51:55 +0100
Message-Id: <20201228125055.351891985@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 2e896d89510f23927ec393bee1e0570db3d5a6c6 upstream.

Conventional zones do not have a write pointer and so cannot accept zone
append writes. Make sure to fail any zone append write command issued to
a conventional zone.

Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/null_blk_zoned.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -339,8 +339,11 @@ static blk_status_t null_zone_write(stru
 
 	trace_nullb_zone_op(cmd, zno, zone->cond);
 
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+		if (append)
+			return BLK_STS_IOERR;
 		return null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
+	}
 
 	null_lock_zone(dev, zno);
 


