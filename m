Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D650232DAF
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgG3INw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgG3ING (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:13:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B82082075F;
        Thu, 30 Jul 2020 08:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096786;
        bh=QNGev99s991GqAfc2daKbH6No1tFEbQshVRdVMqfTR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbDvRw596dce5mbP55Zl17/tdipX080EAKgdw/rE/VhAlXKXX5HzboiI2CZMk2/NO
         Dq4vxhUuT8qiSl/wZR4o66oY6B97EmnRDx87HZyJksiLoUx7Z7SAVAW4BX+KRGjpac
         yCRJgOKNixU/mauQ7Vv51Mv56YWPq1xewop9F2NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 40/54] net-sysfs: add a newline when printing tx_timeout by sysfs
Date:   Thu, 30 Jul 2020 10:05:19 +0200
Message-Id: <20200730074423.132754236@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 9bb5fbea59f36a589ef886292549ca4052fe676c ]

When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
add a newline for easy reading.

root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
0root@syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -999,7 +999,7 @@ static ssize_t show_trans_timeout(struct
 	trans_timeout = queue->trans_timeout;
 	spin_unlock_irq(&queue->_xmit_lock);
 
-	return sprintf(buf, "%lu", trans_timeout);
+	return sprintf(buf, fmt_ulong, trans_timeout);
 }
 
 #ifdef CONFIG_XPS


