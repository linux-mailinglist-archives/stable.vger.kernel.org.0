Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1137F1EC6C7
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 03:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgFCBew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 21:34:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28332 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbgFCBew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 21:34:52 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200603013449epoutp0254b1a3162c6ced34762709282f4eea5c~U5MHZtEJY2956329563epoutp02B
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 01:34:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200603013449epoutp0254b1a3162c6ced34762709282f4eea5c~U5MHZtEJY2956329563epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591148089;
        bh=pVH5ouesIXx/FtDlG2ZC2wq8Kia7pcDu8KnfMkKe8g8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=S2Z67GsgVgCYMaABz5QJfj0H+/So0KSS9vP5W9Esiuw/eDXVodKeJFUPfUDKmXwpU
         87zg8782Smvue6vdk0mnnjQfAVEpZrV8F7iICTxg56Cshs6eyyB4tFfk2po0+qGaG4
         /QnLvXWuZDFtYlXsDzIWNqMiwcaTRsKncfJIipYk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200603013449epcas1p16b4671a7a61179018f263aae9b02fc38~U5MHH7h7r0686706867epcas1p1k;
        Wed,  3 Jun 2020 01:34:49 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.160]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49cBKh0S9qzMqYm9; Wed,  3 Jun
        2020 01:34:48 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.16.28581.73EF6DE5; Wed,  3 Jun 2020 10:34:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b~U5MFNw9u00064800648epcas1p4U;
        Wed,  3 Jun 2020 01:34:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200603013447epsmtrp2a08ee182682a04e5139e48dcd0bab616~U5MFM2hdl2533625336epsmtrp21;
        Wed,  3 Jun 2020 01:34:47 +0000 (GMT)
X-AuditID: b6c32a38-2cdff70000006fa5-a9-5ed6fe370b1d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.D5.08382.73EF6DE5; Wed,  3 Jun 2020 10:34:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200603013447epsmtip18e07498feb1e16070c3f00fb6279e0f4~U5MFApNv71385013850epsmtip1g;
        Wed,  3 Jun 2020 01:34:47 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
        viro@zeniv.linux.org.uk, butterflyhuangxx@gmail.com,
        sj1557.seo@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] exfat: fix memory leak in exfat_parse_param()
Date:   Wed,  3 Jun 2020 10:29:57 +0900
Message-Id: <20200603012957.9200-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmga75v2txBquXK1rMWTWFzWLP3pMs
        Fpd3zWGz+DG93mLLvyOsFgs2PmK0OPKmm9ni/N/jrA4cHjtn3WX32DPxJJtH35ZVjB6fN8l5
        bHrylimANSrHJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNct
        MwfoFCWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFBgV5xYm5xaV66XnJ+rpWh
        gYGRKVBlQk7GkTMLmQqmiFTs7t/L1sD4RqCLkYNDQsBEYt3v2i5GLg4hgR2MEstvbWGGcD4x
        Stzad4Oti5ETyPnGKDF7MxeIDdLw5sY8VoiivYwSu3YvZIXrWPVvJSvIWDYBbYk/W0RBTBEB
        RYnL751ASpgFzjBK7DxwkwVkkLCAncTTU3vBbBYBVYmFU7vBlvEKWEtMfHaSDWKZvMTqDQeY
        Iexd7BKT/mdB2C4Srb/7oWqEJV4d38IOYUtJfH63lw3is2qJj/uhWjsYJV58t4WwjSVurt8A
        diWzgKbE+l36EGFFiZ2/5zKC2MwCfBLvvvawQkzhlehoE4IoUZXou3SYCcKWluhq/wC11EPi
        yOuzzJCQipX4P+cN2wRG2VkICxYwMq5iFEstKM5NTy02LDBBjqBNjOCkpWWxg3Hu2w96hxiZ
        OBgPMUpwMCuJ8FrJXosT4k1JrKxKLcqPLyrNSS0+xGgKDK2JzFKiyfnAtJlXEm9oamRsbGxh
        YmZuZmqsJM570upCnJBAemJJanZqakFqEUwfEwenVAPT9L/vQvOPn/FctZtpW+nC6iW7GWdL
        Re149jfnpd7X+ltqt4ML9pVNWHmnmIdd/QXn30c3JCbpnt6y5PLDrGbGW51ve+6Kxrdwsuip
        SkhN+/hn/dt1i3X4ItdbOV84mHmx4Iy/WraY2gvHn/+nTT670Mo6NGDz4aCYj4cDKn5/WuXB
        xHxXz5dF/NbxKR/S5SfP5qjn/Z92aJJnTtCkrMN9jovM8hcw+hq/fpyxc7dEynyVAJ3C5sk9
        BSvbNTtV3mRO+tpRVxHffrzQ5vDPTxtkwi8VTtxx8pzQuf18WlK37/tx2AbNmrjXILs/07Ax
        rreK4e293SzJQR8N8hUbmvmfCzttk7PmLzj8SjFqdY+lEktxRqKhFnNRcSIANSmD+OMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42LZdlhJTtf837U4g1+f2C3mrJrCZrFn70kW
        i8u75rBZ/Jheb7Hl3xFWiwUbHzFaHHnTzWxx/u9xVgcOj52z7rJ77Jl4ks2jb8sqRo/Pm+Q8
        Nj15yxTAGsVlk5Kak1mWWqRvl8CVceTMQqaCKSIVu/v3sjUwvhHoYuTkkBAwkXhzYx5rFyMX
        h5DAbkaJkz0PmCAS0hLHTpxh7mLkALKFJQ4fLoao+cAosXHibiaQOJuAtsSfLaIgpoiAosTl
        904gJcwCVxglvr28wwwyRljATuLpqb0sIDaLgKrEwqndbCA2r4C1xMRnJ9kgVslLrN5wgHkC
        I88CRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBoaSluYNx+6oPeocYmTgYDzFK
        cDArifBayV6LE+JNSaysSi3Kjy8qzUktPsQozcGiJM57o3BhnJBAemJJanZqakFqEUyWiYNT
        qoFpJbsDz+mtm1nOnP7xue9MOuNExoRNlXyrZjnebb/UMiNJbgbvt4y/Secveyhvm2flEZFu
        luXxe3ln/tupK89dZDvtLHuY0cE17h/zGY+nvZY52fsniP+/qWvEY5b9su8qx89WIw2dqSk+
        1c186fbaex9ydPq+3CLiU6X242T0rxg95bMf9BouM7DqLM9aFL7kzQ4XwbOLlNZtVZ/BpScW
        efGt9/dqj+/rN8v6tduuuHXuku+ZtykqbzjnP8lIUHnOMWnG82tXNrcbrFzvaazTpXwiqdH5
        bO6BnhefjUq95ugeOGQll/F1korx560f7kjKPFmTMvm7aWnD0d5d1SsKC16HfU/sbvpksqcm
        b6eIEktxRqKhFnNRcSIAg8kwp5QCAAA=
X-CMS-MailID: 20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b
References: <CGME20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b@epcas1p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

butt3rflyh4ck reported memory leak found by syzkaller.

A param->string held by exfat_mount_options.

BUG: memory leak

unreferenced object 0xffff88801972e090 (size 8):
  comm "syz-executor.2", pid 16298, jiffies 4295172466 (age 14.060s)
  hex dump (first 8 bytes):
    6b 6f 69 38 2d 75 00 00                          koi8-u..
  backtrace:
    [<000000005bfe35d6>] kstrdup+0x36/0x70 mm/util.c:60
    [<0000000018ed3277>] exfat_parse_param+0x160/0x5e0
fs/exfat/super.c:276
    [<000000007680462b>] vfs_parse_fs_param+0x2b4/0x610
fs/fs_context.c:147
    [<0000000097c027f2>] vfs_parse_fs_string+0xe6/0x150
fs/fs_context.c:191
    [<00000000371bf78f>] generic_parse_monolithic+0x16f/0x1f0
fs/fs_context.c:231
    [<000000005ce5eb1b>] do_new_mount fs/namespace.c:2812 [inline]
    [<000000005ce5eb1b>] do_mount+0x12bb/0x1b30 fs/namespace.c:3141
    [<00000000b642040c>] __do_sys_mount fs/namespace.c:3350 [inline]
    [<00000000b642040c>] __se_sys_mount fs/namespace.c:3327 [inline]
    [<00000000b642040c>] __x64_sys_mount+0x18f/0x230 fs/namespace.c:3327
    [<000000003b024e98>] do_syscall_64+0xf6/0x7d0
arch/x86/entry/common.c:295
    [<00000000ce2b698c>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

exfat_free() should call exfat_free_iocharset() after stealing
param->string instead of kstrdup in exfat_parse_param().

Fixes: 719c1e182916 ("exfat: add super block operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exfat/super.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 405717e4e3ea..e650e65536f8 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -273,9 +273,8 @@ static int exfat_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 	case Opt_charset:
 		exfat_free_iocharset(sbi);
-		opts->iocharset = kstrdup(param->string, GFP_KERNEL);
-		if (!opts->iocharset)
-			return -ENOMEM;
+		opts->iocharset = param->string;
+		param->string = NULL;
 		break;
 	case Opt_errors:
 		opts->errors = result.uint_32;
@@ -686,7 +685,12 @@ static int exfat_get_tree(struct fs_context *fc)
 
 static void exfat_free(struct fs_context *fc)
 {
-	kfree(fc->s_fs_info);
+	struct exfat_sb_info *sbi = fc->s_fs_info;
+
+	if (sbi) {
+		exfat_free_iocharset(sbi);
+		kfree(sbi);
+	}
 }
 
 static const struct fs_context_operations exfat_context_ops = {
-- 
2.17.1

