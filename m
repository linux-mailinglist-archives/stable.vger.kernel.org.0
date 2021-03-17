Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1A33E3C8
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhCQA5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhCQA5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DDA64FB4;
        Wed, 17 Mar 2021 00:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942635;
        bh=tA4CK3NAKwUToyZ9AmHKSR6pBb2laXj7OM143GZcISg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=At0V6t0HJxwsDwbMRAkwxxTXacD0AA06GCO5YLr/Y1Bw9ecHOfX0YKf3aUkyXcax7
         PNPvncMqs3yzGALSf79yIp3E6fc0tonbJ1WytN/LrzNiUrcTloILAsFkm6xIXmjvq1
         Ro7EtFewZJV59bnaV6fHY2qywEXqinTe8gJZQKiPqRgxoiQLGbwK4F83LyilOC/zWf
         2ebUfKL+Tima/dnENBs86smigRdVOptyBhWJzeF2U/qiEcAKZA0Jii5WZDAf9xbrK0
         HlR+uwZIEf12k4pNwN6VKzeJWT2RA9+pf/0LdleOuWNUn55bDmGFjDlCAzBrAiLz4l
         dHSjyaGs40pvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 16/54] cifs: ask for more credit on async read/write code paths
Date:   Tue, 16 Mar 2021 20:56:15 -0400
Message-Id: <20210317005654.724862-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

[ Upstream commit 88fd98a2306755b965e4f4567f84e73db3b6738c ]

When doing a large read or write workload we only
very gradually increase the number of credits
which can cause problems with parallelizing large i/o
(I/O ramps up more slowly than it should for large
read/write workloads) especially with multichannel
when the number of credits on the secondary channels
starts out low (e.g. less than about 130) or when
recovering after server throttled back the number
of credit.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c6f8bc6729aa..d1d550647cd6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4032,8 +4032,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest =
-			cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 1);
+		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
 
 		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
 		if (rc)
@@ -4339,8 +4338,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (wdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest =
-			cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 1);
+		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
 
 		rc = adjust_credits(server, &wdata->credits, wdata->bytes);
 		if (rc)
-- 
2.30.1

