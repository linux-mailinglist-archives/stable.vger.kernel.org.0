Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED11266C499
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjAPP4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAPP4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F6E22A13
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15D356102A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1AEC433D2;
        Mon, 16 Jan 2023 15:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884568;
        bh=Gq3FUgU9XTso0yZnbVpNl0BOHlb8C6A4IaHqKpIY3fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUlbD/4a0wXp0QyH3rKKiqoAYmQwm5LtBebWdWvBp7sG9hBGP/ILHN7tJyMIokbay
         4yW6rAdjOKCCa5w3c77c/uhGU8Pjb5zCqMshaSATFD/7WFnOrEq4+K9oFFKAU4dcPU
         LczF9dslwyIhB+XfBImSlHkNfsjC/YSn+Yc1atCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 038/183] cifs: Fix uninitialized memory read for smb311 posix symlink create
Date:   Mon, 16 Jan 2023 16:49:21 +0100
Message-Id: <20230116154804.991119873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volker Lendecke <vl@samba.org>

commit a152d05ae4a71d802d50cf9177dba34e8bb09f68 upstream.

If smb311 posix is enabled, we send the intended mode for file
creation in the posix create context. Instead of using what's there on
the stack, create the mfsymlink file with 0644.

Fixes: ce558b0e17f8a ("smb3: Add posix create context for smb3.11 posix mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/link.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -428,6 +428,7 @@ smb3_create_mf_symlink(unsigned int xid,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);


