Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77651171A26
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgB0NvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbgB0NvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBBD72468D;
        Thu, 27 Feb 2020 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811476;
        bh=RPlm2GajjbDNkG4YzWW8QnaOI5Ngkgsck5AoDtdTrOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBAuLkZVoZIrFnPfpMY0fU32Tv2VbqlNMBDHgyUvcwYz1+s/5YZRo4vyePQU90Jvo
         h4UbXFWeFJBfKg1YNi2dC8iGKnxnNuZ7MPS1msYP10/oQD636MzOmA+hibvPMR2lO6
         /94MXcp3RG/wJxo702dHsSEgb29pcTY6WyRIzNkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 147/165] ext4: fix mount failure with quota configured as module
Date:   Thu, 27 Feb 2020 14:37:01 +0100
Message-Id: <20200227132252.255750087@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 9db176bceb5c5df4990486709da386edadc6bd1d upstream.

When CONFIG_QFMT_V2 is configured as a module, the test in
ext4_feature_set_ok() fails and so mount of filesystems with quota or
project features fails. Fix the test to use IS_ENABLED macro which
works properly even for modules.

Link: https://lore.kernel.org/r/20200221100835.9332-1-jack@suse.cz
Fixes: d65d87a07476 ("ext4: improve explanation of a mount failure caused by a misconfigured kernel")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2743,7 +2743,7 @@ static int ext4_feature_set_ok(struct su
 		return 0;
 	}
 
-#if !defined(CONFIG_QUOTA) || !defined(CONFIG_QFMT_V2)
+#if !IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)
 	if (!readonly && (ext4_has_feature_quota(sb) ||
 			  ext4_has_feature_project(sb))) {
 		ext4_msg(sb, KERN_ERR,


