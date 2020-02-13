Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F94015C4BC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387998AbgBMPuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgBMP03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:29 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E661206DB;
        Thu, 13 Feb 2020 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607587;
        bh=QyJVGfqaru/uvrDGFsoczRg8cEkQo1LqTPd4vcYohKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaOyfw7brjr1FnJKH1+qcAWitiQ0o1cB00+00UjiY9HYrmF78gPMG2+PE7pD7dz7R
         KhIVqTi5SwrHn71N1kkQ2I5kM2yug9cmosSl0xVinkluX6A+mFjoUkYTzMW+9UFIrb
         DGJRLw05uiNjFh1+hxZ4+AnqpVvKQTshLk90xPPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Guralnik <michaelgur@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 06/52] RDMA/uverbs: Verify MR access flags
Date:   Thu, 13 Feb 2020 07:20:47 -0800
Message-Id: <20200213151813.270748287@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

commit ca95c1411198c2d87217c19d44571052cdc94725 upstream.

Verify that MR access flags that are passed from user are all supported
ones, otherwise an error is returned.

Fixes: 4fca03778351 ("IB/uverbs: Move ib_access_flags and ib_read_counters_flags to uapi")
Link: https://lore.kernel.org/r/1578506740-22188-6-git-send-email-yishaih@mellanox.com
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/rdma/ib_verbs.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3864,6 +3864,9 @@ static inline int ib_check_mr_access(int
 	    !(flags & IB_ACCESS_LOCAL_WRITE))
 		return -EINVAL;
 
+	if (flags & ~IB_ACCESS_SUPPORTED)
+		return -EINVAL;
+
 	return 0;
 }
 


