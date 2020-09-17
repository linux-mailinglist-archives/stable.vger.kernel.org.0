Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BCB26E2D9
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgIQRtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 13:49:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgIQRtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 13:49:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HHVj6S017144;
        Thu, 17 Sep 2020 13:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=L0d4AizRtjDKBJM6yo/trbmNT+QgmsfNN9pL2W8GtFA=;
 b=k+lGzudsXwm43PlV41Qk60gsStFa11i0wnQ18HzuC5UgGsp6nNFNpVXBiK55IISrE46d
 /GHgFY5z3M/o3Ejks6EbpmtYZ0v1GghHvW9LBaqUErf8D1NfSbP1B1zc4M9iHm+GeTCh
 GYEvirHdllOzcAOzb6tCA9hQG9Q178ZMGhkeeDL5e5NuGyaJjlBg87/FmLYjE3mbMmg8
 A+RoqheaakshwkzK24HnhGL1NXU6mSIfr8Z0xMYNodl68CxhDkJrnsEEFOoNdPpHklkP
 qg+3NVSsbyIplmzuiAWR0kUW3RHCU5dHZToOWWnMVk+MRntdsFqFbO+7Mn4qZLHjP3za 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m9wuna2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 13:48:00 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HHaobg032475;
        Thu, 17 Sep 2020 13:48:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m9wuna1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 13:48:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HHgN9d002494;
        Thu, 17 Sep 2020 17:47:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 33k6esjby5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 17:47:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HHkLUR28115236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 17:46:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 872C54C040;
        Thu, 17 Sep 2020 17:47:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA65E4C046;
        Thu, 17 Sep 2020 17:47:53 +0000 (GMT)
Received: from sig-9-65-208-105.ibm.com (unknown [9.65.208.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 17:47:53 +0000 (GMT)
Message-ID: <a19576f23e7f9d3e7c546672d1335b324bf9ca9f.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/12] evm: Introduce EVM_RESET_STATUS atomic flag
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>,
        John Johansen <john.johansen@canonical.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 17 Sep 2020 13:47:52 -0400
In-Reply-To: <581966c47e94412ab3fd5b2ca9aacd3d@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
         <20200904092643.20013-3-roberto.sassu@huawei.com>
         <5bbf2169cfa38bb7a3d696e582c1de954a82d5c6.camel@linux.ibm.com>
         <581966c47e94412ab3fd5b2ca9aacd3d@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_12:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 adultscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=3 bulkscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-09-17 at 17:36 +0000, Roberto Sassu wrote:
> > > diff --git a/security/integrity/evm/evm_main.c
> > b/security/integrity/evm/evm_main.c
> > > index 4e9f5e8b21d5..05be1ad3e6f3 100644
> > > --- a/security/integrity/evm/evm_main.c
> > > +++ b/security/integrity/evm/evm_main.c
> > > @@ -221,8 +221,15 @@ static enum integrity_status
> > evm_verify_hmac(struct dentry *dentry,
> > >  		evm_status = (rc == -ENODATA) ?
> > >  				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
> > >  out:
> > > -	if (iint)
> > > +	if (iint) {
> > > +		/*
> > > +		 * EVM_RESET_STATUS can be cleared only by
> > evm_verifyxattr()
> > > +		 * when EVM_ALLOW_METADATA_WRITES is set. This
> > guarantees that
> > > +		 * IMA sees the EVM_RESET_STATUS flag set before it is
> > cleared.
> > > +		 */
> > > +		clear_bit(EVM_RESET_STATUS, &iint->atomic_flags);
> > >  		iint->evm_status = evm_status;
> > 
> > True IMA is currently the only caller of evm_verifyxattr() in the
> > upstreamed kernel, but it is an exported function, which may be called
> > from elsewhere.  The previous version crossed the boundary between EVM
> > & IMA with EVM modifying the IMA flag directly.  This version assumes
> > that IMA will be the only caller.  Otherwise, I like this version.
> 
> Ok, I think it is better, as you suggested, to export a new EVM function
> that tells if evm_reset_status() will be executed in the EVM post hooks, and
> to call this function from IMA. IMA would then call ima_reset_appraise_flags()
> also depending on the result of the new EVM function.
> 
> ima_reset_appraise_flags() should be called in a post hook in IMA.
> Should I introduce it?

Yes, so any callers of evm_verifyxattr() will need to implement the
post hook as well.  As much as possible, please limit code duplication.

The last time I looked, there didn't seem to be a locking concern, but
please make sure.

thanks,

Mimi



