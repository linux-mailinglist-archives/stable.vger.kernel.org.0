Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508002B6540
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgKQNxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731363AbgKQN2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E50624199;
        Tue, 17 Nov 2020 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619702;
        bh=hkvMx6OIWMhNYFoYTvpsHkWPk/WZbiJDCxC8MjX2UIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0/OnRJw9IyfJU3Luri4oXoCIJxX1/MdRBYAqg2/ISHFBPzZpMqx87/XgLn3G1Ggq
         vjgL2PV50MSJ2T73/S4IOFJBQSBjZwUk6MkfCGlLX1HCQMeJXAJ0qP50zZ5EiHEks7
         Yj+E0g9YQhhqIy5YMW3DIexI2ThpPF+8euC/NEpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 127/151] selinux: Fix error return code in sel_ib_pkey_sid_slow()
Date:   Tue, 17 Nov 2020 14:05:57 +0100
Message-Id: <20201117122127.603093123@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
@@ -151,8 +151,10 @@ static int sel_ib_pkey_sid_slow(u64 subn
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


