Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49499DF97
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfH0Hzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbfH0Hzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:55:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5102173E;
        Tue, 27 Aug 2019 07:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892535;
        bh=qB3BRxQO9fiCu0Wd3YThpUV/JWI3D7Si2wgDS2tL1KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af1/SAFUNht7VQEfqaSt6eOmgPymGyVCM8XjMIk4BKkB8oXHFST9p+KjI2IweUyNC
         Mw1Jd/RBxli90T8WeLcwvSUgXE4QEOJUStwIpTmh8UxDusUxI96QBphJYOD5THkgzP
         R1Jf4cRcnRgWae1yf/jtHQPARs77Ee/6YpaU4OW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/98] selftests: forwarding: gre_multipath: Enable IPv4 forwarding
Date:   Tue, 27 Aug 2019 09:49:48 +0200
Message-Id: <20190827072718.667038945@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit efa7b79f675da0efafe3f32ba0d6efe916cf4867 ]

The test did not enable IPv4 forwarding during its setup phase, which
causes the test to fail on machines where IPv4 forwarding is disabled.

Fixes: 54818c4c4b93 ("selftests: forwarding: Test multipath tunneling")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Tested-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/gre_multipath.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath.sh b/tools/testing/selftests/net/forwarding/gre_multipath.sh
index cca2baa03fb81..37d7297e1cf8a 100755
--- a/tools/testing/selftests/net/forwarding/gre_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/gre_multipath.sh
@@ -187,12 +187,16 @@ setup_prepare()
 	sw1_create
 	sw2_create
 	h2_create
+
+	forwarding_enable
 }
 
 cleanup()
 {
 	pre_cleanup
 
+	forwarding_restore
+
 	h2_destroy
 	sw2_destroy
 	sw1_destroy
-- 
2.20.1



