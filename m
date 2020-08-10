Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745602408C4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgHJPYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgHJPYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC5E20772;
        Mon, 10 Aug 2020 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073091;
        bh=qeZvfDHiqugdAsX3cDYN3Pb3rFFOXn3FnRXjPQcaDf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLAXLc8xzqW7NPSlN1/S6XZwvRV71eACs5Eu0nmjcxJUBavtsjHU5/DDEjNnrJtsq
         m9y5rpg1yOM10n8/apHZ09UfeOQyePaQxPI4jibiQI1JaKwx6dshoGtaTAolqUAFz7
         cL8tbXXABphl63NsxaEGfxESnP2tE8k/zHPRC8+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christopher KOBAYASHI <chris@disavowed.jp>,
        Doug Brown <doug@downtowndougbrown.com>,
        Vincent Duvert <vincent.ldev@duvert.net>,
        Lukas Wunner <lukas@wunner.de>,
        Yue Haibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 63/79] appletalk: Fix atalk_proc_init() return path
Date:   Mon, 10 Aug 2020 17:21:22 +0200
Message-Id: <20200810151815.350166933@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Duvert <vincent.ldev@duvert.net>

[ Upstream commit d0f6ba2ef2c1c95069509e71402e7d6d43452512 ]

Add a missing return statement to atalk_proc_init so it doesn't return
-ENOMEM when successful.  This allows the appletalk module to load
properly.

Fixes: e2bcd8b0ce6e ("appletalk: use remove_proc_subtree to simplify procfs code")
Link: https://www.downtowndougbrown.com/2020/08/hacking-up-a-fix-for-the-broken-appletalk-kernel-module-in-linux-5-1-and-newer/
Reported-by: Christopher KOBAYASHI <chris@disavowed.jp>
Reported-by: Doug Brown <doug@downtowndougbrown.com>
Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>
[lukas: add missing tags]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.1+
Cc: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/atalk_proc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
 				     sizeof(struct aarp_iter_state), NULL))
 		goto out;
 
+	return 0;
+
 out:
 	remove_proc_subtree("atalk", init_net.proc_net);
 	return -ENOMEM;


