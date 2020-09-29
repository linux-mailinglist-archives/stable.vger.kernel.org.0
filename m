Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534B627BA43
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgI2Bae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI2Bab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD3621734;
        Tue, 29 Sep 2020 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343030;
        bh=zB0SGeeoNPVMkVnQLXd5mspfS30Xe6OaobqccoNYGuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQpo1itrfHYIa3bfnoMVkPwryZ7WZ/jrEMBr4My59eNxYqJEzVGgsMBFFxzuXYrXR
         biaoBXMdWEeFagKD5o6sotBwbtzgJzY5J5ty4AtPTPhYYonebFCNPLJFtZjMUNiLmN
         wkvo1X8d8W1/55P0sRhoHIXjTzgP8mQYurOQbpEM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 02/29] vboxsf: Fix the check for the old binary mount-arguments struct
Date:   Mon, 28 Sep 2020 21:29:59 -0400
Message-Id: <20200929013027.2406344-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9d682ea6bcc76b8b2691c79add59f7d99c881635 ]

Fix the check for the mainline vboxsf code being used with the old
mount.vboxsf mount binary from the out-of-tree vboxsf version doing
a comparison between signed and unsigned data types.

This fixes the following smatch warnings:

fs/vboxsf/super.c:390 vboxsf_parse_monolithic() warn: impossible condition '(options[1] == (255)) => ((-128)-127 == 255)'
fs/vboxsf/super.c:391 vboxsf_parse_monolithic() warn: impossible condition '(options[2] == (254)) => ((-128)-127 == 254)'
fs/vboxsf/super.c:392 vboxsf_parse_monolithic() warn: impossible condition '(options[3] == (253)) => ((-128)-127 == 253)'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/vboxsf/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/vboxsf/super.c b/fs/vboxsf/super.c
index 8fe03b4a0d2b0..25aade3441922 100644
--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -384,7 +384,7 @@ static int vboxsf_setup(void)
 
 static int vboxsf_parse_monolithic(struct fs_context *fc, void *data)
 {
-	char *options = data;
+	unsigned char *options = data;
 
 	if (options && options[0] == VBSF_MOUNT_SIGNATURE_BYTE_0 &&
 		       options[1] == VBSF_MOUNT_SIGNATURE_BYTE_1 &&
-- 
2.25.1

