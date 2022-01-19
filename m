Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6182C4931E3
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbiASA20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:28:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53138 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237177AbiASA2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:28:25 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INRrEm011450;
        Wed, 19 Jan 2022 00:28:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0s3EPiTBBJVqZJT2McfkGgt7LnKRIJ6MavHK+e9cY5g=;
 b=CnFTON8KYNfeuWtaNcHIOXapRqHfFvptL2miNnJBXebNxtFRLPs6jFSX5tLe5gglHGxg
 j/UIiUFvijYZ3lH5Xdi8Hm2KVN4+6wYeyH6+vkLY87V8nQexbqrko/n8KOzeKeI6bCsC
 QrLysnErSXPjBBiAODUPo+7WCRSiZfxv+XuhdTus9/g8h7LnYQ0ogo4maBhUvX+9B9nj
 NMFuvAeh9RzojwW2RRzaAk0lXdhKiOFW0qn7JxFxdnoJVdOumEWyt9fNk57pTZu2hYfx
 ZG7UuWl92nu9PQH+ahUyFoPQoD8wuHLfuwpdnvozzjKaAPZ67XtYcFPBvKLYhzvt1o06 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp78dgru1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 00:28:17 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20J0DFNU017809;
        Wed, 19 Jan 2022 00:28:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp78dgrtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 00:28:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20J0IA0v007720;
        Wed, 19 Jan 2022 00:28:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw9f7v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 00:28:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20J0SCRr44106078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 00:28:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45FC852054;
        Wed, 19 Jan 2022 00:28:12 +0000 (GMT)
Received: from sig-9-65-88-194.ibm.com (unknown [9.65.88.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DAB6B5204F;
        Wed, 19 Jan 2022 00:28:10 +0000 (GMT)
Message-ID: <c349477264b23b401d6142d686b61b401a52c542.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: fix reference leak in asymmetric_verify()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Date:   Tue, 18 Jan 2022 19:28:10 -0500
In-Reply-To: <YedY1BCKSKXn2Dcc@sol.localdomain>
References: <20220113194438.69202-1-ebiggers@kernel.org>
         <55c5576db2bb0f8a2b9d509f4d1160911388fa41.camel@linux.ibm.com>
         <YedY1BCKSKXn2Dcc@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ldYC7ke2Tse4QaFML4mY9Fy1tvxIJqL4
X-Proofpoint-ORIG-GUID: e9QuXZGyKkJz8r_4K8TjScVx_7rvzUDF
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_06,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxlogscore=788 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180132
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-18 at 16:18 -0800, Eric Biggers wrote:
> On Thu, Jan 13, 2022 at 08:52:59PM -0500, Mimi Zohar wrote:
> > Hi Eric,
> > 
> > On Thu, 2022-01-13 at 11:44 -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Don't leak a reference to the key if its algorithm is unknown.
> > > 
> > > Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
> > > Cc: <stable@vger.kernel.org> # v5.13+
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> > 
> 
> Thanks.  You're intending to apply this patch, right?  Or are you expecting
> someone else to?  get_maintainer.pl didn't associate this file with IMA, but I
> see you sent out a patch to fix that
> (https://lore.kernel.org/linux-integrity/20220117230229.16475-1-zohar@linux.ibm.com/T/#u).

Once the open window closes, I'll apply it.

Mimi

