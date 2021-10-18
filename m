Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE392431C3D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhJRNja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhJRNiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C88160EFE;
        Mon, 18 Oct 2021 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563919;
        bh=b6JXoE31IJ/hcB6tiPfLjc6ynqxtXaSuffRpllksqzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz1xA94jPqcrM+O37Txu3M/Zgh2FEd9v2HLyAUV8+kAl/C+4ANT2x8aKTsgx1X8/j
         9r/wvs2rEalxI27uSeEBZ9iXpF/0KYxffo8Dp087LeeTNUthgOweAt3IytxuUYeEbC
         0nKF10Om1zcZYugoSAboB5ZKrAeeOh6NLavGnq+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 67/69] qed: Fix missing error code in qed_slowpath_start()
Date:   Mon, 18 Oct 2021 15:25:05 +0200
Message-Id: <20211018132331.693783807@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

commit a5a14ea7b4e55604acb0dc9d88fdb4cb6945bc77 upstream.

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/net/ethernet/qlogic/qed/qed_main.c:1298 qed_slowpath_start()
warn: missing error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1238,6 +1238,7 @@ static int qed_slowpath_start(struct qed
 			} else {
 				DP_NOTICE(cdev,
 					  "Failed to acquire PTT for aRFS\n");
+				rc = -EINVAL;
 				goto err;
 			}
 		}


