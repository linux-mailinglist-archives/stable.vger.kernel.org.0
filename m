Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6D672D55
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 01:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjASAVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 19:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjASAVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 19:21:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEF654B16;
        Wed, 18 Jan 2023 16:21:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmh5c016456;
        Thu, 19 Jan 2023 00:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ZCP7XGu9FCxlendnB63ykyjoX0wHLW17+xYQa8RFbYQ=;
 b=jQWFZ49qYY4gwBzL7XrHo66L/4CFKyf1bMYGy1evL809xfG+5BpE3VOAk9+OxpyydU2Y
 hZbFNTssABxKfPIgF6tiguMSEbHFPAmAr8QY11wcDM563qSocgmhptlkwVCuQC1iAdXe
 hRErlWRtxv2AFimRByZmvaiPGJsqr20cdlcRMp1Dg9PBOzV85t+IEgsFE/OBBINujGWE
 hJlmdQubTxMuQPx0XWHdhmVs7YoNy0zMv9NsSfoyckKBntB8DMUMieMXZnoXIwte2G4a
 dYsdzzkDG2UAaYn4zuy2VtbunJTZh07Bqztz5DP8QFB6d0TxH3nuA+cceT5SkroIIew4 +g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaah1tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:21:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30INqADL030692;
        Thu, 19 Jan 2023 00:21:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6quaxw7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:21:36 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30J0LYP0007137;
        Thu, 19 Jan 2023 00:21:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3n6quaxw6c-2;
        Thu, 19 Jan 2023 00:21:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Johan Hovold <johan+linaro@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Can Guo <quic_cang@quicinc.com>,
        Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH v2] scsi: ufs: core: fix devfreq deadlocks
Date:   Wed, 18 Jan 2023 19:21:28 -0500
Message-Id: <167408762166.3511288.15577656498672472733.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230116161201.16923-1-johan+linaro@kernel.org>
References: <20230116161201.16923-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=814 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190000
X-Proofpoint-GUID: AFlohegXLb34xo_IVga-FgwsFxmMtIJa
X-Proofpoint-ORIG-GUID: AFlohegXLb34xo_IVga-FgwsFxmMtIJa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 Jan 2023 17:12:01 +0100, Johan Hovold wrote:

> There is a lock inversion and rwsem read-lock recursion in the devfreq
> target callback which can lead to deadlocks.
> 
> Specifically, ufshcd_devfreq_scale() already holds a clk_scaling_lock
> read lock when toggling the write booster, which involves taking the
> dev_cmd mutex before taking another clk_scaling_lock read lock.
> 
> [...]

Applied to 6.2/scsi-fixes, thanks!

[1/1] scsi: ufs: core: fix devfreq deadlocks
      https://git.kernel.org/mkp/scsi/c/ba81043753ff

-- 
Martin K. Petersen	Oracle Linux Engineering
