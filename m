Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB7422F16B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgG0OcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgG0OTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72BD2075A;
        Mon, 27 Jul 2020 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859582;
        bh=J25/JXUK4b6mmR7U9r7A6ToZsorSLCfD4+2z74cq+Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXhYUJB8prtmZ4POyXczz6ACTXrIVD0jzC7PG9Lp/J8AIAd+7W79YJpDtP52pr91c
         RHDt6/NQhxWDY/Nu/PDn8iHNkE67T19mCZhn4jyUEGFLdGPgGb5OLoj+2TbPterdTs
         l2kvz1nBY70hKK8xO6cFJO4M8zYA+GJrbJxo1HxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7 027/179] exfat: fix overflow issue in exfat_cluster_to_sector()
Date:   Mon, 27 Jul 2020 16:03:22 +0200
Message-Id: <20200727134933.991795930@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 43946b70494beefe40ec1b2ba4744c0f294d7736 upstream.

An overflow issue can occur while calculating sector in
exfat_cluster_to_sector(). It needs to cast clus's type to sector_t
before left shifting.

Fixes: 1acf1a564b60 ("exfat: add in-memory and on-disk structures and headers")
Cc: stable@vger.kernel.org # v5.7
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/exfat_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -375,7 +375,7 @@ static inline bool exfat_is_last_sector_
 static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		unsigned int clus)
 {
-	return ((clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
+	return ((sector_t)(clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
 		sbi->data_start_sector;
 }
 


