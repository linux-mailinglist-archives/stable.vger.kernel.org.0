Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A406348EEC
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCYLZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhCYLZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8FA61A2E;
        Thu, 25 Mar 2021 11:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671508;
        bh=xuUmS80t1X4JLO/dQPmcfEov7ygVrHQ0Zbrwlc7eCRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLKYO19q6O0UFQRvgp+24d92q/C0utg2d7Uu4JkpRzfsXrDZGHjkWcNb2PABOPv9Y
         cnjcq2EdYyPMEO/DFW5QWnUAG/3WEYEIoM51wOB0u/noQa3yL2POfbdpOXNrlPHZDw
         fMgQqSpPpVeb0usu6kIxK+GguqRqvMhd09kgCtDTNXcI4Q4cHxGPsVkdkq0NDSsuli
         A1paA4NKlKCtAXn47YoiyQlRuKYvgNWAp34KlXpQWDKwAumO4DSHF8KvCrX2ymP0xP
         kaCvui86ydpI1B/A+unUz8jqDF2bGzvgbb+VFOCUo6Zo1Q+qsH0D8kt/KQ6ff/0TDn
         KwbTmmI9BgwDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/44] fs: nfsd: fix kconfig dependency warning for NFSD_V4
Date:   Thu, 25 Mar 2021 07:24:21 -0400
Message-Id: <20210325112459.1926846-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

