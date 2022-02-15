Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB484B6606
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 09:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiBOI2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 03:28:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbiBOI2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 03:28:23 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967C3C4B49
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 00:28:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c4so12349488pfl.7
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 00:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHv1n0i7998YMl6pCrmGBhHuQg0Ik9GCJVUwsgk6NyI=;
        b=SzEHHpKLORB6RP1qqruYIcx6VMi8e0779AWKhYGz7pzLCfMfFAgISkF7EDQ9RikxeH
         D0bnE96X4izeLFBWiwodswLJIfmyxETqQWaXoHUH/OxX73UUPoIElNvGkJtzd4XMiLk3
         o7mvECJ7LjQuWeSeTj7c1UbSC8BB0mQiPd1k67UKAxYwCchUexiZWOktRJ1SsqwqPpnH
         bxd5q8uXdOipb02YG28Dkywbcd6x5grIappWpHIXZiHBtZ8Zts1LmTA+dxkW1D3vJTnG
         ehKHgGZlA5neRXp8c7iARaOBLm7UOPhK1Fzzn+I9lproCs7sM7I7l6IDvXSEThlge1j3
         5nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHv1n0i7998YMl6pCrmGBhHuQg0Ik9GCJVUwsgk6NyI=;
        b=0TVL+A/HW1JrevtVgK2ZpfDbmluEOv2fIidbjOCEXWlwDas7pDxRSQLaU5JkGrHjci
         4SC7d0IOS340nRy3P4PhwC6izcvqiRkJQPqQtNEQ9p2NV4+kwQ5vufFZJc8hDapnSt3E
         eOOfgxXNxrFV9i+UFKljObWwBNpVIWjJTdldSPePZhbY0TsXUDxDKU9DBZQtgSq/XKid
         fon5WmtTkFSWf4ZTutFjnCKF+h1Cy3YsQEng3BYuWnp6rL23cG2CClp2A62a7NP7rWEV
         tJiiEy3FpJsCXMtik41NsX05adSu0Lla0dW/S1DXkdrmQk28GWCuALiSKS/kO0+WoaBT
         2HEQ==
X-Gm-Message-State: AOAM5301VyfOdFgEZt+E1axMtGQH9b9/1vd3/83XRNSzXHberAp8B308
        a5D4gC5QSu3gGi6SUmSyAeiTVv2XKms=
X-Google-Smtp-Source: ABdhPJyciS7qFarR3EclpnfMW1amIke6GYxl0mxpjsNqdTuwmQdSUMQQyI50Q1fks29FiDWHqkpULA==
X-Received: by 2002:a63:8942:: with SMTP id v63mr2638880pgd.106.1644913692934;
        Tue, 15 Feb 2022 00:28:12 -0800 (PST)
Received: from localhost.localdomain ([222.104.200.120])
        by smtp.gmail.com with ESMTPSA id nm15sm16494859pjb.17.2022.02.15.00.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 00:28:12 -0800 (PST)
From:   Juhyung Park <qkrwngud825@gmail.com>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     Juhyung Park <qkrwngud825@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] f2fs: quota: fix loop condition at f2fs_quota_sync()
Date:   Tue, 15 Feb 2022 17:27:21 +0900
Message-Id: <20220215082721.844244-1-qkrwngud825@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cnt should be passed to sb_has_quota_active() instead of type to check
active quota properly.

Moreover, when the type is -1, the compiler with enough inline knowledge
can discard sb_has_quota_active() check altogether, causing a NULL pointer
dereference at the following inode_lock(dqopt->files[cnt]):

[    2.796010] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
[    2.796024] Mem abort info:
[    2.796025]   ESR = 0x96000005
[    2.796028]   EC = 0x25: DABT (current EL), IL = 32 bits
[    2.796029]   SET = 0, FnV = 0
[    2.796031]   EA = 0, S1PTW = 0
[    2.796032] Data abort info:
[    2.796034]   ISV = 0, ISS = 0x00000005
[    2.796035]   CM = 0, WnR = 0
[    2.796046] user pgtable: 4k pages, 39-bit VAs, pgdp=00000003370d1000
[    2.796048] [00000000000000a0] pgd=0000000000000000, pud=0000000000000000
[    2.796051] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    2.796056] CPU: 7 PID: 640 Comm: f2fs_ckpt-259:7 Tainted: G S                5.4.179-arter97-r8-64666-g2f16e087f9d8 #1
[    2.796057] Hardware name: Qualcomm Technologies, Inc. Lahaina MTP lemonadep (DT)
[    2.796059] pstate: 80c00005 (Nzcv daif +PAN +UAO)
[    2.796065] pc : down_write+0x28/0x70
[    2.796070] lr : f2fs_quota_sync+0x100/0x294
[    2.796071] sp : ffffffa3f48ffc30
[    2.796073] x29: ffffffa3f48ffc30 x28: 0000000000000000
[    2.796075] x27: ffffffa3f6d718b8 x26: ffffffa415fe9d80
[    2.796077] x25: ffffffa3f7290048 x24: 0000000000000001
[    2.796078] x23: 0000000000000000 x22: ffffffa3f7290000
[    2.796080] x21: ffffffa3f72904a0 x20: ffffffa3f7290110
[    2.796081] x19: ffffffa3f77a9800 x18: ffffffc020aae038
[    2.796083] x17: ffffffa40e38e040 x16: ffffffa40e38e6d0
[    2.796085] x15: ffffffa40e38e6cc x14: ffffffa40e38e6d0
[    2.796086] x13: 00000000000004f6 x12: 00162c44ff493000
[    2.796088] x11: 0000000000000400 x10: ffffffa40e38c948
[    2.796090] x9 : 0000000000000000 x8 : 00000000000000a0
[    2.796091] x7 : 0000000000000000 x6 : 0000d1060f00002a
[    2.796093] x5 : ffffffa3f48ff718 x4 : 000000000000000d
[    2.796094] x3 : 00000000060c0000 x2 : 0000000000000001
[    2.796096] x1 : 0000000000000000 x0 : 00000000000000a0
[    2.796098] Call trace:
[    2.796100]  down_write+0x28/0x70
[    2.796102]  f2fs_quota_sync+0x100/0x294
[    2.796104]  block_operations+0x120/0x204
[    2.796106]  f2fs_write_checkpoint+0x11c/0x520
[    2.796107]  __checkpoint_and_complete_reqs+0x7c/0xd34
[    2.796109]  issue_checkpoint_thread+0x6c/0xb8
[    2.796112]  kthread+0x138/0x414
[    2.796114]  ret_from_fork+0x10/0x18
[    2.796117] Code: aa0803e0 aa1f03e1 52800022 aa0103e9 (c8e97d02)
[    2.796120] ---[ end trace 96e942e8eb6a0b53 ]---
[    2.800116] Kernel panic - not syncing: Fatal exception
[    2.800120] SMP: stopping secondary CPUs

Fixes: 9de71ede81e6 ("f2fs: quota: fix potential deadlock")
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
---
 fs/f2fs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 22fb4d3b1170..8e3840973077 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2689,7 +2689,7 @@ int f2fs_quota_sync(struct super_block *sb, int type)
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int cnt;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Now when everything is written we can discard the pagecache so
@@ -2700,8 +2700,8 @@ int f2fs_quota_sync(struct super_block *sb, int type)
 		if (type != -1 && cnt != type)
 			continue;
 
-		if (!sb_has_quota_active(sb, type))
-			return 0;
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
 
 		inode_lock(dqopt->files[cnt]);
 
-- 
2.35.1

