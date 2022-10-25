Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510CD60D6D5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJYWLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiJYWKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:10:52 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EBF7E02A;
        Tue, 25 Oct 2022 15:10:42 -0700 (PDT)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJrBGj012770;
        Tue, 25 Oct 2022 15:10:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=S8UF+y2dG6/wURTPTXgwrrBYg7Lqd5JHnasGpD4g2e0=;
 b=naHKmy2ukc8lJG3+aVcQ6KIPWTueGH7FyxEFHlQeLPvaNbvFrN9v7blgPoMT08ZMIWHO
 nbJEfOoA5gaL95RdylSyb2V5UJccgsi9WwFALLAGboEaGhN4Y2fe6tQnI30VVawnNXu4
 F1XxXDWFalowPB2aT15hrd4DpPon2fkv56hQ0zQ2DWKRjJMu1vv2hiMT1Xpb5fx9DfOA
 KwccGJiGgZlyyJ9iynGBw+jTkGWqcNZh0AmD9AthZ6Y3F/JH18UvR7gLLLKa1jPqJPH9
 9VTvNb5es/HvVKHEVPKQ7BRptNoMAXbPEFAb3PweiHlSukJQkcB/1q+6jAeLQruffblS kw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3kcf5ghgu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 15:10:20 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3F083C00F4;
        Tue, 25 Oct 2022 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666735809; bh=oUhAsTY2PNLxusBy5n8Y+casDHu2j/hvbyHycZDciwA=;
        h=Date:From:Subject:To:Cc:From;
        b=RnkkJ8tV+XAb4cJTHVawiYINshyeYk+CyCYQAApoh5uwXIYpmLAAKj6R+t8FEPn4q
         moMGw+1ETBDuT7jCs2Kx5tZvbSAI9taBO6VxA9RvWznELtW4yMk0Ukj6VN70G3ULG5
         YHTrNkSIznnMBzenYqkShxeaTZPg9ZOyCbmhgI8qFNhzNVpuS/1x5tQ2nHEj9BKJbn
         HegI5+iqD4T5e4a7OegjUVo6JI3tMWU9aOdMzv45ogDPeUmqfwZYUjv4cRH/ZZgTGA
         qg2gLU92YZ/2lYQVEfho+QNIJS/84WV8ITFG/7kW9VovvU/OZ3LuuAKWE6eFZ88Wtn
         4BusFPxBDQDCg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id AC7E4A0073;
        Tue, 25 Oct 2022 22:10:07 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 25 Oct 2022 15:10:03 -0700
Date:   Tue, 25 Oct 2022 15:10:03 -0700
Message-Id: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v3 0/2] usb: dwc3: gadget: Fix isoc interrupt check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-ORIG-GUID: E6Ft5FdkWxH0qY00GuCIrYBS20wy75vM
X-Proofpoint-GUID: E6Ft5FdkWxH0qY00GuCIrYBS20wy75vM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=554 lowpriorityscore=0 phishscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250123
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

Changes in v3:
* Only set IMI to the last TRB of the chained TRBs

Changes in v2:
* Fix missing cover letter subject
* No need to check for the last chained TRB

base-commit: fb8f60dd1b67520e0e0d7978ef17d015690acfc1
-- 
2.28.0

