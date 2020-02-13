Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A181D15C64E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgBMP7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgBMPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:55 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B28A24691;
        Thu, 13 Feb 2020 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607494;
        bh=BnVKot2FBC7XTfew6p7jQ1OMsDt0f3DfxyXDR2MkV0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN1uAIdK2IY90v9z2vG85a+YsbNLqYovP0O+0jPLR7F0WlCqDL1TypvcSl07P2E5r
         rZ5LJjgpE+/GNAHIKoOpqxnNqeuG1CixG6sLAreGF1ofgRjnqonlqbgEbIffyjTm2l
         ykIn6i5sp7IwesArNtKJjfbyUBoHlPJkjoqOH6PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/173] hv_balloon: Balloon up according to request page number
Date:   Thu, 13 Feb 2020 07:19:08 -0800
Message-Id: <20200213151945.341737590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit d33c240d47dab4fd15123d9e73fc8810cbc6ed6a upstream.

Current code has assumption that balloon request memory size aligns
with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
balloon driver receives non-aligned balloon request, it produces warning
and balloon up more memory than requested in order to keep 2MB alignment.
Remove the warning and balloon up memory according to actual requested
memory size.

Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_balloon.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1170,10 +1170,7 @@ static unsigned int alloc_balloon_pages(
 	unsigned int i = 0;
 	struct page *pg;
 
-	if (num_pages < alloc_unit)
-		return 0;
-
-	for (i = 0; (i * alloc_unit) < num_pages; i++) {
+	for (i = 0; i < num_pages / alloc_unit; i++) {
 		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
 			PAGE_SIZE)
 			return i * alloc_unit;
@@ -1207,7 +1204,7 @@ static unsigned int alloc_balloon_pages(
 
 	}
 
-	return num_pages;
+	return i * alloc_unit;
 }
 
 static void balloon_up(struct work_struct *dummy)
@@ -1222,9 +1219,6 @@ static void balloon_up(struct work_struc
 	long avail_pages;
 	unsigned long floor;
 
-	/* The host balloons pages in 2M granularity. */
-	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
-
 	/*
 	 * We will attempt 2M allocations. However, if we fail to
 	 * allocate 2M chunks, we will go back to 4k allocations.
@@ -1234,14 +1228,13 @@ static void balloon_up(struct work_struc
 	avail_pages = si_mem_available();
 	floor = compute_balloon_floor();
 
-	/* Refuse to balloon below the floor, keep the 2M granularity. */
+	/* Refuse to balloon below the floor. */
 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
 		pr_warn("Balloon request will be partially fulfilled. %s\n",
 			avail_pages < num_pages ? "Not enough memory." :
 			"Balloon floor reached.");
 
 		num_pages = avail_pages > floor ? (avail_pages - floor) : 0;
-		num_pages -= num_pages % PAGES_IN_2M;
 	}
 
 	while (!done) {


