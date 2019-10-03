Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F77C9F06
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfJCNEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:04:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726677AbfJCNEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 09:04:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x93D418U131047
        for <stable@vger.kernel.org>; Thu, 3 Oct 2019 09:04:04 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vdfcjvswh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 09:04:03 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 3 Oct 2019 14:02:37 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 3 Oct 2019 14:02:35 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x93D25iZ39125454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Oct 2019 13:02:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15ED3A4055;
        Thu,  3 Oct 2019 13:02:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1159A4057;
        Thu,  3 Oct 2019 13:02:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.158.158])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Oct 2019 13:02:32 +0000 (GMT)
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Oct 2019 09:02:32 -0400
In-Reply-To: <20191003114119.GF8933@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
         <1570024819.4999.119.camel@linux.ibm.com>
         <20191003114119.GF8933@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19100313-0020-0000-0000-00000374ADF7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100313-0021-0000-0000-000021CAB7E1
Message-Id: <1570107752.4421.183.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-03_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=781 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910030122
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-10-03 at 14:41 +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 02, 2019 at 10:00:19AM -0400, Mimi Zohar wrote:
> > On Thu, 2019-09-26 at 20:16 +0300, Jarkko Sakkinen wrote:
> > > Only the kernel random pool should be used for generating random numbers.
> > > TPM contributes to that pool among the other sources of entropy. In here it
> > > is not, agreed, absolutely critical because TPM is what is trusted anyway
> > > but in order to remove tpm_get_random() we need to first remove all the
> > > call sites.
> > 
> > At what point during boot is the kernel random pool available?  Does
> > this imply that you're planning on changing trusted keys as well?
> 
> Well trusted keys *must* be changed to use it. It is not a choice
> because using a proprietary random number generator instead of defacto
> one in the kernel can be categorized as a *regression*.

I really don't see how using the TPM random number for TPM trusted
keys would be considered a regression.  That by definition is a
trusted key.  If anything, changing what is currently being done would
be the regression. 

> Also, TEE trusted keys cannot use the TPM option.

That isn't a valid justification for changing the original definition
of trusted keys.  Just as the kernel supports different methods of
implementing the same function on different architectures, trusted
keys will need to support different methods of generating a random
number.   

> 
> If it was not initialized early enough we would need fix that too.

Shouldn't this be determined and fixed, before making any changes?

> 
> I don't think there should be a problem anyway since encrypted keys is
> already using get_random_bytes().

Encrypted keys has no bearing on trusted keys.

Mimi

