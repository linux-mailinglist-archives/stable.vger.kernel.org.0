Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968B5353F8B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhDEJNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhDEJMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DE3961002;
        Mon,  5 Apr 2021 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613955;
        bh=xuUmS80t1X4JLO/dQPmcfEov7ygVrHQ0Zbrwlc7eCRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KY+lEANMmbuyqOxDToagHHoagk1Ze+0gHrG4nl3IYUSw12qxTIZZ7UxXhuMZdcdNz
         5mHkDf6BQDaZSslc5qkUFE3hQv7bMQkTi0Bpj5W6C0mStddnwSRVI36fTwFmFqvcKF
         JJOQ9+L5BXhnJCnGu8p5Q3qMIp6xTTOnrV8CmMyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 005/152] fs: nfsd: fix kconfig dependency warning for NFSD_V4
Date:   Mon,  5 Apr 2021 10:52:34 +0200
Message-Id: <20210405085034.402409696@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 7005227369079963d25fb2d5d736d0feb2c44cf6 ]

When NFSD_V4 is enabled and CRYPTO is disabled,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for CRYPTO_SHA256
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - NFSD_V4 [=y] && NETWORK_FILESYSTEMS [=y] && NFSD [=y] && PROC_FS [=y]

WARNING: unmet direct dependencies detected for CRYPTO_MD5
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - NFSD_V4 [=y] && NETWORK_FILESYSTEMS [=y] && NFSD [=y] && PROC_FS [=y]

This is because NFSD_V4 selects CRYPTO_MD5 and CRYPTO_SHA256,
without depending on or selecting CRYPTO, despite those config options
being subordinate to CRYPTO.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index dbbc583d6273..248f1459c039 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -73,6 +73,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
+	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select GRACE_PERIOD
-- 
2.30.1



