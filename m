Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42895B5CAC
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfIRG1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730476AbfIRG1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1B0218AF;
        Wed, 18 Sep 2019 06:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788030;
        bh=FUAoHiJRL3qgdI+/miMRFMIFYjyObvtwgXnvXln8pNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ/KBds4psBfHEahDvjS/4UXw2rpo9yjhw0h6UPrdvUmjZ1p8cqu//3NcUyMJ1ti2
         bC9KXgOV/OEX4Y7bMDQALcLMDFEqueje9X9m8gkO+b2PeA3mA51Gs8ooq85LVg5wTQ
         IzdN2V+Nj1T5RNzMuiEJPiM+CFTk+zmJ33lukdNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 73/85] mm/z3fold.c: fix lock/unlock imbalance in z3fold_page_isolate
Date:   Wed, 18 Sep 2019 08:19:31 +0200
Message-Id: <20190918061237.710903376@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 14108b9131a47ff18a3c640f583eb2d625c75c0d upstream.

Fix lock/unlock imbalance by unlocking *zhdr* before return.

Addresses Coverity ID 1452811 ("Missing unlock")

Link: http://lkml.kernel.org/r/20190826030634.GA4379@embeddedor
Fixes: d776aaa9895e ("mm/z3fold.c: fix race between migration and destruction")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1408,6 +1408,7 @@ static bool z3fold_page_isolate(struct p
 				 * should freak out.
 				 */
 				WARN(1, "Z3fold is experiencing kref problems\n");
+				z3fold_page_unlock(zhdr);
 				return false;
 			}
 			z3fold_page_unlock(zhdr);


