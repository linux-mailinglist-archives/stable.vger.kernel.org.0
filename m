Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA705E9A46
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 09:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiIZHMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 03:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiIZHLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 03:11:55 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83801C4;
        Mon, 26 Sep 2022 00:11:54 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q6Vfwa010980;
        Mon, 26 Sep 2022 07:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PPS06212021;
 bh=6IO8yKObUb8h/DQe8qLUFtYT5EB+6cRHHP/lDJvXTG0=;
 b=JWLzD4Z6gmstUWDgFP1GdPo3lu+MR4TtSf+f6NyfVIeJi26ws5eIl3iQAPXP/sXVpoBH
 JTwxlMfdMHV1suFlwFlMfRJD5mZsc3SteaHz5Xt4z04JKKloofhuyFOp5mR1N2dNc+jM
 mOWcStXvhXigZfzXNuxfsSFr3qA5nxQ/7FZrkTpBGk5emT1pQMqNTSCJ3FMHnXlFEYz0
 De7EPZSdhJQ4npHpHVML7atGf/96YZ6KvQ8pHEz+GijAQPUs38VVUQTfe1qkleXsmTD0
 zvNHKff1U83V2x6ZObwd1TOKjhzL8pOLHCvH6YuAVp9LoupBv8kBoO3UmzKVSKY2vpKD 7A== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jsrv9hbn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Sep 2022 07:11:40 +0000
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.191) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 26 Sep 2022 00:11:37 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] media: em28xx: initialize refcount before kref_get
Date:   Mon, 26 Sep 2022 10:11:28 +0300
Message-ID: <20220926071128.140602-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926071128.140602-1-dragos.panait@windriver.com>
References: <20220926071128.140602-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [128.224.125.191]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Proofpoint-GUID: usxUhGk9D93DUEIiAl5Jyfj_REeMWq2S
X-Proofpoint-ORIG-GUID: usxUhGk9D93DUEIiAl5Jyfj_REeMWq2S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=879
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c08eadca1bdfa099e20a32f8fa4b52b2f672236d ]

The commit 47677e51e2a4("[media] em28xx: Only deallocate struct
em28xx after finishing all extensions") adds kref_get to many init
functions (e.g., em28xx_audio_init). However, kref_init is called too
late in em28xx_usb_probe, since em28xx_init_dev before will invoke
those init functions and call kref_get function. Then refcount bug
occurs in my local syzkaller instance.

Fix it by moving kref_init before em28xx_init_dev. This issue occurs
not only in dev but also dev->dev_next.

Fixes: 47677e51e2a4 ("[media] em28xx: Only deallocate struct em28xx after finishing all extensions")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[DP: drop changes related to dev->dev_next as second tuner functionality was added in 4.16]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b736c027a0bd..23a9fe8d9d1e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3644,6 +3644,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err_free;
 	}
 
+	kref_init(&dev->ref);
+
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -3730,8 +3732,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
-	kref_init(&dev->ref);
-
 	request_modules(dev);
 
 	/*
-- 
2.37.3

