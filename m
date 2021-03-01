Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83873291A4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhCAU3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243261AbhCAUXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BFCC653F9;
        Mon,  1 Mar 2021 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621898;
        bh=ZQtOhT8VAwYbSnC+p1CHYZJsPMg+E0AMJanid25O/6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1ThCMsOKBWWe0CXBUslW5sQM44/blSvEAbz1YIlCndVzXEmNC6/gTztC64QYk6cr
         GcDVC8OacBUsXfVZUU0zHjyCblYVs0HXRKXSg/PKNhjKnyUECIYr/mylLjHkZQKq/x
         s9LMjl0RZvdHKIiTLLpcjS9H0LhQ09bTo3GWUkc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.11 684/775] mailbox: arm_mhuv2: Skip calling kfree() with invalid pointer
Date:   Mon,  1 Mar 2021 17:14:12 +0100
Message-Id: <20210301161235.181948940@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 6b50df2b8c208a04d44b8df5b7baaf668ceb8fc3 upstream.

It is possible that 'data' passed to kfree() is set to a error value
instead of allocated space. Make sure it doesn't get called with invalid
pointer.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Cc: v5.11 <stable@vger.kernel.org> # v5.11
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/arm_mhuv2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -699,7 +699,9 @@ static irqreturn_t mhuv2_receiver_interr
 		ret = IRQ_HANDLED;
 	}
 
-	kfree(data);
+	if (!IS_ERR(data))
+		kfree(data);
+
 	return ret;
 }
 


