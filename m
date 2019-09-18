Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F120BB5CBD
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfIRG2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbfIRG1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2946221906;
        Wed, 18 Sep 2019 06:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788027;
        bh=DO155T9TYv+TyBqzz+WkFhf+n8NXB7p7oq7eXTJ/cEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZKasugyQVK9E+bI/8oMBzpv1DQfoWMLAR143whR8p8HKTCGshBDVj/UJ8EYXq+XG
         UJX+6ugWAoZ13RkS4lmHgIhCdHQhe80gxQRmcqaxuTHkLcp9Cl4HpXhXGRCrEhBNWy
         6d2dUkkFIdX1FpWUN1EpA4Z+gfj2cIwxPWY0zqBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Burns <henryburns@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Vitaly Vul <vitaly.vul@sony.com>,
        Jonathan Adams <jwadams@google.com>,
        Snild Dolkow <snild@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 72/85] mm/z3fold.c: remove z3fold_migration trylock
Date:   Wed, 18 Sep 2019 08:19:30 +0200
Message-Id: <20190918061237.682280260@linuxfoundation.org>
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

From: Henry Burns <henryburns@google.com>

commit be03074c9af25d06cf8e9ebddfcd284c0bf7f947 upstream.

z3fold_page_migrate() will never succeed because it attempts to acquire
a lock that has already been taken by migrate.c in __unmap_and_move().

  __unmap_and_move() migrate.c
    trylock_page(oldpage)
    move_to_new_page(oldpage_newpage)
      a_ops->migrate_page(oldpage, newpage)
        z3fold_page_migrate(oldpage, newpage)
          trylock_page(oldpage)

Link: http://lkml.kernel.org/r/20190710213238.91835-1-henryburns@google.com
Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Snild Dolkow <snild@sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1439,16 +1439,11 @@ static int z3fold_page_migrate(struct ad
 	zhdr = page_address(page);
 	pool = zhdr_to_pool(zhdr);
 
-	if (!trylock_page(page))
-		return -EAGAIN;
-
 	if (!z3fold_page_trylock(zhdr)) {
-		unlock_page(page);
 		return -EAGAIN;
 	}
 	if (zhdr->mapped_count != 0) {
 		z3fold_page_unlock(zhdr);
-		unlock_page(page);
 		return -EBUSY;
 	}
 	if (work_pending(&zhdr->work)) {
@@ -1494,7 +1489,6 @@ static int z3fold_page_migrate(struct ad
 	spin_unlock(&pool->lock);
 
 	page_mapcount_reset(page);
-	unlock_page(page);
 	put_page(page);
 	return 0;
 }


