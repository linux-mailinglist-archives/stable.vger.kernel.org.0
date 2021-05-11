Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D684C37A8A7
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 16:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhEKONS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 May 2021 10:13:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3060 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhEKONR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 10:13:17 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fffm65Tryz6877F;
        Tue, 11 May 2021 22:03:50 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 11 May 2021 16:12:06 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2176.012;
 Tue, 11 May 2021 16:12:06 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "mjg59@google.com" <mjg59@google.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v6 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if an
 HMAC key is loaded
Thread-Topic: [PATCH v6 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if
 an HMAC key is loaded
Thread-Index: AQHXQaH+gJYK7G6CpEWWiKFKXoh7XareMf4AgAAoMpA=
Date:   Tue, 11 May 2021 14:12:06 +0000
Message-ID: <1f0530bc9b974951ae0bb1e2beb02422@huawei.com>
References: <20210505112935.1410679-1-roberto.sassu@huawei.com>
         <20210505112935.1410679-4-roberto.sassu@huawei.com>
 <6f5603489b16918de5d3cbb73c1a7c0e835f0671.camel@linux.ibm.com>
In-Reply-To: <6f5603489b16918de5d3cbb73c1a7c0e835f0671.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Tuesday, May 11, 2021 3:42 PM
> On Wed, 2021-05-05 at 13:29 +0200, Roberto Sassu wrote:
> > EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be
> set to
> > temporarily disable metadata verification until all xattrs/attrs necessary
> > to verify an EVM portable signature are copied to the file. This flag is
> > cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
> > calculated on unverified xattrs/attrs.
> >
> > Currently EVM unnecessarily denies setting this flag if EVM is initialized
> > with a public key, which is not a concern as it cannot be used to trust
> > xattrs/attrs updates. This patch removes this limitation.
> >
> > Cc: stable@vger.kernel.org # 4.16.x
> > Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-
> protected metadata")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Once the comments below are addressed,
> 
> Reviewed-by:  Mimi Zohar <zohar@linux.ibm.com>
> 
> > ---
> >  Documentation/ABI/testing/evm      | 5 +++--
> >  security/integrity/evm/evm_secfs.c | 5 ++---
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/ABI/testing/evm
> b/Documentation/ABI/testing/evm
> > index 3c477ba48a31..eb6d70fd6fa2 100644
> > --- a/Documentation/ABI/testing/evm
> > +++ b/Documentation/ABI/testing/evm
> > @@ -49,8 +49,9 @@ Description:
> >  		modification of EVM-protected metadata and
> >  		disable all further modification of policy
> >
> > -		Note that once a key has been loaded, it will no longer be
> > -		possible to enable metadata modification.
> > +		Note that once an HMAC key has been loaded, it will no longer
> > +		be possible to enable metadata modification and, if it is
> > +		already enabled, it will be disabled.
> 
> It's worth mentioning that echo'ing a new value is additive.  Once EVM
> metadata modification is enabled, the only way of disabling it is by
> enabling an HMAC key.  It's also worth mentioning that metadata writes
> are only permitted once further changes to the EVM policy are disabled.

If I'm not wrong, it is not required to set EVM_SETUP_COMPLETE to allow
metadata writes. I think the original idea was to boot a system in a way
that portable signatures can be written, and then to enable enforcement.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli

> Perhaps the best way of explaining this is by including a new example -
> echo 6> <securityfs>/evm.
> 
> >
> >  		Until key loading has been signaled EVM can not create
> >  		or validate the 'security.evm' xattr, but returns
> > diff --git a/security/integrity/evm/evm_secfs.c
> b/security/integrity/evm/evm_secfs.c
> > index bbc85637e18b..860c48b9a0c3 100644
> > --- a/security/integrity/evm/evm_secfs.c
> > +++ b/security/integrity/evm/evm_secfs.c
> > @@ -81,11 +81,10 @@ static ssize_t evm_write_key(struct file *file, const
> char __user *buf,
> >  		return -EINVAL;
> >
> >  	/* Don't allow a request to freshly enable metadata writes if
> > -	 * keys are loaded.
> > +	 * an HMAC key is loaded.
> >  	 */
> 
> Please drop the word "freshly".  While updating the comment, please
> move the sentence starting with "Don't" to a new line.
> 
> >  	if ((i & EVM_ALLOW_METADATA_WRITES) &&
> > -	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
> > -	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
> > +	    (evm_initialized & EVM_INIT_HMAC) != 0)
> >  		return -EPERM;
> >
> >  	if (i & EVM_INIT_HMAC) {
> 

