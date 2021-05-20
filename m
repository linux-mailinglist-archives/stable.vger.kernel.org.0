Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113EF38AA6F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhETLNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239608AbhETLLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D9961D44;
        Thu, 20 May 2021 10:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505247;
        bh=h5+CUGgC8WYm+NRzWUxIdxZ0SBfkVvfR6nZpa9ZKVw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nR1TmfellIvqXOWEP51t5fJULH7t6LB1PItYGOpg79b1plhRnSfF2wU2wpvT52SYr
         igmxjn8ukmk8B43KvRF8j5ZQwaFQa4jO7UgQhXEHJ53gCad2Z2dxKHdi5tjHCrPOLA
         fR4LoqFUwRZzYYhEGwtL9zyMYjWrbfxnA+zhoAt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Fengnan Chang <changfengnan@vivo.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 049/190] ext4: fix error code in ext4_commit_super
Date:   Thu, 20 May 2021 11:21:53 +0200
Message-Id: <20210520092103.795095770@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <changfengnan@vivo.com>

commit f88f1466e2a2e5ca17dfada436d3efa1b03a3972 upstream.

We should set the error code when ext4_commit_super check argument failed.
Found in code review.
Fixes: c4be0c1dc4cdc ("filesystem freeze: add error handling of write_super_lockfs/unlockfs").

Cc: stable@kernel.org
Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20210402101631.561-1-changfengnan@vivo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4494,8 +4494,10 @@ static int ext4_commit_super(struct supe
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;
 
-	if (!sbh || block_device_ejected(sb))
-		return error;
+	if (!sbh)
+		return -EINVAL;
+	if (block_device_ejected(sb))
+		return -ENODEV;
 
 	/*
 	 * The superblock bh should be mapped, but it might not be if the


