Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A31328ABD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbhCASWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239542AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F533650CF;
        Mon,  1 Mar 2021 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620655;
        bh=f9NRaC5Oh62uXWYTZTMNKQcmTsrA5jD5yC9ZKfyJqik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn2rA91sJ/bCaPF8wGlD9cy0BHKD41opmc/hMG1qnccn7pCnVogMTelbtldMidq7e
         Kg9Xf4jXa3LJkM7oW7vWIZnTY4S+2SJBbo0SZyu1ss0d+V1reQs19Iu6w+1BIYGtPN
         EAFWbZD3288gB1K9oxSlRB3w4ASaArD3/h3ysEMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 230/775] mtd: phram: use div_u64_rem to stop overwrite len in phram_setup
Date:   Mon,  1 Mar 2021 17:06:38 +0100
Message-Id: <20210301161212.995927005@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit dc2b3e5cbc8087224fcd8698b0dc56131e0bf37d ]

We now support user to set erase page size, and use do_div between len
and erase size to determine the reasonableness for the erase size.
However, do_div is a macro and will overwrite the value of len. Which
results a mtd device with unexcepted size. Fix it by use div_u64_rem.

Fixes: ffad560394de ("mtd: phram: Allow the user to set the erase page size.")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210125124936.651812-1-yangerkun@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/phram.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index cfd170946ba48..5b04ae6c30573 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -222,6 +222,7 @@ static int phram_setup(const char *val)
 	uint64_t start;
 	uint64_t len;
 	uint64_t erasesize = PAGE_SIZE;
+	uint32_t rem;
 	int i, ret;
 
 	if (strnlen(val, sizeof(buf)) >= sizeof(buf))
@@ -263,8 +264,11 @@ static int phram_setup(const char *val)
 		}
 	}
 
+	if (erasesize)
+		div_u64_rem(len, (uint32_t)erasesize, &rem);
+
 	if (len == 0 || erasesize == 0 || erasesize > len
-	    || erasesize > UINT_MAX || do_div(len, (uint32_t)erasesize) != 0) {
+	    || erasesize > UINT_MAX || rem) {
 		parse_err("illegal erasesize or len\n");
 		goto error;
 	}
-- 
2.27.0



