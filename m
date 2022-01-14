Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A7F48E24B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 02:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiANBxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 20:53:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53170 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbiANBxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 20:53:15 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E1pbJZ006919;
        Fri, 14 Jan 2022 01:53:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=JcIci3AxnUW4yvMJHng9Li4Rw+AsTCwVPvc5ny10ma4=;
 b=j7PTJPEAUUFvDyVz3EWJScaPeAbWTgjN0UpVeEwo9PQBQZh+Wslf34zDi5K0v0EuygDZ
 ZZmragRWVBUzjkluIpH7hU4NgnW6qnvh5KwKzWo9LjL1Y7cs3Iy6GVF51YF2GanGI7cV
 JYrMSkMpTI+0so7iGsgECtWRJImlwR8DjuF0fAdNB5ahs2t+0za2d9LigfZFEzJRIATk
 3w/sGuiS1SbLy7QQNsh7Mvm3gs6sPHD4QkvGr4RBYspAC97fPUqN4m5MEMT5CdCyW9L1
 /XeWZAkgCXNThbi0WUfpcKaP2363nZad0vACgZcpcEG4zAGwIHP6tMDV0KMtlHur/XCI Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djyvr80n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 01:53:06 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20E1pa54006783;
        Fri, 14 Jan 2022 01:53:05 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djyvr80mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 01:53:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E1lVpR024026;
        Fri, 14 Jan 2022 01:53:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3df28a7rnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 01:53:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20E1r1cH38732274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 01:53:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6898211C058;
        Fri, 14 Jan 2022 01:53:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BC111C05E;
        Fri, 14 Jan 2022 01:53:00 +0000 (GMT)
Received: from sig-9-65-76-253.ibm.com (unknown [9.65.76.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 01:52:59 +0000 (GMT)
Message-ID: <55c5576db2bb0f8a2b9d509f4d1160911388fa41.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: fix reference leak in asymmetric_verify()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-integrity@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Date:   Thu, 13 Jan 2022 20:52:59 -0500
In-Reply-To: <20220113194438.69202-1-ebiggers@kernel.org>
References: <20220113194438.69202-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WgYj4asX8fmvzEP5hTnXD2QokhNzji6-
X-Proofpoint-GUID: afQ1f_8IqhHu0nCkg1aclmYtO7gg4L2y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_10,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=769 clxscore=1011
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140007
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On Thu, 2022-01-13 at 11:44 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Don't leak a reference to the key if its algorithm is unknown.
> 
> Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
> Cc: <stable@vger.kernel.org> # v5.13+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

thanks,

Mimi

