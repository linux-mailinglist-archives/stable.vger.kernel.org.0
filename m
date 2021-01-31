Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC3309C79
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhAaNx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 08:53:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10460 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231229AbhAaMrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 07:47:12 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10VCVg2v161361;
        Sun, 31 Jan 2021 07:45:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=caNp9fVibXfw5qV+NBAx2uXXdduQ7qxj7hvOlb920qk=;
 b=CYUcyujpanXd42xB4jNLxOdmm46DGXPfOtMLlcuUGcBukrSBKpjKZzWUgxXJy93zFbVE
 4s2H/OFPl7wnXNE6WVuzT6lztnxM0A8bZSKtCg8dVL831TPTAaQYmwgowprivo1F+/II
 hypiuC3OxzfYBflq86KojtMftoftI5Q2pT9KY4jaMWHGEfw2pZ0XgHdSm9POHTh7pW2P
 4AklHCHKfnIILPLLH3oUnW+Tug0VBeMP8lEsVhlJjHwltOGE/2jcemnt4FXPHV+1hwvX
 uFpysuH4r9wCKgEs2yq97cfpM9o5qFIod8cX75v3JnO4RaUOQ7EpyWKT43SWYPO6iq7k vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36duhth047-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:45:49 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10VCeiCE184897;
        Sun, 31 Jan 2021 07:45:49 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36duhth03d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:45:48 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10VCbAfG004004;
        Sun, 31 Jan 2021 12:45:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 36cy38h074-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 12:45:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10VCja7x33751518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Jan 2021 12:45:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E017C42041;
        Sun, 31 Jan 2021 12:45:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A38D4203F;
        Sun, 31 Jan 2021 12:45:42 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.28.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 31 Jan 2021 12:45:42 +0000 (GMT)
Message-ID: <aac6952a639f85176e84d2e8b2c504069b093847.camel@linux.ibm.com>
Subject: Re: [PATCH v5 1/3] KEYS: trusted: Fix incorrect handling of
 tpm_get_random()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     jarkko@kernel.org, linux-integrity@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date:   Sun, 31 Jan 2021 07:45:41 -0500
In-Reply-To: <20210128235621.127925-2-jarkko@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
         <20210128235621.127925-2-jarkko@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 mlxlogscore=952 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101310065
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-01-29 at 01:56 +0200, jarkko@kernel.org wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> When tpm_get_random() was introduced, it defined the following API for the
> return value:
> 
> 1. A positive value tells how many bytes of random data was generated.
> 2. A negative value on error.
> 
> However, in the call sites the API was used incorrectly, i.e. as it would
> only return negative values and otherwise zero. Returning he positive read
> counts to the user space does not make any possible sense.
> 
> Fix this by returning -EIO when tpm_get_random() returns a positive value.
> 
> Fixes: 41ab999c80f1 ("tpm: Move tpm_get_random api into the TPM device driver")
> Cc: stable@vger.kernel.org
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

thanks,

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

