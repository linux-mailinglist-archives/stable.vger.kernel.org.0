Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1951C2ABAE5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgKINU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgKINU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 099BB20663;
        Mon,  9 Nov 2020 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928027;
        bh=y/gsWimhlOriT2iB0GGb7doP5K83/bg3yp/dF94Ay/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvSbN/ZEnckg+dhdYtFp6trd2trjnbnjvjW+UorXlG/0LRulOc1VeXGpwgwIh6yaL
         /K5THAK/0+mkh/HRwgp3Hbb1maC2WJA64a2dNO0AvocyAbiG9+qJEEbFg4MbW2TJJe
         OElS2Z0RY9Ezzlnv5/jdcqLWbqDWzWNruuGlzNGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Kiryanov <rkir@google.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 095/133] vsock: use ns_capable_noaudit() on socket create
Date:   Mon,  9 Nov 2020 13:55:57 +0100
Message-Id: <20201109125035.268486670@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Vander Stoep <jeffv@google.com>

[ Upstream commit af545bb5ee53f5261db631db2ac4cde54038bdaf ]

During __vsock_create() CAP_NET_ADMIN is used to determine if the
vsock_sock->trusted should be set to true. This value is used later
for determing if a remote connection should be allowed to connect
to a restricted VM. Unfortunately, if the caller doesn't have
CAP_NET_ADMIN, an audit message such as an selinux denial is
generated even if the caller does not want a trusted socket.

Logging errors on success is confusing. To avoid this, switch the
capable(CAP_NET_ADMIN) check to the noaudit version.

Reported-by: Roman Kiryanov <rkir@google.com>
https://android-review.googlesource.com/c/device/generic/goldfish/+/1468545/
Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Link: https://lore.kernel.org/r/20201023143757.377574-1-jeffv@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc07..b4d7b8aba0037 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -739,7 +739,7 @@ static struct sock *__vsock_create(struct net *net,
 		vsk->buffer_min_size = psk->buffer_min_size;
 		vsk->buffer_max_size = psk->buffer_max_size;
 	} else {
-		vsk->trusted = capable(CAP_NET_ADMIN);
+		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
 		vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
 		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
-- 
2.27.0



