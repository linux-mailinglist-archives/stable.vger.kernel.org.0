Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8419325AC3D
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIBNq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 09:46:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgIBNpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 09:45:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082DWCwx077202;
        Wed, 2 Sep 2020 09:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5oLkh9zCufGNd1xyAl+9tctnQwJ8sBHIuNfKtYGlwVw=;
 b=Rcs11yb/MxsMAIaM7LLduxZtDQ/C5o0jMsp6uzNaigxkhadHGrc1URXBmxKnl/a2ESxy
 pTuuUE2Uf0dC41K3rHnAOFUaSE2+GcMoQDVfpLgkUrOqB2sgmg3An36Nxrt+6kt47ts/
 8C8I0n+IfqhAPWWXcCBLIiBTk1bAPizg2uyFnwVYVPufLwN9IqYDKavOAOULyjODyiZx
 bADAaLfJp8aGvg3A7A7Kad7rPkziMpbyur3QjHDySAT2LPp4c+OoQYj811jPc+x+qx1H
 a08VCL7d3a9A7LNZCXucjjwyl5TaJ0Rg4arhqgB0jaRdEtFgnjjASNcLwTmmMWXpzWoM 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ab96jjb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:41:00 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 082DXJq5082445;
        Wed, 2 Sep 2020 09:41:00 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ab96jj9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:40:59 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 082DcMA1022715;
        Wed, 2 Sep 2020 13:40:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 337en7jxa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 13:40:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 082DdNN065405210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 13:39:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC0574203F;
        Wed,  2 Sep 2020 13:40:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B66B942042;
        Wed,  2 Sep 2020 13:40:52 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.121.98])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 13:40:52 +0000 (GMT)
Message-ID: <3c5840d3a827ccae575fc73d1aa4ed9f523c46b8.camel@linux.ibm.com>
Subject: Re: [PATCH 01/11] evm: Execute evm_inode_init_security() only when
 the HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>, Petr Vorel <pvorel@suse.cz>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
Date:   Wed, 02 Sep 2020 09:40:51 -0400
In-Reply-To: <5404e618f79b4914b45c1d19791f470b@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <2b204e31d21e93c0167d154c2397cd5d11be6e7f.camel@linux.ibm.com>
         <d4c9d5333256b17acdbe41729dd680f534266130.camel@linux.ibm.com>
         <5404e618f79b4914b45c1d19791f470b@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_09:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-09-02 at 11:42 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Monday, August 24, 2020 7:45 PM
> > Hi Roberto,
> > 
> > On Fri, 2020-08-21 at 14:30 -0400, Mimi Zohar wrote:
> > > Sorry for the delay in reviewing these patches.   Missing from this
> > > patch set is a cover letter with an explanation for grouping these
> > > patches into a patch set, other than for convenience.  In this case, it
> > > would be along the lines that the original use case for EVM portable
> > > and immutable keys support was for a few critical files, not combined
> > > with an EVM encrypted key type.   This patch set more fully integrates
> > > the initial EVM portable and immutable signature support.
> > 
> > Thank you for more fully integrating the EVM portable signatures into
> > IMA.
> > 
> > " [PATCH 08/11] ima: Allow imasig requirement to be satisfied by EVM
> > portable signatures" equates an IMA signature to having a portable and
> > immutable EVM signature.  That is true in terms of signature
> > verification, but from an attestation perspective the "ima-sig"
> > template will not contain a signature.  If not the EVM signature, then
> > at least some other indication should be included in the measurement
> > list.
> 
> Would it be ok to print the EVM portable signature in the sig field if the IMA
> signature is not found? Later we can introduce the new template evm-sig
> to include all metadata necessary to verify the EVM portable signature.

As long as the attestation server can differentiate between the
signature types, including the EVM signature should be fine.

> 
> > Are you planning on posting the associated IMA/EVM regression tests?
> 
> I didn't have a look yet at the code. I will try to write some later.

It looks like ima_verify_signature() in ima-evm-utils could be extended
to support the EVM portable signature or at least not to fail the
signature verification.

Mimi

