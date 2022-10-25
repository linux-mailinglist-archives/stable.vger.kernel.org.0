Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9121960C068
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJYBF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJYBEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:04:44 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FBC4B9AC;
        Mon, 24 Oct 2022 17:07:52 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNkN5020921;
        Mon, 24 Oct 2022 17:07:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 from : subject : to : cc; s=pfptdkimsnps;
 bh=4neXYTo8GuuyOsW3meUrGjKmzCGXBG6LJT3MvC0gBhQ=;
 b=MaXSHeFQpNKUxCjzGiRYSAp4WARZEWo2mc7vhLygifuZI5lOrCD8vQYyJJ1Dk2svXA6P
 e6ZylILF45WtEZblWFlZjiSOWdiOMHyggmLT8ocvwui3vBi7moTBq5YRDzN3x5D8PQZU
 R1H9S92R2IZktxwsN8FEGzFE66f8or3KXXP0p2FlAss7wad7IGEfFabU79/0/3Try9RX
 /cKJ2QsHUkHu1wKsFEHh4847f3z1svwFU91tTKzPLJkBVdtT0ck1vd6ghaC5GvyT4VDs
 OXyT3wkoVCJkD4yemrppOlYhQZnsgRt5wy24Pk7tjkeqVsfRATS5u06PbGvUxNEvYRyv 4Q== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfhp3ckt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 17:07:37 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4155FC0108;
        Tue, 25 Oct 2022 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666656457; bh=P2g67vxCFm9dsYCe4B4NukVScIEmyjwQIXex3BuTdmA=;
        h=Date:From:Subject:To:Cc:From;
        b=Kq0AuUsjxkFMRD4VyzXoWzeT9O6jcJ9baElQGAVtV1GCx/Ls4FLJv4fFcQC47d/wO
         CmrKsX1Orr4h8l76T/K/bTTOUreM0GmIA6mUX0hiXuPZ3A6gw5Y+Tzc8mG7UUQckJG
         UBKErrKi5GCnGIasdmhCohgBcbWUttMhzv+30OeWVhUWIqNfabE+QCPXVO02ezQ+B9
         tvLr28TbzvyDXB7YbiXrGLoG/qJ3ezJYe+mjL1wAKf9wmg6PABX2anKYBqdG2ClyZp
         vpSMPXu29a0iFF9okCgkQzYidHJrRFoclrNU25ZlG4+vWtwQ2enr98xoCkoNrgTHzz
         FkpRakJdwwoEA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id D60ECA00A9;
        Tue, 25 Oct 2022 00:07:35 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 17:07:35 -0700
Date:   Mon, 24 Oct 2022 17:07:35 -0700
Message-Id: <cover.1666654589.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/2] 
usb:    dwc3: gadget: Fix isoc interrupt check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-GUID: HnS8k2W7jsUkYvvHGyBsu3p8H6TijxGN
X-Proofpoint-ORIG-GUID: HnS8k2W7jsUkYvvHGyBsu3p8H6TijxGN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_08,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=556 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240144
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix reported issues where usb_request->no_interrupt is set for isoc
transfers.

* Make sure no interrupt is asserted if no_interrupt is set
* Make sure to stop reclaiming TRBs when the driver needs to stop

Just one of the fixes above may resolve the crash reported by Jeff and
Dan, but it's more proper to have both in place.


Thinh Nguyen (2):
  usb: dwc3: gadget: Stop processing more requests on IMI
  usb: dwc3: gadget: Don't set IMI for no_interrupt

 drivers/usb/dwc3/gadget.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


base-commit: fb8f60dd1b67520e0e0d7978ef17d015690acfc1
-- 
2.28.0

