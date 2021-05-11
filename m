Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7CE37AFB8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 21:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEKTys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:54:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229920AbhEKTyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:54:47 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BJYnAc044402;
        Tue, 11 May 2021 15:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uwIX+a9AmDwK0Whw4IZJuRNHjaUD+3bsa0lcZexzn4Q=;
 b=rruHaDCRRf3HsPdbX76G8oJr++qlISVDIEuLgBFWPs0sxXVsh78ZRp7t0w8zXavK6+1H
 YfFfj5VoEpymbd4CC6AxB9M2GtaBrBLH2B71TSeB/WyryEOVdOZEvSLwHV2EAC44ej0d
 Kc3W7Pnj+JI6Zshv/1g8jURWl2tEADt8V/MVnpzoMXBRXK/BlkGp1iNW11DmhdSwO7fj
 vKY9ektWG/liyu1E+klKuhTUU66+IPtRkaZ0ULYwThWKpwlD+g9xiYxcoyltl0S8EmzR
 WrZ5z3DzyAOJroWRvUwQRJ77gmy18r9f1MjiX/spS8RX2geuTKtoWbwaBdM/h2AQ68fL BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fyng9b26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 15:53:35 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BJYqG8044680;
        Tue, 11 May 2021 15:53:35 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fyng9b1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 15:53:34 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BJkqRx026071;
        Tue, 11 May 2021 19:53:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 38dhwh10gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 19:53:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BJr4gZ31981934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 19:53:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8CE15204E;
        Tue, 11 May 2021 19:53:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.116.76])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4B05852050;
        Tue, 11 May 2021 19:53:29 +0000 (GMT)
Message-ID: <c0d393c4c8e676ea1423b6abfbaa6418a12f10f0.camel@linux.ibm.com>
Subject: Re: [PATCH v6 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if
 an HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 11 May 2021 15:53:28 -0400
In-Reply-To: <1f0530bc9b974951ae0bb1e2beb02422@huawei.com>
References: <20210505112935.1410679-1-roberto.sassu@huawei.com>
         <20210505112935.1410679-4-roberto.sassu@huawei.com>
         <6f5603489b16918de5d3cbb73c1a7c0e835f0671.camel@linux.ibm.com>
         <1f0530bc9b974951ae0bb1e2beb02422@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OiEadkjEZY-psod8V59iJYsAziHwSPp6
X-Proofpoint-ORIG-GUID: klQcZJ7zyaf0V3HOJQdanH3yRk1fem3p
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-05-11 at 14:12 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Tuesday, May 11, 2021 3:42 PM
> > On Wed, 2021-05-05 at 13:29 +0200, Roberto Sassu wrote:
> > > EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be
> > set to
> > > temporarily disable metadata verification until all xattrs/attrs necessary
> > > to verify an EVM portable signature are copied to the file. This flag is
> > > cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
> > > calculated on unverified xattrs/attrs.
> > >
> > > Currently EVM unnecessarily denies setting this flag if EVM is initialized
> > > with a public key, which is not a concern as it cannot be used to trust
> > > xattrs/attrs updates. This patch removes this limitation.
> > >
> > > Cc: stable@vger.kernel.org # 4.16.x
> > > Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-
> > protected metadata")
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Once the comments below are addressed,
> > 
> > Reviewed-by:  Mimi Zohar <zohar@linux.ibm.com>
> > 
> > > ---
> > >  Documentation/ABI/testing/evm      | 5 +++--
> > >  security/integrity/evm/evm_secfs.c | 5 ++---
> > >  2 files changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/Documentation/ABI/testing/evm
> > b/Documentation/ABI/testing/evm
> > > index 3c477ba48a31..eb6d70fd6fa2 100644
> > > --- a/Documentation/ABI/testing/evm
> > > +++ b/Documentation/ABI/testing/evm
> > > @@ -49,8 +49,9 @@ Description:
> > >  		modification of EVM-protected metadata and
> > >  		disable all further modification of policy
> > >
> > > -		Note that once a key has been loaded, it will no longer be
> > > -		possible to enable metadata modification.
> > > +		Note that once an HMAC key has been loaded, it will no longer
> > > +		be possible to enable metadata modification and, if it is
> > > +		already enabled, it will be disabled.
> > 
> > It's worth mentioning that echo'ing a new value is additive.  Once EVM
> > metadata modification is enabled, the only way of disabling it is by
> > enabling an HMAC key.  It's also worth mentioning that metadata writes
> > are only permitted once further changes to the EVM policy are disabled.
> 
> If I'm not wrong, it is not required to set EVM_SETUP_COMPLETE to allow
> metadata writes.

Agreed, EVM_SETUP_COMPLETE is not needed to allow metadata writes. 
Once EVM_ALLOW_METADATA_WRITES is enabled, however, there is no way of
unsetting it without loading the HMAC key.

> I think the original idea was to boot a system in a way
> that portable signatures can be written, and then to enable enforcement.

Nothing special is needed to write portable signatures.  Based on the
documentation, I think the original intention supports three modes:
- only enable HMAC validation  (1)
- enable both HMAC and digital signature validation (3)
- only enable digital signature validation and allow modification of
EVM-protected metadata (6)

The third example is enabled using "0x80000006", which also prevents
enabling HMAC verification.  Leaving out the example of enabling just
digital signature validation without modification of EVM protected
metadata seems to have been intentional.

thanks,

Mimi

