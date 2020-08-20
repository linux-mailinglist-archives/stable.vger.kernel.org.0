Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7CC24BFCF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgHTNyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgHTJ0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:26:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C969022CE3;
        Thu, 20 Aug 2020 09:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915600;
        bh=dLN8VAA5iPGBkW4opW8cjquNH5m79Hk8dZeExUXHUBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mycbaZb1Xb8vdGovidZZfJsgRljAZGF0UkiNjAtYyc3Glyu2J8p79sMhjERHfrF9v
         shQwGfn/7cPnRkkG8a0o0ZzFT2q/IO9t9t4iHC+Pwa9dGnrKmYWVEQQ/17RsNdH4CI
         taMP30WjyUIBysOIrhIvXzdIOxEvn9FRe7sryvPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christopher KOBAYASHI <chris@disavowed.jp>,
        Doug Brown <doug@downtowndougbrown.com>,
        Vincent Duvert <vincent.ldev@duvert.net>,
        Lukas Wunner <lukas@wunner.de>,
        Yue Haibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 071/232] appletalk: Fix atalk_proc_init() return path
Date:   Thu, 20 Aug 2020 11:18:42 +0200
Message-Id: <20200820091616.241259112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Duvert <vincent.ldev@duvert.net>

commit d0f6ba2ef2c1c95069509e71402e7d6d43452512 upstream.

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


