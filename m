Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D921EC732
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 04:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFCCOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 22:14:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13870 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCCOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 22:14:41 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200603021439epoutp0367b5cf7790dcc53b3b7656adb4d2dc09~U5u4vB2Ej3195131951epoutp03C
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 02:14:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200603021439epoutp0367b5cf7790dcc53b3b7656adb4d2dc09~U5u4vB2Ej3195131951epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591150479;
        bh=WjEPFCMSo9Tv/PyUNW7xSqxkVRWzm8ZAFe/hH3dlsSQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=KpbBlyq41bI873hjVaMA9KpcQY/gJJq9kBeGubeZ0dpKE5bm7hMvnYR0YybMv8IiU
         z52ieKRnXVMtDUZ/K7IYEXCV2UZoBNQbXnQboivwpzDOh/YdqcCzgT7/Tw/3sfGGFs
         pw6lcPLvuzFVtftUm66ODHYpgAsyiV68DIwmBZDk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200603021438epcas1p2f218b3dd05be7f931e7d990765d31a5e~U5u4D2mq-0533205332epcas1p2Y;
        Wed,  3 Jun 2020 02:14:38 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.161]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49cCCd2pkvzMqYm1; Wed,  3 Jun
        2020 02:14:37 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.04.28578.D8707DE5; Wed,  3 Jun 2020 11:14:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200603021436epcas1p28e26eaba7140c222c9ed09b86a489b58~U5u2yfV1n2121821218epcas1p2_;
        Wed,  3 Jun 2020 02:14:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200603021436epsmtrp23f31a2f80bfa61b83e88980cbf3a8074~U5u2xu0sG1182411824epsmtrp2B;
        Wed,  3 Jun 2020 02:14:36 +0000 (GMT)
X-AuditID: b6c32a39-8c9ff70000006fa2-ca-5ed7078db861
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.79.08382.C8707DE5; Wed,  3 Jun 2020 11:14:36 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200603021436epsmtip29fd33716b1a30f94d67c0de8bb5c0a5c~U5u2lQfUI1151311513epsmtip2E;
        Wed,  3 Jun 2020 02:14:36 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
        viro@zeniv.linux.org.uk, butterflyhuangxx@gmail.com,
        sj1557.seo@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] exfat: fix memory leak in exfat_parse_param()
Date:   Wed,  3 Jun 2020 11:09:39 +0900
Message-Id: <20200603020939.9462-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmnm4v+/U4g/V9ohZzVk1hs9iz9ySL
        xeVdc9gsfkyvt9jy7wirxYKNjxgtjrzpZrY4//c4qwOHx85Zd9k99kw8yebRt2UVo8fnTXIe
        m568ZQpgjcqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAE6RUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJPxbU83W8EesYrpj/YyNTBeF+pi5OSQEDCRWH/xOWMXIxeHkMAORomJz/YxQzif
        GCUebZsLlfnGKPH3/gZmmJZpO+dAJfYySszc1cgG1zJn3TSgKg4ONgFtiT9bREFMEQFFicvv
        nUBKmAXOMErsPHCTBWSQsICjxNIX99hBbBYBVYkru3aDtfIKWEv8PmkMsUteYvWGA2AXSQhs
        Ypdou36XFSLhItF3dSsbhC0s8er4FnYIW0ri87u9bCBzJASqJT7uh7q5g1HixXdbCNtY4ub6
        DawgJcwCmhLrd+lDhBUldv4G+ZcTKMwn8e5rDyvEFF6JjjZoYKlK9F06zARhS0t0tX+AWuoh
        8WHLJbBNQgKxEhOOPmGZwCg7C2HBAkbGVYxiqQXFuempxYYFpshRtIkRnLi0LHcwTn/7Qe8Q
        IxMH4yFGCQ5mJRFeK9lrcUK8KYmVValF+fFFpTmpxYcYTYGhNZFZSjQ5H5g680riDU2NjI2N
        LUzMzM1MjZXEeZ2sL8QJCaQnlqRmp6YWpBbB9DFxcEo1MGln5+hXT3BMLo3/5l+SNuXG0nzx
        Ny+/OMze5iWlLG1ip9G34hyLq+yNv0ffbQo5LbDig9cBW45Xb6a8tHRS2dl4PMd/40k2cc2G
        4leOPBUlRz5LP3F+ulBjRrD88b3xitMc57i9ZzCYO980gtletu96T4CuY52siF/CAznlCfz+
        6xbHBfhsbhBP4fj09Ydypuyv5zWJL/msnrHc1Xk+6eRTr5kr9z03vRBw+GOOQ94t23dXX4Ud
        +D9F4vv/bTFnC1PjtYvXp/o12gYlT9DeWLfg2Rn3Q27Nemx9E7p/t3QlzQ0t+LU9YtGtS3eM
        Lyze8PH696wc4e91fNrfUtiidXNswhMM1qR/8s8NPLO0UImlOCPRUIu5qDgRANqbjbflAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXreH/XqcwdvZRhZzVk1hs9iz9ySL
        xeVdc9gsfkyvt9jy7wirxYKNjxgtjrzpZrY4//c4qwOHx85Zd9k99kw8yebRt2UVo8fnTXIe
        m568ZQpgjeKySUnNySxLLdK3S+DK+Lanm61gj1jF9Ed7mRoYrwt1MXJySAiYSEzbOYexi5GL
        Q0hgN6NE74NvzBAJaYljJ84A2RxAtrDE4cPFEDUfGCUmHfzLCBJnE9CW+LNFFMQUEVCUuPze
        CaSEWeAKo8S3l3fAxggLOEosfXGPHcRmEVCVuLJrN9hIXgFrid8njSE2yUus3nCAeQIjzwJG
        hlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMGBpKW5g3H7qg96hxiZOBgPMUpwMCuJ
        8FrJXosT4k1JrKxKLcqPLyrNSS0+xCjNwaIkznujcGGckEB6YklqdmpqQWoRTJaJg1OqgYl3
        qmAb64OJ/8SmXw/LDjn6/pYzg5+ejObcXfe85qTeZbhQtS2hlv3ivlVdhydXJ80JWLrj3v/3
        N1TW6364eHFGpdG+BdVtR97HpyfVPBJPWxld/pTDqGTO4qNvn+6wEY5X/DYjIvOS4qL/rWeF
        en23O/bN7hWNlFvDIP+9P6X9eUD3TFuLrONREwzDY44s/+j8wJ/NO/lJ979PvTtzFMontLAz
        Bb5ub2HpVWG+6feiZ43pIqaamqmJoWnVc4ujl8b9+Oj5TPyzQl6GgpWBLftKF5fbqlkFN/LT
        r5csm+Qo2LL2fvkpziKOBM7g3vtW+U8O+klNMjdvm/nj2OMNN+6c2x7xyb+Ku/lqt5ZqoRJL
        cUaioRZzUXEiAE1M/fiTAgAA
X-CMS-MailID: 20200603021436epcas1p28e26eaba7140c222c9ed09b86a489b58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200603021436epcas1p28e26eaba7140c222c9ed09b86a489b58
References: <CGME20200603021436epcas1p28e26eaba7140c222c9ed09b86a489b58@epcas1p2.samsung.com>
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

exfat_free() should call exfat_free_iocharset(), to prevent a leak
in case we fail after parsing iocharset= but before calling
get_tree_bdev().

Additionally, there's no point copying param->string in
exfat_parse_param() - just steal it, leaving NULL in param->string.
That's independent from the leak or fix thereof - it's simply
avoiding an extra copy.

Fixes: 719c1e182916 ("exfat: add super block operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 v2:
   - update patch description in more detail.

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

