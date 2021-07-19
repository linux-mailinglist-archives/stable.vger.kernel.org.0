Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CDD3CDE59
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbhGSPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343578AbhGSO7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8AA9610A5;
        Mon, 19 Jul 2021 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709018;
        bh=u4UdE8j93cevc9q+wDk5Yz5C2snzK3ng5PDQJKTT+mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjhypKEPSF4rx8H6WkGs9ERAHLIg/9dcc/pKDX5N6K9rpv8XkT4iS8u7fUXzQHmDK
         LxNuJ5OVqHNe5MxOZYIEPmK6HYdQ3blmBjffuWJNvjC+SecGWCkYQJbfK3ZgfcJFSQ
         V4yiTqiIuu3h6n8GvhMaliMxpWcHwxBtUcIiSHYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/421] char: pcmcia: error out if num_bytes_read is greater than 4 in set_protocol()
Date:   Mon, 19 Jul 2021 16:49:59 +0200
Message-Id: <20210719144952.934938020@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 37188559c610f1b7eec83c8e448936c361c578de ]

Theoretically, it will cause index out of bounds error if
'num_bytes_read' is greater than 4. As we expect it(and was tested)
never to be greater than 4, error out if it happens.

Fixes: c1986ee9bea3 ("[PATCH] New Omnikey Cardman 4000 driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210521120617.138396-1-yukuai3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/pcmcia/cm4000_cs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index a219964cb770..cdc72db29ae0 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -544,6 +544,10 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 		io_read_num_rec_bytes(iobase, &num_bytes_read);
 		if (num_bytes_read >= 4) {
 			DEBUGP(2, dev, "NumRecBytes = %i\n", num_bytes_read);
+			if (num_bytes_read > 4) {
+				rc = -EIO;
+				goto exit_setprotocol;
+			}
 			break;
 		}
 		mdelay(10);
-- 
2.30.2



