Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD06698DFA
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBPHof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjBPHod (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:44:33 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F163C788
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 23:44:31 -0800 (PST)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230216074429epoutp02bb9d2102978f4f5f5f5e8c09905d3cfa~EPk7Ri4Gc1839318393epoutp02Q
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:44:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230216074429epoutp02bb9d2102978f4f5f5f5e8c09905d3cfa~EPk7Ri4Gc1839318393epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676533469;
        bh=oEJl9mI2BPZgtqcU4ebRMNclNVoy/K+7rH+uFc8JogA=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=u/mdwkn69McCwBKe+B0gOHcSguDuCTw0QDDR9kca5fgTEUk3R5b4X2XuCI37K06Od
         BFcAFtNuU8bfielerD+TPNPhCzPnPBSy5mI5bVNAlWRM0Hx6ttgCGnqoZcJU9TJH3X
         S87HvRIgFjdcBkcxtfhvGgOt6Oeqza5uYLsf96ZQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230216074428epcas2p14a2330c2d00e8976848f16f37027ceff~EPk6eeJuO0558405584epcas2p1s;
        Thu, 16 Feb 2023 07:44:28 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.97]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4PHRmD2K6Bz4x9QB; Thu, 16 Feb
        2023 07:44:28 +0000 (GMT)
X-AuditID: b6c32a46-743fa70000007a4b-af-63eddedc5314
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.8D.31307.CDEDDE36; Thu, 16 Feb 2023 16:44:28 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v2] f2fs: fix uninitialized skipped_gc_rwsem
Reply-To: yonggil.song@samsung.com
Sender: Yonggil Song <yonggil.song@samsung.com>
From:   Yonggil Song <yonggil.song@samsung.com>
To:     Chao Yu <chao@kernel.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daehojeong@google.com" <daehojeong@google.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366@epcms2p4>
Date:   Thu, 16 Feb 2023 16:44:27 +0900
X-CMS-MailID: 20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTQvfOvbfJBn/vslucnnqWyWJq+15G
        i+bF69ksnqyfxWxxaZG7xeVdc9gsFmx8xOjA7rFgU6nHplWdbB77565h99i94DOTx+dNcgGs
        Udk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOy
        M/a3b2UseMNW0bRvBXsD403WLkYODgkBE4l53fxdjFwcQgI7GCX6nnxmAonzCghK/N0hDGIK
        C9hI/L1h18XICVSiJHHtQC8LiC0soC+xefEydhCbTUBX4u+G5ewgY0QEJjNJTPiyggkkwSxQ
        JNE3+y9YkYQAr8SM9qcsELa0xPblWxkhbA2JH8t6mSFsUYmbq9+yw9jvj82HqhGRaL13FqpG
        UOLBz91QcUmJRYfOM0HY+RJ/V1xng7BrJLY2tEHF9SWudWwE28sr4CvRvXQZK4jNIqAqMWXe
        Sah7XCQu3/vCDnGzvMT2t3OYQX5nFtCUWL9LHxJSyhJHbrFAVPBJdBxG+GrHvCdQm9QkNm/a
        zAphy0hceNwGdaWHxKSt98AmCgkEStw6qDCBUWEWIphnIVk7C2HtAkbmVYxiqQXFuempxUYF
        RvCITc7P3cQITotabjsYp7z9oHeIkYmD8RCjBAezkgjvpptvkoV4UxIrq1KL8uOLSnNSiw8x
        mgI9PJFZSjQ5H5iY80riDU0sDUzMzAzNjUwNzJXEeaVtTyYLCaQnlqRmp6YWpBbB9DFxcEo1
        MK2U/n1pR+4to4Jg+b64X0+eP6sJ3K2wb5vR9l1av1WupF1SYxfjVZ2w8ImePE97+sETH+P+
        vs7/bbf44dSLOzeoiwg9So/ZFc1QNHn3uviTySfPL5jUtien4d6UYuvb1+zWdZyNFXnwmH3/
        uZez5Rakhrw+6nVvr2ZO/r/tG5xO/E5/skPx973zGwymFE8qbjxive30m4lia7kW/u7KcXbb
        66I/j3+TlRbDn4OJtZnT11Rf2HfYROik7/wZmWYHTiYk3vLamd604Of/Z9aTa2wTZpZXRe4O
        vP34hvq7DSfMhEUdvKovvJpWtXLPguLemTcMbz8NtP75kj1Md3/R9jldPnNdKqzytNx/WBit
        qXm6UomlOCPRUIu5qDgRANiXqR0UBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230215024850epcms2p22be2cc864d82b44f31c19a7ef28770b6
References: <CGME20230215024850epcms2p22be2cc864d82b44f31c19a7ef28770b6@epcms2p4>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When f2fs skipped a gc round during victim migration, there was a bug which
would skip all upcoming gc rounds unconditionally because skipped_gc_rwsem
was not initialized. It fixes the bug by correctly initializing the
skipped_gc_rwsem inside the gc loop.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Cc: stable@vger.kernel.org
Signed-off-by: Yonggil Song <yonggil.song@samsung.com>

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b22f49a6f128..81d326abaac1 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1786,8 +1786,8 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
 				prefree_segments(sbi));
 
 	cpc.reason = __get_cp_reason(sbi);
-	sbi->skipped_gc_rwsem = 0;
 gc_more:
+	sbi->skipped_gc_rwsem = 0;
 	if (unlikely(!(sbi->sb->s_flags & SB_ACTIVE))) {
 		ret = -EINVAL;
 		goto stop;
-- 
2.34.1
