Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B7334C704
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhC2ILj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhC2ILD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2737C61960;
        Mon, 29 Mar 2021 08:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005462;
        bh=xVKSMKGIWpO1GBcmuKdqsKwbK1EeZMVxxrB8EVYVhfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWkkKi0gJn9phToR3UaRe9Cih31hHN/MvS1viLd/hb9vNvauADb0hvorcJKhGN8OU
         UbZCFiNulNmU2jywsUHy7ykNflYSWoDpN50pTdq+0GwTgSZ9Ur+igPuEWYptkFkYhT
         Ij4jtvddp2tFcWV1o90vrXq0QA/MqRwaVyQyLcjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/111] cifs: ask for more credit on async read/write code paths
Date:   Mon, 29 Mar 2021 09:57:21 +0200
Message-Id: <20210329075615.639410527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7adecfd0c1e9..81d9c4ea0e8f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3743,8 +3743,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest =
-			cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 1);
+		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
 
 		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
 		if (rc)
@@ -4038,8 +4037,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
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



