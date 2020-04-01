Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D81E19B110
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbgDAQbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388338AbgDAQbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 908D62137B;
        Wed,  1 Apr 2020 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758701;
        bh=gKGesIHjum9IG4MYIu7b8532lXP7SNN8UJqqO0x5J88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKGp3H0Eyh8nz1EnXVOkb/FwFohr8x9RrxLOWxa1/GvnSboWzWVimocllxNfgG2lz
         Z2kCNnHANVyaSYSdBrprnJkDKPRbO8/A+bpOJnd3tn9WradPwJDuktCl5m2wdnELSb
         WJAfYqHHrMyXkGzHzhVpzgoEW8WaHF5AYc/yp6j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Jan Kara <jack@suse.com>, Neil Brown <neilb@suse.de>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 48/91] drivers/hwspinlock: use correct radix tree API
Date:   Wed,  1 Apr 2020 18:17:44 +0200
Message-Id: <20200401161530.338453012@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

[ Upstream commit b76ba4af4ddd6a06f7f65769e7be1bc56556cdf5 ]

radix_tree_is_indirect_ptr() is an internal API.  The correct call to
use is radix_tree_deref_retry() which has the appropriate unlikely()
annotation.

Fixes: c6400ba7e13a ("drivers/hwspinlock: fix race between radix tree insertion and lookup")
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/hwspinlock_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index d50c701b19d67..4074441444fed 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -313,7 +313,7 @@ int of_hwspin_lock_get_id(struct device_node *np, int index)
 		hwlock = radix_tree_deref_slot(slot);
 		if (unlikely(!hwlock))
 			continue;
-		if (radix_tree_is_indirect_ptr(hwlock)) {
+		if (radix_tree_deref_retry(hwlock)) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
-- 
2.20.1



