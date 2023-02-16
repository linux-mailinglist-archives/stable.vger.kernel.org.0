Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3EF698DC3
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBPH2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBPH23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:28:29 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4393838EBD
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 23:28:26 -0800 (PST)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230216072823epoutp01089a5b0c84059c200d07716f861946c4~EPW3fQIIO0562805628epoutp01S
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:28:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230216072823epoutp01089a5b0c84059c200d07716f861946c4~EPW3fQIIO0562805628epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676532503;
        bh=/s/DDvoDqvkI0R3gCjxwHuxsXwGnIrRYiSsKEv400/g=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=L+RBRGvnQaZDCIqFx12dO+eKvjBFleHXqMZm9ndCCP4TxQ9HSjsHmq8Mo3PvNOwpC
         gKVJXSTVCiDWFrZX7PehW8lfrQevYFP/OqR1310pNQHXPgsiyUHKA/qE8sCMJpGDIH
         KkW/L3I76dqVRfcFV43QIRf1SeKGgQmS6UhFzN94=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230216072822epcas2p18e56acc255c73e58d7f98a47da295c2c~EPW3DGu_N1714217142epcas2p1K;
        Thu, 16 Feb 2023 07:28:22 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.69]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4PHRPf40ryz4x9Pr; Thu, 16 Feb
        2023 07:28:22 +0000 (GMT)
X-AuditID: b6c32a48-1f7ff70000021624-37-63eddb1648e5
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        0C.B8.05668.61BDDE36; Thu, 16 Feb 2023 16:28:22 +0900 (KST)
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Seokhwan Kim <sukka.kim@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230216072821epcms2p35e1fecca382380723ac0031862687173@epcms2p3>
Date:   Thu, 16 Feb 2023 16:28:21 +0900
X-CMS-MailID: 20230216072821epcms2p35e1fecca382380723ac0031862687173
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmqa7Y7bfJBqc3S1mcnnqWyWJq+15G
        i1UPwi2aF69ns3iyfhazxaVF7haXd81hs1iw8RFQrmMuowOnx4JNpR6bVnWyeeyfu4bdY/eC
        z0wefVtWMXp83iQXwBaVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
        q+TiE6DrlpkDdJKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8C8QK84Mbe4NC9d
        Ly+1xMrQwMDIFKgwITvj2JaprAUX2CombspsYDzA2sXIySEhYCJxesF3pi5GLg4hgR2MEjen
        LwNKcHDwCghK/N0hDGIKC9hI/L1hB1IuJKAkce1ALwuILSygL7F58TJ2EJtNQFfi74bl7CBj
        RAQmM0lM+LKCCSTBLHCIUWLHZ0aIXbwSM9qfskDY0hLbl2+FimtI/FjWywxhi0rcXP2WHcZ+
        f2w+VI2IROu9s1A1ghIPfu6GiktKLDp0ngnCzpf4u+I6G4RdI7G1oQ0qri9xrWMj2F5eAV+J
        q2vfgcVZBFQl/ny/D1XjIrFw9j8WiJvlJba/ncMM8juzgKbE+l36IKaEgLLEkVtQFXwSHYf/
        ssN8tWPeE6gpahKbN22GhqyMxIXHbVBXekhM2nqPGRKEgRKP+t+yT2BUmIUI51lI9s5C2LuA
        kXkVo1hqQXFuemqxUYEJPGaT83M3MYKTppbHDsbZbz/oHWJk4mAEBjYHs5II76abb5KFeFMS
        K6tSi/Lji0pzUosPMZoCfTyRWUo0OR+YtvNK4g1NLA1MzMwMzY1MDcyVxHmlbU8mCwmkJ5ak
        ZqemFqQWwfQxcXBKNTApx7Bl3Hp33MXZ+mojW/TPk9y2Sd9b676t2q8ntKnl8dTSL2oPD9jZ
        HLmtpVoeftRX9ebsxy4uzx4577j0J2yaece0z0zSHJ9q+54kWdfrLzNunsrU+UDyxz8Xzwn9
        GR9umB+pSuaqWnNFarJB6lfH1e7RRssDHu47dH9rzP+4ib51tpE1px/7S/iJeDx7HitqNbtw
        6qRKn8yjN6Q+nVQ8fOcWH/e6/m9PTrYomB3KitaNiGffdMjyV4lH3KPodxPW9UpPWOHZzZjN
        rfAnaoHH+0T3RXULD2zrOxSdfkO7hU1Sgvnrrkfbl7kuuFZh8crU0z4k0uTPvQPu4f+lFxby
        HL/D+vbJvcBdj+5Y9C1VYinOSDTUYi4qTgQAWdPf8SMEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230215024850epcms2p22be2cc864d82b44f31c19a7ef28770b6
References: <CGME20230215024850epcms2p22be2cc864d82b44f31c19a7ef28770b6@epcms2p3>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
