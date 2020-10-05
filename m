Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00428283ADD
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgJEPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgJEPbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9D32074F;
        Mon,  5 Oct 2020 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911907;
        bh=Jo77Gc6P5QwVraqk5OtJ6s4hd5C50P0jH7a00pjxyPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/Q7Mswzwgb+akJp+zPl7WzKckponvSlYQRfZaG3a6Yy7DB5qixuCcZ3TFl5sfVnt
         c6C4IU2biVMwkXx0sr2tvqdcWiF0G9znMlDXo2y5DnkQLvU1dY/+nx+ImJ5wY3YjI7
         o9kehkhJX8FsAvfg7pIyOUf1YYrljkdy5C/SeeuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 25/85] vboxsf: Fix the check for the old binary mount-arguments struct
Date:   Mon,  5 Oct 2020 17:26:21 +0200
Message-Id: <20201005142115.942894017@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -384,7 +384,7 @@ fail_nomem:
 
 static int vboxsf_parse_monolithic(struct fs_context *fc, void *data)
 {
-	char *options = data;
+	unsigned char *options = data;
 
 	if (options && options[0] == VBSF_MOUNT_SIGNATURE_BYTE_0 &&
 		       options[1] == VBSF_MOUNT_SIGNATURE_BYTE_1 &&
-- 
2.25.1



