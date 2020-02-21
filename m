Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969941675B1
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbgBUIaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbgBUIP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E888324670;
        Fri, 21 Feb 2020 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272956;
        bh=9AF6/sUnNmSe60shTp1e7QrFtjUm1sgv4Xy+8yP9Cpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhj21BBQv3tn7rnwAtbRp+wjxKdrN0RkScVd1sFsaVFMo/Lyf81SxUiTwcMvW7CxN
         cAndr2l/On5ujObg4IfvL/dB5WCmhIMGDVIsOzLgiLiLRoyPekF/RpD0mMcHlvZB7I
         37z0wEUOAxKOHTiyimWK/o91dnCDF3KYt2ISmgZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 339/344] virtio_balloon: prevent pfn array overflow
Date:   Fri, 21 Feb 2020 08:42:18 +0100
Message-Id: <20200221072421.231089464@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 6e9826e77249355c09db6ba41cd3f84e89f4b614 ]

Make sure, at build time, that pfn array is big enough to hold a single
page.  It happens to be true since the PAGE_SHIFT value at the moment is
20, which is 1M - exactly 256 4K balloon pages.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index c962d9b370c69..d2c4eb9efd70b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -157,6 +157,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
 {
 	unsigned int i;
 
+	BUILD_BUG_ON(VIRTIO_BALLOON_PAGES_PER_PAGE > VIRTIO_BALLOON_ARRAY_PFNS_MAX);
+
 	/*
 	 * Set balloon pfns pointing at this page.
 	 * Note that the first pfn points at start of the page.
-- 
2.20.1



