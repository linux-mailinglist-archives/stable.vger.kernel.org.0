Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAC1EAE03
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgFASF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgFASF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB77206E2;
        Mon,  1 Jun 2020 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034756;
        bh=e9ONb6R08rnDyChk96rmWRWoJfzaWKahP1KGCcQT5rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaK1s3dfOsQWSJ+0iDdvWYflIhDBrk32dkcd4I0CVgxaB6+csPwb3RQLKt83V0VWs
         SEuUKS/7FRRZ/aJke+aDl0fRFJa6yq7HQTrGVJOPjEZqv46zk8mcKuAA3F3U0XR+tA
         0ia4hIqCVcXuR9z9Y0VcUNaeac/P2Vm7c8fVhII4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liviu Dudau <liviu@dudau.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 95/95] mm/vmalloc.c: dont dereference possible NULL pointer in __vunmap()
Date:   Mon,  1 Jun 2020 19:54:35 +0200
Message-Id: <20200601174034.819784933@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liviu Dudau <liviu@dudau.co.uk>

commit 6ade20327dbb808882888ed8ccded71e93067cf9 upstream.

find_vmap_area() can return a NULL pointer and we're going to
dereference it without checking it first.  Use the existing
find_vm_area() function which does exactly what we want and checks for
the NULL pointer.

Link: http://lkml.kernel.org/r/20181228171009.22269-1-liviu@dudau.co.uk
Fixes: f3c01d2f3ade ("mm: vmalloc: avoid racy handling of debugobjects in vunmap")
Signed-off-by: Liviu Dudau <liviu@dudau.co.uk>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1510,7 +1510,7 @@ static void __vunmap(const void *addr, i
 			addr))
 		return;
 
-	area = find_vmap_area((unsigned long)addr)->vm;
+	area = find_vm_area(addr);
 	if (unlikely(!area)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);


