Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D01660FDF0
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiJ0RAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbiJ0RAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F24DA23C7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C475623EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379AC433C1;
        Thu, 27 Oct 2022 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890035;
        bh=wg+ZxOtNh4RH2MvZqVv/KNL3leuZ5SweDJtFezvGaYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n73tRUX6wOfm2pjxdOXllWgpgJ4wZLi/yS141PhT34/yYJeqdzeBdijWQH+XhDpUu
         wG7EfZQCdGCmvi+a/Aee6+hkvndAiR9+tuZuyGAC1LI2+DBEbk+kaErsHFdb1A1faH
         pBjIzOkctu1AsSSn7ozwETBKoWsvFOzp4Xh1YTc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 62/94] cifs: Fix memory leak when build ntlmssp negotiate blob failed
Date:   Thu, 27 Oct 2022 18:55:04 +0200
Message-Id: <20221027165059.667920765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 30b2d7f8f13664655480d6af45f60270b3eb6736 ]

There is a memory leak when mount cifs:
  unreferenced object 0xffff888166059600 (size 448):
    comm "mount.cifs", pid 51391, jiffies 4295596373 (age 330.596s)
    hex dump (first 32 bytes):
      fe 53 4d 42 40 00 00 00 00 00 00 00 01 00 82 00  .SMB@...........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<0000000060609a61>] mempool_alloc+0xe1/0x260
      [<00000000adfa6c63>] cifs_small_buf_get+0x24/0x60
      [<00000000ebb404c7>] __smb2_plain_req_init+0x32/0x460
      [<00000000bcf875b4>] SMB2_sess_alloc_buffer+0xa4/0x3f0
      [<00000000753a2987>] SMB2_sess_auth_rawntlmssp_negotiate+0xf5/0x480
      [<00000000f0c1f4f9>] SMB2_sess_setup+0x253/0x410
      [<00000000a8b83303>] cifs_setup_session+0x18f/0x4c0
      [<00000000854bd16d>] cifs_get_smb_ses+0xae7/0x13c0
      [<000000006cbc43d9>] mount_get_conns+0x7a/0x730
      [<000000005922d816>] cifs_mount+0x103/0xd10
      [<00000000e33def3b>] cifs_smb3_do_mount+0x1dd/0xc90
      [<0000000078034979>] smb3_get_tree+0x1d5/0x300
      [<000000004371f980>] vfs_get_tree+0x41/0xf0
      [<00000000b670d8a7>] path_mount+0x9b3/0xdd0
      [<000000005e839a7d>] __x64_sys_mount+0x190/0x1d0
      [<000000009404c3b9>] do_syscall_64+0x35/0x80

When build ntlmssp negotiate blob failed, the session setup request
should be freed.

Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5016d742576d..92a1d0695ebd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1526,7 +1526,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 					  &blob_length, ses, server,
 					  sess_data->nls_cp);
 	if (rc)
-		goto out_err;
+		goto out;
 
 	if (use_spnego) {
 		/* BB eventually need to add this */
-- 
2.35.1



