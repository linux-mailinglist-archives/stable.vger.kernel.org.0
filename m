Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D313441D9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCVMgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhCVMfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B78760C3D;
        Mon, 22 Mar 2021 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416505;
        bh=6qDsWRdDrEprk/lwWGwSYooI02SaMRqvmo6OHwXlbKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8G73Y42g/+c/7r6evDxilszRDVIqK5nnvJcWXv+a88zBSr8s4cW8jfpFTjC1YWQw
         g217GoEi2N/QpW3MQEatC4dJjBpmMoZkvcz3/kW7ABjv9yCPD87JlK90MSM0TT1aTZ
         OduHB42sMn/uDZJlES966AxxO4RSv9D69XlkBtF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabine Forkel <sabine.forkel@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 5.10 012/157] s390/vtime: fix increased steal time accounting
Date:   Mon, 22 Mar 2021 13:26:09 +0100
Message-Id: <20210322121934.152669104@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit d54cb7d54877d529bc1e0e1f47a3dd082f73add3 upstream.

Commit 152e9b8676c6e ("s390/vtime: steal time exponential moving average")
inadvertently changed the input value for account_steal_time() from
"cputime_to_nsecs(steal)" to just "steal", resulting in broken increased
steal time accounting.

Fix this by changing it back to "cputime_to_nsecs(steal)".

Fixes: 152e9b8676c6e ("s390/vtime: steal time exponential moving average")
Cc: <stable@vger.kernel.org> # 5.1
Reported-by: Sabine Forkel <sabine.forkel@de.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -217,7 +217,7 @@ void vtime_flush(struct task_struct *tsk
 	avg_steal = S390_lowcore.avg_steal_timer / 2;
 	if ((s64) steal > 0) {
 		S390_lowcore.steal_timer = 0;
-		account_steal_time(steal);
+		account_steal_time(cputime_to_nsecs(steal));
 		avg_steal += steal;
 	}
 	S390_lowcore.avg_steal_timer = avg_steal;


