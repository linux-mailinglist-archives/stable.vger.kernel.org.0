Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB69199D10
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404057AbfHVRYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404047AbfHVRYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:04 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF6E21743;
        Thu, 22 Aug 2019 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494644;
        bh=U+5/RrXOQutRbuZmw4dlReGIyr1KMoPslZAYy4gZk4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7GFDt2rIcO6pqTF5dw+wHrnrSSS+4wjxMK6M8w7ZbjmjbHSF6m1O2VwuZ8Fo/oI2
         lrAzRLKv3tIyRXsrMEZC1/grOC0gr57Z9PUuQ0hv1D6Z5kp1ITw8jYZkqA8kqzB/zJ
         RkE67lrOX5P+RtdT5mp7Y4DLPwaRDJuWD4p3EFF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/103] IB/core: Add mitigation for Spectre V1
Date:   Thu, 22 Aug 2019 10:19:06 -0700
Message-Id: <20190822171732.133003933@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 61f259821dd3306e49b7d42a3f90fb5a4ff3351b ]

Some processors may mispredict an array bounds check and
speculatively access memory that they should not. With
a user supplied array index we like to play things safe
by masking the value with the array size before it is
used as an index.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20190731043957.GA1600@agluck-desk2.amr.corp.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/user_mad.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 415a3185cde7f..cf93a96b63249 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/semaphore.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 
 #include <asm/uaccess.h>
 
@@ -843,11 +844,14 @@ static int ib_umad_unreg_agent(struct ib_umad_file *file, u32 __user *arg)
 
 	if (get_user(id, arg))
 		return -EFAULT;
+	if (id >= IB_UMAD_MAX_AGENTS)
+		return -EINVAL;
 
 	mutex_lock(&file->port->file_mutex);
 	mutex_lock(&file->mutex);
 
-	if (id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
+	id = array_index_nospec(id, IB_UMAD_MAX_AGENTS);
+	if (!__get_agent(file, id)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.20.1



