Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D937171B62
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbgB0OB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732802AbgB0OB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2499246A0;
        Thu, 27 Feb 2020 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812118;
        bh=fgE+TdDt7YBkekHm++IJhKrdcd8VIaBr7KT4k0f+Da4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9Ky4NGfK5zqOx326oAwR3+lK5OsmrTFKS9A7HKAWQwOgd/aqyN4GZWGYKY2VPP8h
         G89o0gmPJUkYGRHzP+kTqE5aXiPNijxhiv+DHDtz/a4A+wk90fYSV2bW/hvqrYfSsr
         OQI6hdXfsGk8yIU5I3Q+yYP1z5h1zps8wFiHEF30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 4.14 228/237] ecryptfs: replace BUG_ON with error handling code
Date:   Thu, 27 Feb 2020 14:37:22 +0100
Message-Id: <20200227132312.890707488@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

commit 2c2a7552dd6465e8fde6bc9cccf8d66ed1c1eb72 upstream.

In crypt_scatterlist, if the crypt_stat argument is not set up
correctly, the kernel crashes. Instead, by returning an error code
upstream, the error is handled safely.

The issue is detected via a static analysis tool written by us.

Fixes: 237fead619984 (ecryptfs: fs/Makefile and fs/Kconfig)
Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -339,8 +339,10 @@ static int crypt_scatterlist(struct ecry
 	struct extent_crypt_result ecr;
 	int rc = 0;
 
-	BUG_ON(!crypt_stat || !crypt_stat->tfm
-	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED));
+	if (!crypt_stat || !crypt_stat->tfm
+	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
+		return -EINVAL;
+
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",
 				crypt_stat->key_size);


