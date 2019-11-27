Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED85010BCCC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfK0VYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbfK0VDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A34832080F;
        Wed, 27 Nov 2019 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888629;
        bh=RFeDsKAaoKwlp4/tSmQK0sxDKUceFFliSMPVIObqmk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVv2aAJ9Wyn/af6EzBzegKmbQ29gBNVop47WqPc6CkZBvrlSD6uYrQ2r7a3QJBT21
         lDCf43Uqgak4lX6A2ePFAB4kQTjuZQRF01/BFIFESCsJZAt9KK0oENJiCrl4jcyrPF
         +ToqgeA9fj8KDZLJPQ9Kse39KePaOEaeQPwYLJRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/306] sock_diag: fix autoloading of the raw_diag module
Date:   Wed, 27 Nov 2019 21:30:58 +0100
Message-Id: <20191127203130.323653726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

[ Upstream commit c34c1287778b080ed692c0a46a8e345206cc29e6 ]

IPPROTO_RAW isn't registred as an inet protocol, so
inet_protos[protocol] is always NULL for it.

Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Fixes: bf2ae2e4bf93 ("sock_diag: request _diag module only when the family or proto has been registered")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6c11078217769..ba4f843cdd1d1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3347,6 +3347,7 @@ int sock_load_diag_module(int family, int protocol)
 
 #ifdef CONFIG_INET
 	if (family == AF_INET &&
+	    protocol != IPPROTO_RAW &&
 	    !rcu_access_pointer(inet_protos[protocol]))
 		return -ENOENT;
 #endif
-- 
2.20.1



