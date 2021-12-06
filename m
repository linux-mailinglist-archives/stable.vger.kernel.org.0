Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D586469EAD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385954AbhLFPnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49266 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243016AbhLFPd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2399E61319;
        Mon,  6 Dec 2021 15:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DE4C34901;
        Mon,  6 Dec 2021 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804626;
        bh=PChk6+KqN/nms4bRxcrzSymUKqqjUsp9Fb9o4Gm2B2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIpBK/aDF/CpGYVh/7QVvt7GauOSQ3n5bfEQC1ONNhJmDec6z64SBPbyVJzMJHvkm
         wImP1bpmKgnTJD1HspmShfUsVrB/D9qRAY5S5xLyd2ZFJBnqMmKZ5u/v6xKTC9r06e
         cINutbre/9WJYBSArhY7QmGE6ZQY3onw5GLhF3VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.15 207/207] ipmi: msghandler: Make symbol remove_work_wq static
Date:   Mon,  6 Dec 2021 15:57:41 +0100
Message-Id: <20211206145617.463005125@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
@@ -191,7 +191,7 @@ struct ipmi_user {
 	struct work_struct remove_work;
 };
 
-struct workqueue_struct *remove_work_wq;
+static struct workqueue_struct *remove_work_wq;
 
 static struct ipmi_user *acquire_ipmi_user(struct ipmi_user *user, int *index)
 	__acquires(user->release_barrier)


