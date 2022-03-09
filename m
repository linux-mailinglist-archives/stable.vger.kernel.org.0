Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA34D27E3
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiCIEPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 23:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiCIEPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 23:15:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388543B3D0;
        Tue,  8 Mar 2022 20:14:15 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229480BL003070;
        Wed, 9 Mar 2022 04:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=7YDEF59Ps/3e/eVNU2IpEWgxBT/6xGZCkQEgD3W7T5k=;
 b=F5SKtdMFsCuP9jMACUvYg0mSZFMRQEaHeNIuLPorjwvjMfrUj0aWq3foLdNqqihXBVAc
 FNGdtsFAwwAGTYnrtFp09rgBLHuR7NNgRV2yep4lOM/Sx6/aRKTU0AXps+jsyavvzFzP
 v6zyzehFGTnFT36uohEOZZqPpkmVL9KZ+Term4c6TABkbItm6/LBXFMoThKY0Px32+Iy
 Gb7pR/cUcjZ0ZOCWTg7pbIoLDroN4lFvZOUWtS/cFRTDbJ/aN+lKK9Gon+onzuKkVT88
 WJmHnADip2k6gWeOS8clibNsh82CEkLdH2t9PK59n0285qn917fMigZnz+pahx9xdFtd 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du0xmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22947k11167717;
        Wed, 9 Mar 2022 04:14:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qdea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:12 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294EAeJ174884;
        Wed, 9 Mar 2022 04:14:11 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddd-3;
        Wed, 09 Mar 2022 04:14:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH][REPOST] scsi_transport_fc: Fix FPIN Link Integrity statistics counters
Date:   Tue,  8 Mar 2022 23:14:07 -0500
Message-Id: <164679903742.29335.9465242397242242999.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301175536.60250-1-jsmart2021@gmail.com>
References: <20220301175536.60250-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mrC2NkL4mCOEY4Lbe7QHXMzHmT81wpdG
X-Proofpoint-GUID: mrC2NkL4mCOEY4Lbe7QHXMzHmT81wpdG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Mar 2022 09:55:36 -0800, James Smart wrote:

> In the original FPIN commit, stats were incremented by the event_count.
> Event_count is the minimum # of events that must occur before an FPIN is
> sent. Thus, its not the actual number of events, and could be
> significantly off (too low) as it doesn't reflect anything not reported.
> Rather than attempt to count events, have the statistic count how many
> FPINS cross the threshold and were reported.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi_transport_fc: Fix FPIN Link Integrity statistics counters
      https://git.kernel.org/mkp/scsi/c/07e0984b96ec

-- 
Martin K. Petersen	Oracle Linux Engineering
