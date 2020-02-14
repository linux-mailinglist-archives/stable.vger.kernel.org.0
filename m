Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966F715DDDF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388431AbgBNQBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388875AbgBNQAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC60924690;
        Fri, 14 Feb 2020 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696023;
        bh=cnu/s8y3Rhyw3+j1D5VP+7aNXG6xvusKiAEStHYksso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFrTKopkEWLX7hpclj88aQr3xV1ik4T1NVzScQvk01Qm22Tb25XCRsDsGL0BR4KtU
         tKBsJokBwKOdLRZ9IoqhIeIuKul5ypQUO/GccBBOUrR+3zRjelsM5OQvwIdoaPWMPK
         KUa+SkzWV5cFz7vbqWcUiwXkseV8ZH2OY2CStPyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.5 538/542] virtio_balloon: prevent pfn array overflow
Date:   Fri, 14 Feb 2020 10:48:50 -0500
Message-Id: <20200214154854.6746-538-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

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
index 7e5d84caeb940..7bfe365d93720 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -158,6 +158,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
 {
 	unsigned int i;
 
+	BUILD_BUG_ON(VIRTIO_BALLOON_PAGES_PER_PAGE > VIRTIO_BALLOON_ARRAY_PFNS_MAX);
+
 	/*
 	 * Set balloon pfns pointing at this page.
 	 * Note that the first pfn points at start of the page.
-- 
2.20.1

