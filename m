Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5625258B02
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIAJJA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Sep 2020 05:09:00 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2719 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbgIAJJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 05:09:00 -0400
Received: from lhreml732-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2E910473AFED2B69E7F2;
        Tue,  1 Sep 2020 10:08:58 +0100 (IST)
Received: from fraeml702-chm.china.huawei.com (10.206.15.51) by
 lhreml732-chm.china.huawei.com (10.201.108.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Tue, 1 Sep 2020 10:08:57 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 1 Sep 2020 11:08:57 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Tue, 1 Sep 2020 11:08:57 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "mjg59@google.com" <mjg59@google.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if
 EVM_ALLOW_METADATA_WRITES is set
Thread-Topic: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if
 EVM_ALLOW_METADATA_WRITES is set
Thread-Index: AQHWRYqWnNLPRhTOMk2ID5bSdlZ6YalHdJUAgAx1KTA=
Date:   Tue, 1 Sep 2020 09:08:57 +0000
Message-ID: <a5e6a5acf2274a6d844b275dacfbabb8@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-7-roberto.sassu@huawei.com>
 <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
In-Reply-To: <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.193.114]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Monday, August 24, 2020 2:18 PM
> On Thu, 2020-06-18 at 18:04 +0200, Roberto Sassu wrote:
> > When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation
> on
> > metadata. Its main purpose is to allow users to freely set metadata when
> > they are protected by a portable signature, until the HMAC key is loaded.
> >
> > However, IMA is not notified about metadata changes and, after the first
> > appraisal, always allows access to the files without checking metadata
> > again.
> 
> ^after the first successful appraisal
> >
> > This patch checks in evm_reset_status() if EVM_ALLOW_METADATA
> WRITES is
> > enabled and if it is, sets the IMA_CHANGE_XATTR/ATTR bits depending on
> the
> > operation performed. At the next appraisal, metadata are revalidated.
> 
> EVM modifying IMA bits crosses the boundary between EVM and IMA.
> There
> is already an IMA post_setattr hook.  IMA could reset its own bit
> there.  If necessary EVM could export as a function it's status info.

I wouldn't try to guess in IMA when EVM resets its status. We would have
to duplicate the logic to check if an EVM key is loaded, if the passed xattr
is a POSIX ACL, ...

I think it is better to set a flag, maybe a new one, directly in EVM, to notify
the integrity subsystem that iint->evm_status is no longer valid.

If the EVM flag is set, IMA would reset the appraisal flags, as it uses
iint->evm_status for appraisal. We can consider to reset also the measure
flags when we have a template that includes file metadata.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli

> Mimi
> 
> >
> > This patch also adds a call to evm_reset_status() in
> > evm_inode_post_setattr() so that EVM won't return the cached status
> the
> > next time appraisal is performed.
> >
> > Cc: stable@vger.kernel.org # 4.16.x
> > Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of
> EVM-protected metadata")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/integrity/evm/evm_main.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/security/integrity/evm/evm_main.c
> b/security/integrity/evm/evm_main.c
> > index 41cc6a4aaaab..d4d918183094 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -478,13 +478,17 @@ int evm_inode_removexattr(struct dentry
> *dentry, const char *xattr_name)
> >  	return evm_protect_xattr(dentry, xattr_name, NULL, 0);
> >  }
> >
> > -static void evm_reset_status(struct inode *inode)
> > +static void evm_reset_status(struct inode *inode, int bit)
> >  {
> >  	struct integrity_iint_cache *iint;
> >
> >  	iint = integrity_iint_find(inode);
> > -	if (iint)
> > +	if (iint) {
> > +		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
> > +			set_bit(bit, &iint->atomic_flags);
> > +
> >  		iint->evm_status = INTEGRITY_UNKNOWN;
> > +	}
> >  }
> >
> >  /**:q
> > @@ -507,7 +511,7 @@ void evm_inode_post_setxattr(struct dentry
> *dentry, const char *xattr_name,
> >  				  && !posix_xattr_acl(xattr_name)))
> >  		return;
> >
> > -	evm_reset_status(dentry->d_inode);
> > +	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
> >
> >  	evm_update_evmxattr(dentry, xattr_name, xattr_value,
> xattr_value_len);
> >  }
> > @@ -527,7 +531,7 @@ void evm_inode_post_removexattr(struct dentry
> *dentry, const char *xattr_name)
> >  	if (!evm_key_loaded() || !evm_protected_xattr(xattr_name))
> >  		return;
> >
> > -	evm_reset_status(dentry->d_inode);
> > +	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
> >
> >  	evm_update_evmxattr(dentry, xattr_name, NULL, 0);
> >  }
> > @@ -600,6 +604,8 @@ void evm_inode_post_setattr(struct dentry
> *dentry, int ia_valid)
> >  	if (!evm_key_loaded())
> >  		return;
> >
> > +	evm_reset_status(dentry->d_inode, IMA_CHANGE_ATTR);
> > +
> >  	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
> >  		evm_update_evmxattr(dentry, NULL, NULL, 0);
> >  }
> 

