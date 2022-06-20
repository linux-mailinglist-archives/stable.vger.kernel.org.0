Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9187551A8A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244507AbiFTNHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244550AbiFTNFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:05:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C7C19F8B;
        Mon, 20 Jun 2022 06:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E7AB811C1;
        Mon, 20 Jun 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A68C3411B;
        Mon, 20 Jun 2022 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730014;
        bh=EeDfFiTCi71k1MEHOyK+pfp0jw6HhaaTBU2SKACSyXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJPI9aJHzC1EbIQpsLaaRgST6L5QbxkuQJOz8Y4/QsgZWF9yTBfQqLOAHkxxdBxZT
         VwZMhDNZ+jS/ipOtNZjXKB3lHxMtFR/KdVrXRTXitwqSNRcaY3VkncKW1LseC0Ucg1
         ULLExxFPmn2Ou4Cea3WepOv+3exNYniYtyoO/iUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.18 126/141] selinux: free contexts previously transferred in selinux_add_opt()
Date:   Mon, 20 Jun 2022 14:51:04 +0200
Message-Id: <20220620124733.278609889@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Göttsche <cgzones@googlemail.com>

commit cad140d00899e7a9cb6fe93b282051df589e671c upstream.

`selinux_add_opt()` stopped taking ownership of the passed context since
commit 70f4169ab421 ("selinux: parse contexts for mount options early").

    unreferenced object 0xffff888114dfd140 (size 64):
      comm "mount", pid 15182, jiffies 4295687028 (age 796.340s)
      hex dump (first 32 bytes):
        73 79 73 74 65 6d 5f 75 3a 6f 62 6a 65 63 74 5f  system_u:object_
        72 3a 74 65 73 74 5f 66 69 6c 65 73 79 73 74 65  r:test_filesyste
      backtrace:
        [<ffffffffa07dbef4>] kmemdup_nul+0x24/0x80
        [<ffffffffa0d34253>] selinux_sb_eat_lsm_opts+0x293/0x560
        [<ffffffffa0d13f08>] security_sb_eat_lsm_opts+0x58/0x80
        [<ffffffffa0af1eb2>] generic_parse_monolithic+0x82/0x180
        [<ffffffffa0a9c1a5>] do_new_mount+0x1f5/0x550
        [<ffffffffa0a9eccb>] path_mount+0x2ab/0x1570
        [<ffffffffa0aa019e>] __x64_sys_mount+0x20e/0x280
        [<ffffffffa1f47124>] do_syscall_64+0x34/0x80
        [<ffffffffa200007e>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

    unreferenced object 0xffff888108e71640 (size 64):
      comm "fsmount", pid 7607, jiffies 4295044974 (age 1601.016s)
      hex dump (first 32 bytes):
        73 79 73 74 65 6d 5f 75 3a 6f 62 6a 65 63 74 5f  system_u:object_
        72 3a 74 65 73 74 5f 66 69 6c 65 73 79 73 74 65  r:test_filesyste
      backtrace:
        [<ffffffff861dc2b1>] memdup_user+0x21/0x90
        [<ffffffff861dc367>] strndup_user+0x47/0xa0
        [<ffffffff864f6965>] __do_sys_fsconfig+0x485/0x9f0
        [<ffffffff87940124>] do_syscall_64+0x34/0x80
        [<ffffffff87a0007e>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Cc: stable@vger.kernel.org
Fixes: 70f4169ab421 ("selinux: parse contexts for mount options early")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2600,8 +2600,9 @@ static int selinux_sb_eat_lsm_opts(char
 				}
 			}
 			rc = selinux_add_opt(token, arg, mnt_opts);
+			kfree(arg);
+			arg = NULL;
 			if (unlikely(rc)) {
-				kfree(arg);
 				goto free_opt;
 			}
 		} else {
@@ -2792,17 +2793,13 @@ static int selinux_fs_context_parse_para
 					  struct fs_parameter *param)
 {
 	struct fs_parse_result result;
-	int opt, rc;
+	int opt;
 
 	opt = fs_parse(fc, selinux_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
 
-	rc = selinux_add_opt(opt, param->string, &fc->security);
-	if (!rc)
-		param->string = NULL;
-
-	return rc;
+	return selinux_add_opt(opt, param->string, &fc->security);
 }
 
 /* inode security operations */


