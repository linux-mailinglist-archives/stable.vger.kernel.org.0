Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904C373E50
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390734AbfGXUX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389834AbfGXTmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A86217D4;
        Wed, 24 Jul 2019 19:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997327;
        bh=bH7HEJN75KA7ejjclIFJ1AYUaANw/c/kpX06FvnMffY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpTFZ6pus7L+NmfFOuXm6OYuAjwiTX4JY3z4vx5CTGUID8WB6LYV9+CcplWsEBcGk
         mwrCOm1eQH6gyrFsS9Gp05jONDpVf+uGbd6NsvTsMYbAj+78JL66zyzyMnW3vQ6rkW
         buxEb5pYrXdcPmo07B1MZH13eYgHfbDupL+nHP/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.2 399/413] intel_th: msu: Remove set but not used variable last
Date:   Wed, 24 Jul 2019 21:21:30 +0200
Message-Id: <20190724191803.418188256@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 9800db282dff675dd700d5985d90b605c34b5ccd upstream.

Commit aad14ad3cf3a ("intel_th: msu: Add current window tracking") added
the following gcc warning:

> drivers/hwtracing/intel_th/msu.c: In function msc_win_switch:
> drivers/hwtracing/intel_th/msu.c:1389:21: warning: variable last set but
> not used [-Wunused-but-set-variable]

Fix it by removing the variable.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Fixes: aad14ad3cf3a ("intel_th: msu: Add current window tracking")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1400,10 +1400,9 @@ static int intel_th_msc_init(struct msc
 
 static void msc_win_switch(struct msc *msc)
 {
-	struct msc_window *last, *first;
+	struct msc_window *first;
 
 	first = list_first_entry(&msc->win_list, struct msc_window, entry);
-	last = list_last_entry(&msc->win_list, struct msc_window, entry);
 
 	if (msc_is_last_win(msc->cur_win))
 		msc->cur_win = first;


