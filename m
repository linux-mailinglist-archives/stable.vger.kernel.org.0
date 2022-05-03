Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D5B517F30
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 09:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiECHzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 03:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiECHxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 03:53:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2C9B1;
        Tue,  3 May 2022 00:50:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2430TJqj004092;
        Tue, 3 May 2022 00:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=rMhmyDAWAAQBe/N24LM8za9MtKczC9UpeK3Jvgs3Gsc=;
 b=Y6kbJsVuY4A1HZIad0JCerTR5spbyya6N3GL14AXgAX0+DZQum4Z6rNmqKgs1/+XuktY
 GtNmHwV8jWHLN6IHYjX+6qtkxcTXusp1AKB2U9Vahg89rLjccSjF/Dtw+nlVQpPTEg3n
 5Agjw1CoODs+IFqj+TtVaVkTq/hveb+aRs6lDwt3jpKlq2+MwbgD4y7mDP9VHgPOYmj0
 MnLdyGhepKcBnsrB1WYxZCL4kI3vvPXK+PJkHvGLr7k1cwtwmoU+6L1L/XNH+7T9GuVx
 tmDAPo4WOVwFrAD4CYQfhQ69d+Q9imU0IS8Nd6w9TEYAub/EXfQvorNALPQlxAmCy6T+ Xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op0H008959;
        Tue, 3 May 2022 00:52:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:07 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430plk6010389;
        Tue, 3 May 2022 00:52:06 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-35;
        Tue, 03 May 2022 00:52:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        dc395x@twibble.org, aliakc@web.de, lenehan@twibble.org,
        oliver@neukum.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RESEND][PATCH] scsi: dc395x: fix a missing check on list iterator
Date:   Mon,  2 May 2022 20:51:45 -0400
Message-Id: <165153836363.24053.2716522783006312499.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414040231.2662-1-xiam0nd.tong@gmail.com>
References: <20220414040231.2662-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: a7lEWuHbrGWRMaXgoBhaOwyPP_XH7bL1
X-Proofpoint-ORIG-GUID: a7lEWuHbrGWRMaXgoBhaOwyPP_XH7bL1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022 12:02:31 +0800, Xiaomeng Tong wrote:

> The bug is here:
> 	p->target_id, p->target_lun);
> 
> The list iterator 'p' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will
> lead to a invalid memory access.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: dc395x: fix a missing check on list iterator
      https://git.kernel.org/mkp/scsi/c/036a45aa587a

-- 
Martin K. Petersen	Oracle Linux Engineering
