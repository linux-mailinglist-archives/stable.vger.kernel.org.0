Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B591AA452
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632941AbgDONXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408871AbgDOLez (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:34:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F1B20936;
        Wed, 15 Apr 2020 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950495;
        bh=Isrih8rMZJRUmtk7ZuU2q84AJ4iMXZIZZshpIbEwdNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7/0SHgEVxKEUh5cligVRowc3rhLOLZ0dRe/7KL95M/y698I7f9pzM4dcBZKPo7TY
         5jimBIoC197qUFuYL8gn3qqc5C4kyXVpPrrkgWhHXhLWfNv3Nk/DdyLbVw1ZGC3txZ
         UMD0sV2RWOJ7XBY2yVyhiO8OHirNXzPzCoK0Nbco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Torsten Duwe <duwe@suse.de>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 008/129] s390/crypto: explicitly memzero stack key material in aes_s390.c
Date:   Wed, 15 Apr 2020 07:32:43 -0400
Message-Id: <20200415113445.11881-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Torsten Duwe <duwe@suse.de>

[ Upstream commit 4a559cd15dbc79958fa9b18ad4e8afe4a0bf4744 ]

aes_s390.c has several functions which allocate space for key material on
the stack and leave the used keys there. It is considered good practice
to clean these locations before the function returns.

Link: https://lkml.kernel.org/r/20200221165511.GB6928@lst.de
Signed-off-by: Torsten Duwe <duwe@suse.de>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 1c23d84a9097d..73044634d3427 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -342,6 +342,7 @@ static int cbc_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		memcpy(walk.iv, param.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
+	memzero_explicit(&param, sizeof(param));
 	return ret;
 }
 
@@ -470,6 +471,8 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 			 walk.dst.virt.addr, walk.src.virt.addr, n);
 		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
+	memzero_explicit(&xts_param, sizeof(xts_param));
 	return ret;
 }
 
-- 
2.20.1

