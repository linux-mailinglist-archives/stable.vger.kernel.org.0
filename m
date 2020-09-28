Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0527AB7E
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 12:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgI1KGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 06:06:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46529 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1KGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 06:06:15 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 06:06:14 EDT
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200928095911epoutp0460c3d4de38299f12bf8a780f98d2d846~46i4r_QvL0671806718epoutp04K
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 09:59:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200928095911epoutp0460c3d4de38299f12bf8a780f98d2d846~46i4r_QvL0671806718epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601287151;
        bh=7CR1Q+w5UwrJWvWo06WVPDp3EKcGOprW0unA4PHUABI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZvzcNe5j5S9NUEY0p/jQs9Ubii+0Jc1MJTC5pZn9ehCMbr7W9yAdNx5meCJIYVXgO
         HyCv4gw5p5iVyMOfaUfl8tk8NOKUz2+TXzYiNqoqeMMcO7PtyApKn9zDbBlWjkZWEd
         0EhVmwz8Ho6XZZOjuqbUN/YwU5yAQaLqggm7+RDw=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200928095910epcas5p2536ac825e94c9077f6bf44547cbe9b0f~46i3wNMUy1495314953epcas5p2H;
        Mon, 28 Sep 2020 09:59:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.A3.09567.EE3B17F5; Mon, 28 Sep 2020 18:59:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40~46i3TLXdB0538805388epcas5p2C;
        Mon, 28 Sep 2020 09:59:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200928095910epsmtrp1ec95267cea49113bef3795531d002f5c~46i3SZHiS0567205672epsmtrp18;
        Mon, 28 Sep 2020 09:59:10 +0000 (GMT)
X-AuditID: b6c32a4b-2f3ff7000000255f-f5-5f71b3ee0e16
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.C9.08745.DE3B17F5; Mon, 28 Sep 2020 18:59:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200928095908epsmtip1e0fa257b18eee2bb7bfb336c7c411dcd~46i1wNoqN2783827838epsmtip1k;
        Mon, 28 Sep 2020 09:59:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, Damien.LeMoal@wdc.com
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 0/1] concurrency handling for zoned null-blk
Date:   Mon, 28 Sep 2020 15:25:48 +0530
Message-Id: <20200928095549.184510-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42LZdlhTU/fd5sJ4g4NPJS1W3+1ns2ht/8Zk
        8fjOZ3aLo//fslnsvaVtcXnXHDaLbb/nM1tcmbKI2eL1j5NsFgs2PmJ04PK4fLbUo2/LKkaP
        z5vkPNoPdDMFsERx2aSk5mSWpRbp2yVwZUzftZq5YBtTxdVGpwbGL4xdjJwcEgImEj273rN3
        MXJxCAnsZpR4cfEME0hCSOATo8SMhwEQ9mdGieVHk2EaVr1bzwLRsItR4uqGN4xwRZ9fAxVx
        cLAJaEpcmFwKEhYR0JJYurWRDaSeWeAEo8TP0xtZQRLCAvYS/TuesYHYLAKqEjNPbWEF6eUV
        sJRY8s0FYpe8xMxL39lBbF4BQYmTM5+wgNjMQPHmrbOZQWZKCNxil9hw/B0rRIOLxO/mW1C2
        sMSr41vYIWwpiZf9bVB2scSvO0ehmjsYJa43zGSBSNhLXNzzlwnkCGagB9bv0odYxifR+/sJ
        WFhCgFeio00IolpR4t6kp1CrxCUezlgCZXtIbHt0gBUSJLESLyZtZp/AKDcLyQuzkLwwC2HZ
        AkbmVYySqQXFuempxaYFxnmp5XrFibnFpXnpesn5uZsYwYlEy3sH46MHH/QOMTJxMB5ilOBg
        VhLh9c0piBfiTUmsrEotyo8vKs1JLT7EKM3BoiTOq/TjTJyQQHpiSWp2ampBahFMlomDU6qB
        afexf7Y3XnZc3q5s6769fObF67KtPmbm5/6tsPHSFa35tOzya7vf647I+7YeUVywP3Rm9tmI
        qn2RZxWZ7ynans02bvEIeiSut+9Yzb19F+6X+7+/H/RPY1PQyykt2lFLudSifqcrdaUoFT2N
        lOx6zVt8rd/DuGxBa7CT4MbQ3Kl3763SnF/pxPel+/GhuGc6iuoTNn//b/Jmrbzvlcjctol/
        rjx7LjTvakzRrUMnszkFV63Z+vyB2/xP11Su3RflfVqQvjGbbe+EZ7v3b8xIPKii4TTjma/o
        gr5td1bPWba95fHJme3RnofOmoQw//mX2KHv5rv4ownzlU2TPrc/jy/LqZk3p7HZ9+4nXZ0I
        Wz4lluKMREMt5qLiRADgKbPTkwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnO7bzYXxBp3TzC1W3+1ns2ht/8Zk
        8fjOZ3aLo//fslnsvaVtcXnXHDaLbb/nM1tcmbKI2eL1j5NsFgs2PmJ04PK4fLbUo2/LKkaP
        z5vkPNoPdDMFsERx2aSk5mSWpRbp2yVwZUzftZq5YBtTxdVGpwbGL4xdjJwcEgImEqverWfp
        YuTiEBLYwSixqWUrC0RCXKL52g92CFtYYuW/5+wQRR8ZJXb9vwvUzcHBJqApcWFyKUiNiICO
        xL6PbWCDmAUuMEosu/KdFSQhLGAv0b/jGRuIzSKgKjHz1BZWkF5eAUuJJd9cIObLS8y89B1s
        F6+AoMTJmU/AbmAGijdvnc08gZFvFpLULCSpBYxMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS
        9ZLzczcxgkNWS2sH455VH/QOMTJxMB5ilOBgVhLh9c0piBfiTUmsrEotyo8vKs1JLT7EKM3B
        oiTO+3XWwjghgfTEktTs1NSC1CKYLBMHp1QDk93s6UumHFbzYrlnLX/5JcuiN7Pvr2ETKv/M
        plc4Vfu+jf9smb2Cbzk7koQvpmf53GwUNFT0i36s2aIndtSsbXWPzfwP9465Vt0xfjfhluSO
        ybvPyjy3M74huC2so8MstEo/lZt3P0+t2/lIofroU0X7Qqzij84VcTQM1zaO+sqtWPZcfcrT
        s/9f1DwTmaWcsTS3YWvLHT195iSmJVWvPCa6autFG9YfbWZcoGyk23Nn5TTN2ZO26CSsmjxP
        Zn3U3KCljysl3CtMW9W3rOqI+/5zRvia1OkhvzRWb5JtKT2hEnIjfomdTONlybJ+XYXjlSXF
        TX2T+TjvXJzZc0guyG9dkIPThhebzwqdCXVTYinOSDTUYi4qTgQAUUP7jcgCAAA=
X-CMS-MailID: 20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40
References: <CGME20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v1:
- applied the refactoring suggested by Damien

Kanchan Joshi (1):
  null_blk: synchronization fix for zoned device

 drivers/block/null_blk.h       |  1 +
 drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.25.1

