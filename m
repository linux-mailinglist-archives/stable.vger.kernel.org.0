Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190702B6603
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgKQOAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbgKQNPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:15:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7FE5246DD;
        Tue, 17 Nov 2020 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618919;
        bh=uqGE8wpkaITO0ex9MMrcYTpJWm9L9GH831zZi00LWIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etPmTn/HOl2ffu+mk6WoNm/doyDCdAgDohgFnU6NzFRxPEBZKTxWiqD8uk4VUNGJe
         AB34JHTq2enUjn0+iWP6GiYayWHyruphy+aTkWiREDR+n+COBWSJ7SBlJ2/XBTO9pW
         kCC+5Jzp6TUlzfBYGGRbfnZmDzZvYjNTVtOEiEmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.14 52/85] selinux: Fix error return code in sel_ib_pkey_sid_slow()
Date:   Tue, 17 Nov 2020 14:05:21 +0100
Message-Id: <20201117122113.589598006@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

commit c350f8bea271782e2733419bd2ab9bf4ec2051ef upstream.

Fix to return a negative error code from the error handling case
instead of 0 in function sel_ib_pkey_sid_slow(), as done elsewhere
in this function.

Cc: stable@vger.kernel.org
Fixes: 409dcf31538a ("selinux: Add a cache for quicker retreival of PKey SIDs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ibpkey.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/ibpkey.c
+++ b/security/selinux/ibpkey.c
@@ -160,8 +160,10 @@ static int sel_ib_pkey_sid_slow(u64 subn
 	 * is valid, it just won't be added to the cache.
 	 */
 	new = kzalloc(sizeof(*new), GFP_ATOMIC);
-	if (!new)
+	if (!new) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	new->psec.subnet_prefix = subnet_prefix;
 	new->psec.pkey = pkey_num;


