Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032E32A564E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387558AbgKCVCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387553AbgKCVCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F12F20757;
        Tue,  3 Nov 2020 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437321;
        bh=ImkCi6wVJfwB6SBF9cHHXCHQVVWly6Y7DHUD+gkteAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CVMswq9UIVQzKng7RyMgOR9CObkELbMqls7fsG4GKj4CcvJXiRhwT098Is5jpKhl
         Pinxa/HPQcNkxX5d87NnNyhDjLp19VrTRu9Uj4ZGR7pJIXuDn55az4vIbs/O/7L0Ym
         9XvV5jY9tye4Y4EKKz5It6Iv4/r8cOk1uAlgNM9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 026/191] mtd: lpddr: Fix bad logic in print_drs_error
Date:   Tue,  3 Nov 2020 21:35:18 +0100
Message-Id: <20201103203236.101496917@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 1c9c02bb22684f6949d2e7ddc0a3ff364fd5a6fc upstream.

Update logic for broken test. Use a more common logging style.

It appears the logic in this function is broken for the
consecutive tests of

        if (prog_status & 0x3)
                ...
        else if (prog_status & 0x2)
                ...
        else (prog_status & 0x1)
                ...

Likely the first test should be

        if ((prog_status & 0x3) == 0x3)

Found by inspection of include files using printk.

Fixes: eb3db27507f7 ("[MTD] LPDDR PFOW definition")
Cc: stable@vger.kernel.org
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/3fb0e29f5b601db8be2938a01d974b00c8788501.1588016644.git.gustavo@embeddedor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mtd/pfow.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mtd/pfow.h
+++ b/include/linux/mtd/pfow.h
@@ -128,7 +128,7 @@ static inline void print_drs_error(unsig
 
 	if (!(dsr & DSR_AVAILABLE))
 		printk(KERN_NOTICE"DSR.15: (0) Device not Available\n");
-	if (prog_status & 0x03)
+	if ((prog_status & 0x03) == 0x03)
 		printk(KERN_NOTICE"DSR.9,8: (11) Attempt to program invalid "
 						"half with 41h command\n");
 	else if (prog_status & 0x02)


