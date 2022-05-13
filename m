Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D042E526487
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381082AbiEMOcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381157AbiEMObD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71B3606F1;
        Fri, 13 May 2022 07:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A3862154;
        Fri, 13 May 2022 14:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CD0C34100;
        Fri, 13 May 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452112;
        bh=4z0obWSDnb57xGzIznvmN7huABcV6pSFsAXa2Q/cy8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsQhlVT0/ozD0omUkRGeP5HhhMDIII1KA8ZoH3AlqmSpwLEnq7RTOA/AiyRX1cwoy
         eAN7Bdi8C3n8e8Mo9WAVZzVMoOIpMkizjcjVbbCjx3vJjgz5Ne3xKvqkGYSIwktrJw
         RXUGWsIOcunVvuumn/0nMJmoSi7aTfa0+2jNkjJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Herbert van den Bergh <herbert.van.den.bergh@oracle.com>,
        Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 20/21] mm/mlock: fix potential imbalanced rlimit ucounts adjustment
Date:   Fri, 13 May 2022 16:24:02 +0200
Message-Id: <20220513142230.458765860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 mm/mlock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -837,6 +837,7 @@ int user_shm_lock(size_t size, struct uc
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;


