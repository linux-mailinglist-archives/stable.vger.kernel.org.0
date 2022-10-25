Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9D60C147
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiJYBoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiJYBno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:43:44 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3AB58DEC;
        Mon, 24 Oct 2022 18:28:04 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNlAK031812;
        Mon, 24 Oct 2022 18:27:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=h0qyDvIpYCN6j4GB3/O/UoMcuzvsRYm1PQSGGJT5QNU=;
 b=OYHADP1os4ahEgviH6T+6uvVeOEYb9IY6/abce7GXnoH4qY6I6dEGDZ21Do05mN8yJm7
 c67Y1AtGOytvEwQpOZB6XKn/tQNJaDmge4tzzmOQof+A5lDgTMWu9XNkao3aliKWjqZE
 vqwkWiwSPqnjv2lwOkOkhlMc158729OK+rzuW1bMlsETL2+e4ZGqpBx98edoAZTwIId1
 H/g9oQy4FTajecLSkyIto0wp0piIZBWknlwhXyv/j7oCWPvdhUUyEtus2+zdmXHx88Ox
 yeGTSTJx9grYa0zzcCqSHIsdz6oNjIq1j3Q6T3yjBEYCVmx4N+tv+R23MFryghtntAtV iA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfevum1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 18:27:54 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 17FA9C0108;
        Tue, 25 Oct 2022 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666661273; bh=Yp7O0hdO+tsJ/CofUJRGVeylUPMGC1EhMgg3QSNxDo0=;
        h=Date:From:Subject:To:Cc:From;
        b=Fk/lZyXbWkz483MrN5mTIBes3KkABNF+kpl1pOkVClpIDNkU9B+z5QedRFr4sfjE1
         BGKE+5lG+MC+gaQelzcEM1dlEdY+ateeS2+uWlhfCUy98N6eOGbZHGJoJ3RP20ohHT
         NdeFb3o8nLTxcP/KyMDkFjUqkbyp77RwZEIBA2/JkcVvB3XMVcKeYXFX6EVcsYWZC2
         eJcL/6alPtEMKJ1rL9vopKr0Io+NK7iLmM0Y721FuXXTun2WavECPMQEx/QI6uQ2x+
         olN/iQ2bQO8a63s58Vcpjr4VSGl8ehB+MzRYUUGKFasK2QTWNe0Oq8LlL2zwm0XNZe
         DDJGK9MA8YmHg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 75A13A005F;
        Tue, 25 Oct 2022 01:27:51 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 18:27:51 -0700
Date:   Mon, 24 Oct 2022 18:27:51 -0700
Message-Id: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 0/2] usb: dwc3: gadget: Fix isoc interrupt check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-ORIG-GUID: 2RyPTji8x9sAU6QUW2f7BbGSfHNIXXVi
X-Proofpoint-GUID: 2RyPTji8x9sAU6QUW2f7BbGSfHNIXXVi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_09,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=553 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250006
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix issues where usb_request->no_interrupt is set for isoc transfers.
* Make sure no interrupt is asserted if no_interrupt is set
* Make sure to stop reclaiming TRBs when the driver needs to stop


Thinh Nguyen (2):
  usb: dwc3: gadget: Stop processing more requests on IMI
  usb: dwc3: gadget: Don't set IMI for no_interrupt

 drivers/usb/dwc3/gadget.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Changes in v2:
* Fix missing cover letter subject
* No need to check for the last chained TRB


base-commit: fb8f60dd1b67520e0e0d7978ef17d015690acfc1
-- 
2.28.0

