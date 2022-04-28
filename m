Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06A55138D3
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349532AbiD1Pqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349530AbiD1Pq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B9B8215;
        Thu, 28 Apr 2022 08:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62723B82E60;
        Thu, 28 Apr 2022 15:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B0C385AA;
        Thu, 28 Apr 2022 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160590;
        bh=HCykCgYNoQIXUrLzZeUe7vnBxuFoYC6hSwkFvjaczlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLOqRVppL/kuLu5r2KOwp7D8Eah07t3rLWrHpGgLlULYNwb0wLIs9dOT8RoVRsNIY
         PBCUuOP4vzvzhWC4j9hSjHX8/OvOcohmOH2Dk2bRQvjY0hBLd6e3wZspn3oVYMHCaP
         uCaJ/vpMxo5YMQ7bkBAzrWUn/XDF/nTWuvBaznk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Herbert van den Bergh <herbert.van.den.bergh@oracle.com>,
        Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 10/14] mm/mlock: fix potential imbalanced rlimit ucounts adjustment
Date:   Thu, 28 Apr 2022 17:42:18 +0200
Message-Id: <20220428154222.1230793-10-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1240; i=gregkh@linuxfoundation.org; h=from:subject; bh=c7rlKq+E+z1QCnNVW3vftSDp4l2FfRz0dPmO1I7Qwvs=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8K7XfeuajJsv7sQp0AR/Zcz5/Z70+qrAvX6LLrOzsr tW5bRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEwkx4phwUXFVZ5cbnmrTbwr7z/MtL +w1MZQimF+oZf8u5NH3z/iex3NmnQk4KWmencrAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 5c2a956c3eea173b2bc89f632507c0eeaebf6c4a upstream.

user_shm_lock forgets to set allowed to 0 when get_ucounts fails.  So
the later user_shm_unlock might do the extra dec_rlimit_ucounts.  Fix
this by resetting allowed to 0.

Link: https://lkml.kernel.org/r/20220310132417.41189-1-linmiaohe@huawei.com
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mlock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mlock.c b/mm/mlock.c
index 37f969ec68fa..b565b1aac8d4 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -838,6 +838,7 @@ int user_shm_lock(size_t size, struct ucounts *ucounts)
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;
-- 
2.36.0

