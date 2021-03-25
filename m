Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CCD348F5C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhCYL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhCYL0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61ED461A3B;
        Thu, 25 Mar 2021 11:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671568;
        bh=xuUmS80t1X4JLO/dQPmcfEov7ygVrHQ0Zbrwlc7eCRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsLDv/SgP+EqlleYbfRADLNHrd/VNeq5ODy/RFWAAzvZW8qxheHcVchdfrzOdLzGf
         XjFdHc0xB/YPLcYA/JHwjBfSi9XYoysw61vTAlyHd8JBKRRIuxLIVR/CbPMczkViJE
         Y2As6CfqTw3xh7E5TBsOLvnM8y5kOfYJBeDiD8cSaYueVZ2Q7u1YEqcKtaG/A2EYfC
         z7UZ79jVv1aY61tAy6YQADb2zLx9HaWsyu4fpLw0DjHiLTAosxeqyztnHwQKkN4U+8
         H2GwT6QiAi8Q6Au8DlMq5AtLMOiyvwpiLKC2bZCMDL17ObdyuZmrydVWNJseFbpbnq
         H5ICrEWdTvujQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/39] fs: nfsd: fix kconfig dependency warning for NFSD_V4
Date:   Thu, 25 Mar 2021 07:25:25 -0400
Message-Id: <20210325112558.1927423-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
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

