Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F524309DA7
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 16:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhAaPhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 10:37:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232246AbhAaM6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 07:58:07 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10VCZG2a153086;
        Sun, 31 Jan 2021 07:52:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Q1TSA2RQ0NpJwZDrH5UamqkQnZRNx8wNLMS4Vwwns0o=;
 b=jsdAxKbqMNEphl4HLGZK/d4uyh/olanX7LdgMLHaJeKTxGzrX7zxpXO3WAPVTq2feCBV
 Ao53yNXiA2khAvjldTiffDhioAuQeTPLm3ftAlkTZxK3sYOYoSbyEoeEXXrWFqyyIok4
 tN1nznZfs0ZOHqkMGta/cCNxFSjTyeYDHrk+OX9AmUes2a9SfdvPlimjZTZ5EoMgidfh
 JxQObU3pz2DTElsZ+VYCGxpPaRVFfLjaZIbcTnoTRSa4pP48VT6p0Ns/xkhASpb4+fUb
 aZf3w5/5+upikmZNPKYNjbO7vFC4JKMHkwKvfYRXXCBdHpELQlC37vmS/A60ZbYAIhGF ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36dv7h0jtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:52:51 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10VCnEOf188744;
        Sun, 31 Jan 2021 07:52:51 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36dv7h0jtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:52:50 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10VCqmU0026354;
        Sun, 31 Jan 2021 12:52:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 36cy37rgkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 12:52:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10VCqkSx15794562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Jan 2021 12:52:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4792DA405B;
        Sun, 31 Jan 2021 12:52:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80323A4054;
        Sun, 31 Jan 2021 12:52:43 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.28.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 31 Jan 2021 12:52:43 +0000 (GMT)
Message-ID: <f7c48b191cdb549197a51d7e55c63b13c503e182.camel@linux.ibm.com>
Subject: Re: [PATCH v5 3/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        linux-integrity@vger.kernel.org
Cc:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date:   Sun, 31 Jan 2021 07:52:42 -0500
In-Reply-To: <fe83527d3745b5f071b2807d724f27f7632ed8cb.camel@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
         <20210128235621.127925-4-jarkko@kernel.org>
         <6459b955f8cb05dae7d15a233f26ff9c9501b839.camel@linux.ibm.com>
         <fe83527d3745b5f071b2807d724f27f7632ed8cb.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101310068
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-01-30 at 23:28 +0200, Jarkko Sakkinen wrote:
> On Fri, 2021-01-29 at 08:58 -0500, Mimi Zohar wrote:
> > On Fri, 2021-01-29 at 01:56 +0200, jarkko@kernel.org wrote:
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
> > > the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
> > > which are used to take temporarily the ownership of the TPM chip. The
> > > ownership is only taken inside tpm_send(), but this is not sufficient,
> > > as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
> > > need to be done as a one single atom.
> > > 
> > > Take the TPM chip ownership before sending anything with
> > > tpm_try_get_ops() and tpm_put_ops(), and use tpm_transmit_cmd() to send
> > > TPM commands instead of tpm_send(), reverting back to the old behaviour.
> > > 
> > > Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
> > > Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > > Cc: stable@vger.kernel.org
> > > Cc: David Howells <dhowells@redhat.com>
> > > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > > Cc: Sumit Garg <sumit.garg@linaro.org>
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Tested-by: Mimi Zohar <zohar@linux.ibm.com> (on TPM 1.2 & PTT, discrete
> > TPM 2.0)
> 
> Thanks, is it OK to apply the whole series?

Yes.  The testing was with the entire patch set, but I didn't
explicitly test each change.  For the other two patches, please add my
Reviewed-by.

Mimi

