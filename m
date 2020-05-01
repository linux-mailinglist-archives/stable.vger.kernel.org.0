Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD65B1C1746
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgEAOAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 10:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgEAN1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF262208DB;
        Fri,  1 May 2020 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339635;
        bh=ba5UviiqirxX2VhbhVmCa6180lZgvgjE1tT7+Kq3bn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHTMOx1PqAxv7F/V5GwVuUXtw+8VBq8Vss6tPqEn17CI2QNZtCJcvbP+Vjc11HPg+
         k88PsB2wzBQuxt8KGXMKD1m8idUnOv5OqKgQzCqvhx19qM9QMyWoBcYyPI9oMLK3if
         M3pZ5eh7eqwHyIDBtLO5sdjJqFrq+/7h2I8Kmv3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Huaijie <yihuaijie@huawei.com>,
        Liu Jian <liujian56@huawei.com>,
        Tokunori Ikegami <ikegami_to@yahoo.co.jp>,
        Richard Weinberger <richard@nod.at>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 57/70] mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer
Date:   Fri,  1 May 2020 15:21:45 +0200
Message-Id: <20200501131530.691671109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

commit d9b8a67b3b95a5c5aae6422b8113adc1c2485f2b upstream.

In function do_write_buffer(), in the for loop, there is a case
chip_ready() returns 1 while chip_good() returns 0, so it never
break the loop.
To fix this, chip_good() is enough and it should timeout if it stay
bad for a while.

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Yi Huaijie <yihuaijie@huawei.com>
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Tokunori Ikegami <ikegami_to@yahoo.co.jp>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1881,7 +1881,11 @@ static int __xipram do_write_buffer(stru
 			continue;
 		}
 
-		if (time_after(jiffies, timeo) && !chip_ready(map, adr))
+		/*
+		 * We check "time_after" and "!chip_good" before checking "chip_good" to avoid
+		 * the failure due to scheduling.
+		 */
+		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum))
 			break;
 
 		if (chip_good(map, adr, datum)) {


