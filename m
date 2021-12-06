Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD5469D29
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245046AbhLFP2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359206AbhLFPX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:23:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40825B810E7;
        Mon,  6 Dec 2021 15:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897EDC341C1;
        Mon,  6 Dec 2021 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804027;
        bh=CGVZuP9OseeWhUDiKnbmprsqxVzz2zue0tFNNfoZcDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRo6hDLAzxHnv4HT77udWKrmmONY3DoUhAqqXIgzLCjU9514eS5RFo88pTYoNsf4Q
         +evBxZKOLJMIwHqjyvHKfshW2yDYbq9b9BZ9+Wy3wXlJ24SuqUrten0mNURiLjPe+Q
         TXIF8Rgp90Dh6BwmKArMFeLzHruZWcW6CR0E8VFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.10 130/130] ipmi: msghandler: Make symbol remove_work_wq static
Date:   Mon,  6 Dec 2021 15:57:27 +0100
Message-Id: <20211206145604.155775188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 5a3ba99b62d8486de0316334e72ac620d4b94fdd upstream.

The sparse tool complains as follows:

drivers/char/ipmi/ipmi_msghandler.c:194:25: warning:
 symbol 'remove_work_wq' was not declared. Should it be static?

This symbol is not used outside of ipmi_msghandler.c, so
marks it static.

Fixes: 1d49eb91e86e ("ipmi: Move remove_work to dedicated workqueue")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Message-Id: <20211123083618.2366808-1-weiyongjun1@huawei.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -203,7 +203,7 @@ struct ipmi_user {
 	struct work_struct remove_work;
 };
 
-struct workqueue_struct *remove_work_wq;
+static struct workqueue_struct *remove_work_wq;
 
 static struct ipmi_user *acquire_ipmi_user(struct ipmi_user *user, int *index)
 	__acquires(user->release_barrier)


