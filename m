Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4100B5290F9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbiEPUKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351063AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D5F473B4;
        Mon, 16 May 2022 12:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3D4DB81615;
        Mon, 16 May 2022 19:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25369C34100;
        Mon, 16 May 2022 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731075;
        bh=FM2KypQaSM0lg4NGsv+JVQ8dLweljGPy3xbFEFrdZyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRwdl+Dii0GTLCNdShtR9NjKSbcU2bgAZksxJKOC6dgK8PG5WnFM1hDxM6d04aW3u
         XS9svh2MhpDy9lpBREMr6ZehVy19O9xtYw/HvMswVfjpsva+wWmS/ciuix35tu/JyT
         tGbUITJ3P2X4a3qBLjNnVFFsggLz2yi72VwxZdzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Mina Almasry <almasrymina@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.17 095/114] mm: mremap: fix sign for EFAULT error return value
Date:   Mon, 16 May 2022 21:37:09 +0200
Message-Id: <20220516193628.201513069@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

commit 7d1e6496616275f3830e2f2f91fa69a66953e95b upstream.

The mremap syscall is supposed to return a pointer to the new virtual
memory area on success, and a negative value of the error code in case of
failure.  Currently, EFAULT is returned when the VMA is not found, instead
of -EFAULT.  The users of this syscall will therefore believe the syscall
succeeded in case the VMA didn't exist, as it returns a pointer to address
0xe (0xe being the value of EFAULT).  Fix the sign of the error value.

Link: https://lkml.kernel.org/r/20220427224439.23828-2-dossche.niels@gmail.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -947,7 +947,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		return -EINTR;
 	vma = find_vma(mm, addr);
 	if (!vma || vma->vm_start > addr) {
-		ret = EFAULT;
+		ret = -EFAULT;
 		goto out;
 	}
 


