Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9908738A88A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhETKvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238511AbhETKt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98ADC61624;
        Thu, 20 May 2021 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504743;
        bh=I8jmfYHEiMAQZxO0KSLEM3bvt/fJTbONMc5LuOWcpOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJH7Lu3FnfF8WCRfhIkvgOE8QAnYZLMW2ygYpV3YB56WeKTbNNVHoWMtIujL3IL56
         uFcf2BJJRlapECu/axuXsWvLJSgp5iR1QAWxWsa082S7AlefDNjDaUihD6aG3/ZqKb
         cGCk6hL36DaK70UqsYUVvgAK2ZmFRP06IoAeMCkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Fengnan Chang <changfengnan@vivo.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 060/240] ext4: fix error code in ext4_commit_super
Date:   Thu, 20 May 2021 11:20:52 +0200
Message-Id: <20210520092110.701773877@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -4678,8 +4678,10 @@ static int ext4_commit_super(struct supe
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;
 
-	if (!sbh || block_device_ejected(sb))
-		return error;
+	if (!sbh)
+		return -EINVAL;
+	if (block_device_ejected(sb))
+		return -ENODEV;
 
 	/*
 	 * If the file system is mounted read-only, don't update the


