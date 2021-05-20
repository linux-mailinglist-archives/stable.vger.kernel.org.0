Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A662E38AA71
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbhETLNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239723AbhETLL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FB461D4F;
        Thu, 20 May 2021 10:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505256;
        bh=6qMJiWZ3pEETEodCSZjOD1Yryzg/jRm6fKQC5tedRcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGufJpq78mDM1krK0IMl8v/IzxlMSi+xh1rb3UnZsn6VXePddCQIEGDRHa9gZgURW
         UJeNcqtpUWBVXXBBeBpUxm4LLGHTNBuLk+UBXoweQQfpFbqal27twVafiVQGfa7zkq
         JHfK+K71WabQh4coJefRl5h4nsxNYMOv2f8GWvJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.4 053/190] dm space map common: fix division bug in sm_ll_find_free_block()
Date:   Thu, 20 May 2021 11:21:57 +0200
Message-Id: <20210520092103.929066752@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

commit 5208692e80a1f3c8ce2063a22b675dd5589d1d80 upstream.

This division bug meant the search for free metadata space could skip
the final allocation bitmap's worth of entries. Fix affects DM thinp,
cache and era targets.

Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Tested-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -337,6 +337,8 @@ int sm_ll_find_free_block(struct ll_disk
 	 */
 	begin = do_div(index_begin, ll->entries_per_block);
 	end = do_div(end, ll->entries_per_block);
+	if (end == 0)
+		end = ll->entries_per_block;
 
 	for (i = index_begin; i < index_end; i++, begin = 0) {
 		struct dm_block *blk;


