Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DA68120B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbjA3OSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbjA3ORh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EEE3D0A3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 290B661083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260B8C433D2;
        Mon, 30 Jan 2023 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088225;
        bh=8fbt8vPswItPK8ub1PvxmY0Sn7SpW/ZuGrVapLwmwmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJUesG57U0gwszS8nG5OiLrpKU0jVdFpXU+UmSPQRb9sQF0stwa2DHCQdke4Y/u3V
         t+KXC/Rg1mUN43Y7He20zjznej4oajqZfu/SWXABg2e5ZqFcsJVtnP6gf+jVCNqKYu
         8LZUpDtiU+pv5GbqrlIWpNVjjq3JEfZc+6i7YZrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 157/204] ksmbd: downgrade ndr version error message to debug
Date:   Mon, 30 Jan 2023 14:52:02 +0100
Message-Id: <20230130134323.441328309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit a34dc4a9b9e2fb3a45c179a60bb0b26539c96189 upstream.

When user switch samba to ksmbd, The following message flood is coming
when accessing files. Samba seems to changs dos attribute version to v5.
This patch downgrade ndr version error message to debug.

$ dmesg
...
[68971.766914] ksmbd: v5 version is not supported
[68971.779808] ksmbd: v5 version is not supported
[68971.871544] ksmbd: v5 version is not supported
[68971.910135] ksmbd: v5 version is not supported
...

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ndr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -242,7 +242,7 @@ int ndr_decode_dos_attr(struct ndr *n, s
 		return ret;
 
 	if (da->version != 3 && da->version != 4) {
-		pr_err("v%d version is not supported\n", da->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", da->version);
 		return -EINVAL;
 	}
 
@@ -251,7 +251,7 @@ int ndr_decode_dos_attr(struct ndr *n, s
 		return ret;
 
 	if (da->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       da->version, version2);
 		return -EINVAL;
 	}
@@ -453,7 +453,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, s
 	if (ret)
 		return ret;
 	if (acl->version != 4) {
-		pr_err("v%d version is not supported\n", acl->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", acl->version);
 		return -EINVAL;
 	}
 
@@ -461,7 +461,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, s
 	if (ret)
 		return ret;
 	if (acl->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       acl->version, version2);
 		return -EINVAL;
 	}


