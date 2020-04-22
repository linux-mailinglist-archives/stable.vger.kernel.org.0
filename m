Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431131B3F5F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgDVKgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbgDVKWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1737F2076E;
        Wed, 22 Apr 2020 10:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550965;
        bh=Isrih8rMZJRUmtk7ZuU2q84AJ4iMXZIZZshpIbEwdNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkQAMo0x+VojIo//uuhJ1UF8pGRjOr8Q85kmaL5sdV14aQk3ToNAV7ChfyuP69rEz
         kz9zZjlFOmnUM/LEF1xTUN+l+qGwi5CmllhgIHT+rZqBa2hyb2uOVULeRknA5yjDHA
         uTegZ/rXW2v6Hni7KIv9Ec2WmPfbiOzZI0D4PNA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Torsten Duwe <duwe@suse.de>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 046/166] s390/crypto: explicitly memzero stack key material in aes_s390.c
Date:   Wed, 22 Apr 2020 11:56:13 +0200
Message-Id: <20200422095054.041358626@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



