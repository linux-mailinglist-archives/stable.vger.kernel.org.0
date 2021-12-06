Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6A469C0B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346398AbhLFPTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347271AbhLFPRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1DBB8111A;
        Mon,  6 Dec 2021 15:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1992FC341C8;
        Mon,  6 Dec 2021 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803652;
        bh=jvjWixcVkJ2vK90vb80viwfW97CW8IUTnqu8H25Orzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhFtY5VW3lXdpEby3YLH5Avtt7GGg0sqgHx/ekQg2Y4FOBhl2KfWFaVOzVppDgSvk
         81j9+90ZuM1szjcvVm37zltiIU40Y4fFA2GWcrc2ERy6i/NxKmDhIOCnWjucZz55dT
         97lrABsPzrtVFXOcRZthvZWy/gF1kBvKS/GXKCMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 70/70] ipmi: msghandler: Make symbol remove_work_wq static
Date:   Mon,  6 Dec 2021 15:57:14 +0100
Message-Id: <20211206145554.371708383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
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
@@ -220,7 +220,7 @@ struct ipmi_user {
 	struct work_struct remove_work;
 };
 
-struct workqueue_struct *remove_work_wq;
+static struct workqueue_struct *remove_work_wq;
 
 static struct ipmi_user *acquire_ipmi_user(struct ipmi_user *user, int *index)
 	__acquires(user->release_barrier)


