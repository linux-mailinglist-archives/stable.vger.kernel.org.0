Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201E75E9A3E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 09:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiIZHLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 03:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiIZHLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 03:11:51 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84192DE;
        Mon, 26 Sep 2022 00:11:48 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q6wV0V018618;
        Mon, 26 Sep 2022 00:11:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=PPS06212021;
 bh=HxIXDvQYV7g+JGKukY2F8QyzdmmDOEIXoTB22E8vWeA=;
 b=UBIyULg56i6oIyyyNVSlVJsADd9TqTzILOGJqchWsKSLyhaJTNl291ZvX/9gorm+T/nw
 9S846TNaWqTF9HTNAcpHp5dNLvLIquMbme41SkXOdC78d+UteUThASHYk7rSgPXk6i6c
 KcRZ+Wbh7AX+33UZ6UEJYjb+aZ+EEUThbJxo4mkGA89BH7T0ImdCX1ksyqN+dlPiSZEg
 q8UMdNxg0LQLOehmIB26oveRJVmv3voYrANOC+G1hAv+ZvJs+l95uMknLlxi6ZsTr1UF
 Za/6ILmS/kWEPrJ4EorTiWEBliI6BsodiBtIMNY6ZEW0mBwSY9JkaMCn1pRJD9TNtkRi WQ== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jt1dk92y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Sep 2022 00:11:37 -0700
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.191) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 26 Sep 2022 00:11:35 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.14 0/1] media: em28xx: initialize refcount before kref_get
Date:   Mon, 26 Sep 2022 10:11:27 +0300
Message-ID: <20220926071128.140602-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [128.224.125.191]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Proofpoint-GUID: fCB-qWimRdFBttev2aAOi9A6wZzVgzWs
X-Proofpoint-ORIG-GUID: fCB-qWimRdFBttev2aAOi9A6wZzVgzWs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=250 adultscore=0 bulkscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit is needed to fix CVE-2022-3239:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c08eadca1bdfa099e20a32f8fa4b52b2f672236d

Dongliang Mu (1):
  media: em28xx: initialize refcount before kref_get

 drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 4edbf74132a4c9b78dc2ee61d31abef15200a781
-- 
2.37.3

