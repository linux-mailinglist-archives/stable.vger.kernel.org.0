Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7376DCC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbfGZPaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388404AbfGZPaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB6A2218D4;
        Fri, 26 Jul 2019 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155015;
        bh=GH0024jItE3M+mrjJFsl1zzLd5bi+P+GwkHqwepwIG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQRBymhiAzI3hiwc+dsnuxcccRPA8llsu2xVGCKHPubhIymPnQwWPiaz0oY+Y/mAW
         4+HzemNKtkjVgymcL+FR3p24NzNLtH5crJuTvXEazGC5FmqcvRFxBDeW65fz0d4+QM
         8GH7myfMp6FZg5KAwPZO9nd9lb1EfCO+xyT2zcrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank de Brabander <debrabander@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 36/62] selftests: txring_overwrite: fix incorrect test of mmap() return value
Date:   Fri, 26 Jul 2019 17:24:48 +0200
Message-Id: <20190726152305.730113051@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank de Brabander <debrabander@gmail.com>

[ Upstream commit cecaa76b2919aac2aa584ce476e9fcd5b084add5 ]

If mmap() fails it returns MAP_FAILED, which is defined as ((void *) -1).
The current if-statement incorrectly tests if *ring is NULL.

Fixes: 358be656406d ("selftests/net: add txring_overwrite")
Signed-off-by: Frank de Brabander <debrabander@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/txring_overwrite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/txring_overwrite.c
+++ b/tools/testing/selftests/net/txring_overwrite.c
@@ -113,7 +113,7 @@ static int setup_tx(char **ring)
 
 	*ring = mmap(0, req.tp_block_size * req.tp_block_nr,
 		     PROT_READ | PROT_WRITE, MAP_SHARED, fdt, 0);
-	if (!*ring)
+	if (*ring == MAP_FAILED)
 		error(1, errno, "mmap");
 
 	return fdt;


