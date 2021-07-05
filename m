Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F093BBFBD
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhGEPdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhGEPch (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48236199B;
        Mon,  5 Jul 2021 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498999;
        bh=x64vuByuN8kJItEe+sAuXAhoznJt8trCXN6NHO1poMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCuZ71hs+pvMCPu2mobQO/4GxwOqNw/dW/e6EtyYiRTxSdlc7k4w35xJD0jFa6TWo
         B5GAFDp8cfWXm0IsSJY4sI3tksXmpdTJcK5P0mxhvn1h6EE0tGwjMFoDSNWFHlGEnv
         ZeC8mIFfL8HVzepMlwrie1DELv5BcPHNfg9QALYxRncE0VOtulBCnrenstqx9R8Upd
         M5eXDrfXtrDSqJ+RB1OFIUhOLHHLRfCXqPIeLX9H4VGja/GWeEQrAaIkimyTBG9631
         Rh0ohA8hkSZSh9M1l7Aa06q2ClB9n2WDu3XFvoR6+zTXbYyUQV6qN/ga5W8O3ty6Ed
         ERsxP2H7n/ZnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Cabrero <scabrero@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.12 37/52] smb3: fix uninitialized value for port in witness protocol move
Date:   Mon,  5 Jul 2021 11:28:58 -0400
Message-Id: <20210705152913.1521036-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

