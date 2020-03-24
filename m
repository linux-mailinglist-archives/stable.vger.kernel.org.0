Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359E7190E9F
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCXNNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgCXNNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71414208D6;
        Tue, 24 Mar 2020 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055619;
        bh=fO3TluuhGFUOPYRAZGSQGeSGo8AhaL5yJAE0kpz0YOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoycFGx5jmpoRNReGZ20woo38fcaN1Ass9toC8ERLEXtmhznw1JI32c1LaWDLzRAs
         /z6rx3yfVLUr9W93upRqKYBNVdamSnS2zlDOt/nA/ZqX7V7rRhJMykrU6uF8k97HRv
         nrYUp454COov6iY2eRgV2SjPLUEKnGDq7NlxqHCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 40/65] intel_th: Fix user-visible error codes
Date:   Tue, 24 Mar 2020 14:11:01 +0100
Message-Id: <20200324130802.227261741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit ce666be89a8a09c5924ff08fc32e119f974bdab6 upstream.

There are a few places in the driver that end up returning ENOTSUPP to
the user, replace those with EINVAL.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: ba82664c134ef ("intel_th: Add Memory Storage Unit driver")
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20200317062215.15598-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -491,7 +491,7 @@ static int msc_configure(struct msc *msc
 	lockdep_assert_held(&msc->buf_mutex);
 
 	if (msc->mode > MSC_MODE_MULTI)
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	if (msc->mode == MSC_MODE_MULTI)
 		msc_buffer_clear_hw_header(msc);
@@ -942,7 +942,7 @@ static int msc_buffer_alloc(struct msc *
 	} else if (msc->mode == MSC_MODE_MULTI) {
 		ret = msc_buffer_multi_alloc(msc, nr_pages, nr_wins);
 	} else {
-		ret = -ENOTSUPP;
+		ret = -EINVAL;
 	}
 
 	if (!ret) {
@@ -1165,7 +1165,7 @@ static ssize_t intel_th_msc_read(struct
 		if (ret >= 0)
 			*ppos = iter->offset;
 	} else {
-		ret = -ENOTSUPP;
+		ret = -EINVAL;
 	}
 
 put_count:


