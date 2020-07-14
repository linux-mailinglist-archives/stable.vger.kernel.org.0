Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2721FC20
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgGNSwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730121AbgGNSwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:52:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D476722B42;
        Tue, 14 Jul 2020 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752773;
        bh=U/vZ+MZGMwLJ1UVqqK6/GQHXcdv5AyPJlaIEplnEad8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q94SjXQSfp8a8Vbf2MQPmV1tEV7vpYDJ8pm/WbrjOCG9cT2iQX8LSdjcHHQYj/wr
         S40hkxsibWP0aAI2ZOW77LAT64d0YiUqOGeIR4yuW0B/sIOdo2BWS0BvCllMsFrUdL
         /tauod/KoCtS/H74UmtA1Ug9Q01QM3VLQg7bwWN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 104/109] dm writecache: reject asynchronous pmem devices
Date:   Tue, 14 Jul 2020 20:44:47 +0200
Message-Id: <20200714184110.545942232@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

commit a46624580376a3a0beb218d94cbc7f258696e29f upstream.

DM writecache does not handle asynchronous pmem. Reject it when
supplied as cache.

Link: https://lore.kernel.org/linux-nvdimm/87lfk5hahc.fsf@linux.ibm.com/
Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2104,6 +2104,12 @@ invalid_optional:
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
+			r = -EOPNOTSUPP;
+			ti->error = "Asynchronous persistent memory not supported as pmem cache";
+			goto bad;
+		}
+
 		r = persistent_memory_claim(wc);
 		if (r) {
 			ti->error = "Unable to map persistent memory for cache";


