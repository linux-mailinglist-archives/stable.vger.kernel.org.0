Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543933C4CC8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242891AbhGLHHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242157AbhGLHGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 398826128B;
        Mon, 12 Jul 2021 07:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073409;
        bh=x64vuByuN8kJItEe+sAuXAhoznJt8trCXN6NHO1poMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXeKtaC9wLj4k2dL1WU5tl03cgdrdQCbUga30syclDNvxIQAA0C90h3rFdfwjsHiE
         8QObK7dWbBnYwAmwtg+7wq6UzRbB55CTwhzgwHK0EEEzbMUrCFka+E8s91EqhbZGW0
         P5Jxa9jrgm62fUL7+UpuvlWZKNDcMZ3BmByVrtwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Cabrero <scabrero@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 232/700] smb3: fix uninitialized value for port in witness protocol move
Date:   Mon, 12 Jul 2021 08:05:15 +0200
Message-Id: <20210712060959.664691235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit ff93b71a3eff25fe9d4364ef13b6e01d935600c6 ]

Although in practice this can not occur (since IPv4 and IPv6 are the
only two cases currently supported), it is cleaner to avoid uninitialized
variable warnings.

Addresses smatch warning:
  fs/cifs/cifs_swn.c:468 cifs_swn_store_swn_addr() error: uninitialized symbol 'port'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
CC: Samuel Cabrero <scabrero@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_swn.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index d829b8bf833e..93b47818c6c2 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -447,15 +447,13 @@ static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 				   const struct sockaddr_storage *old,
 				   struct sockaddr_storage *dst)
 {
-	__be16 port;
+	__be16 port = cpu_to_be16(CIFS_PORT);
 
 	if (old->ss_family == AF_INET) {
 		struct sockaddr_in *ipv4 = (struct sockaddr_in *)old;
 
 		port = ipv4->sin_port;
-	}
-
-	if (old->ss_family == AF_INET6) {
+	} else if (old->ss_family == AF_INET6) {
 		struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)old;
 
 		port = ipv6->sin6_port;
@@ -465,9 +463,7 @@ static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 		struct sockaddr_in *ipv4 = (struct sockaddr_in *)new;
 
 		ipv4->sin_port = port;
-	}
-
-	if (new->ss_family == AF_INET6) {
+	} else if (new->ss_family == AF_INET6) {
 		struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)new;
 
 		ipv6->sin6_port = port;
-- 
2.30.2



