Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE067B36B
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 14:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbjAYNfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 08:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbjAYNfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 08:35:01 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443CE4E507;
        Wed, 25 Jan 2023 05:35:00 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PBgBMZ000380;
        Wed, 25 Jan 2023 05:34:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=PPS06212021;
 bh=si9MHYmYyyypVqunUvDViGG9IbErTs+07obEE+u6Bao=;
 b=GZmV7nEnyRqiKJ3+KU45EGGJ2Ip8mrg/TKogyPQrJVI459MDpOa4ehjr68X1uHNPl6YE
 ia426/G6lZkIz7oJiQCZBc/OPvkJXsGoW4wm0JNdj4pC65hxsBuh0KrL/PVQgqdV1tFq
 6n/OBSxhV5nP1QJCD+XWpvL7xK9h7NJrYvgeHqdCCA1Ok3K/QSnmIEjaTyVu8vfYMfIg
 rKh2p/L4k8frTK41dvalZJB6Pxno8sr2pryxKXd8AD7Sr5yyyUcgUmZrl0CMwhWW/wgs
 dvzeV7DXnjAgZoSKlIp9oi06t1HtSIOSyyM5q5Wl9j7TBGGOEM52uh+fwF9+WxPbTuAQ 1Q== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3n8c78m7ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Jan 2023 05:34:57 -0800
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 25 Jan 2023 05:34:57 -0800
Received: from otp-azaharia-d1.corp.ad.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.17 via Frontend Transport; Wed, 25 Jan 2023 05:34:56 -0800
From:   Adrian Zaharia <adrian.zaharia@windriver.com>
To:     <stable@vger.kernel.org>
CC:     <mathias.nyman@intel.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.10 0/1] backport of 'xhci: Set HCD flag to defer primary roothub registration'
Date:   Wed, 25 Jan 2023 15:33:58 +0200
Message-ID: <20230125133359.3538078-1-adrian.zaharia@windriver.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: HXX7LIoZunn8mP9sOD0G-8kKUpKMMPaj
X-Proofpoint-ORIG-GUID: HXX7LIoZunn8mP9sOD0G-8kKUpKMMPaj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_08,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=878 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Zaharia <Adrian.Zaharia@windriver.com>

This patch enables the flag to defer registering primary roothub if xhci has two roothubs.
Link to upstream patch:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?id=b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054

The support for deferring roothub registration was added in 5.10.121.
(See: a2532c441705 "usb: core: hcd: Add support for deferring roothub registration")


Kishon Vijay Abraham I (1):
  xhci: Set HCD flag to defer primary roothub registration

 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 179624a57b78c02de833370b7bdf0b0f4a27ca31
-- 
2.39.1

