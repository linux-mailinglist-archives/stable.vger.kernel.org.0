Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7862626E2EF
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgIQRwm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 17 Sep 2020 13:52:42 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2883 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726648AbgIQRwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 13:52:15 -0400
X-Greylist: delayed 960 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:52:14 EDT
Received: from lhreml729-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 4C8B462749644120D060;
        Thu, 17 Sep 2020 18:36:05 +0100 (IST)
Received: from fraeml706-chm.china.huawei.com (10.206.15.55) by
 lhreml729-chm.china.huawei.com (10.201.108.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 17 Sep 2020 18:36:05 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 17 Sep 2020 19:36:03 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Thu, 17 Sep 2020 19:36:03 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "mjg59@google.com" <mjg59@google.com>,
        John Johansen <john.johansen@canonical.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 07/12] evm: Introduce EVM_RESET_STATUS atomic flag
Thread-Topic: [PATCH v2 07/12] evm: Introduce EVM_RESET_STATUS atomic flag
Thread-Index: AQHWgp3/4yVQpxJegUaUIa256vF1xqlsrbeAgAB3aaA=
Date:   Thu, 17 Sep 2020 17:36:03 +0000
Message-ID: <581966c47e94412ab3fd5b2ca9aacd3d@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
         <20200904092643.20013-3-roberto.sassu@huawei.com>
 <5bbf2169cfa38bb7a3d696e582c1de954a82d5c6.camel@linux.ibm.com>
In-Reply-To: <5bbf2169cfa38bb7a3d696e582c1de954a82d5c6.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Thursday, September 17, 2020 2:01 PM
> [Cc'ing John Johansen]
> 
> Hi Roberto,
> 
> On Fri, 2020-09-04 at 11:26 +0200, Roberto Sassu wrote:
> > When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation
> on
> > metadata. Its main purpose is to allow users to freely set metadata when
> > they are protected by a portable signature, until the HMAC key is loaded.
> >
> > However, IMA is not notified about metadata changes and, after the first
> > successful appraisal, always allows access to the files without checking
> > metadata again.
> >
> > This patch introduces the new atomic flag EVM_RESET_STATUS in
> > integrity_iint_cache that is set in the EVM post hooks and cleared in
> > evm_verify_hmac(). IMA checks the new flag in process_measurement()
> and if
> > it is set, it clears the appraisal flags.
> >
> > Although the flag could be cleared also by evm_inode_setxattr() and
> > evm_inode_setattr() before IMA sees it, this does not happen if
> > EVM_ALLOW_METADATA_WRITES is set. Since the only remaining caller is
> > evm_verifyxattr(), this ensures that IMA always sees the flag set before it
> > is cleared.
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
> >  security/integrity/evm/evm_main.c | 17 +++++++++++++++--
> >  security/integrity/ima/ima_main.c |  8 ++++++--
> >  security/integrity/integrity.h    |  1 +
> >  3 files changed, 22 insertions(+), 4 deletions(-)
> >
> > diff --git a/security/integrity/evm/evm_main.c
> b/security/integrity/evm/evm_main.c
> > index 4e9f5e8b21d5..05be1ad3e6f3 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -221,8 +221,15 @@ static enum integrity_status
> evm_verify_hmac(struct dentry *dentry,
> >  		evm_status = (rc == -ENODATA) ?
> >  				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
> >  out:
> > -	if (iint)
> > +	if (iint) {
> > +		/*
> > +		 * EVM_RESET_STATUS can be cleared only by
> evm_verifyxattr()
> > +		 * when EVM_ALLOW_METADATA_WRITES is set. This
> guarantees that
> > +		 * IMA sees the EVM_RESET_STATUS flag set before it is
> cleared.
> > +		 */
> > +		clear_bit(EVM_RESET_STATUS, &iint->atomic_flags);
> >  		iint->evm_status = evm_status;
> 
> True IMA is currently the only caller of evm_verifyxattr() in the
> upstreamed kernel, but it is an exported function, which may be called
> from elsewhere.  The previous version crossed the boundary between EVM
> & IMA with EVM modifying the IMA flag directly.  This version assumes
> that IMA will be the only caller.  Otherwise, I like this version.

Ok, I think it is better, as you suggested, to export a new EVM function
that tells if evm_reset_status() will be executed in the EVM post hooks, and
to call this function from IMA. IMA would then call ima_reset_appraise_flags()
also depending on the result of the new EVM function.

ima_reset_appraise_flags() should be called in a post hook in IMA.
Should I introduce it?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli

> Mimi
> 
> > +	}
> >  	kfree(xattr_data);
> >  	return evm_status;
> >  }
> > @@ -418,8 +425,12 @@ static void evm_reset_status(struct inode *inode)
> >  	struct integrity_iint_cache *iint;
> >
> >  	iint = integrity_iint_find(inode);
> > -	if (iint)
> > +	if (iint) {
> > +		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
> > +			set_bit(EVM_RESET_STATUS, &iint->atomic_flags);
> > +
> >  		iint->evm_status = INTEGRITY_UNKNOWN;
> > +	}
> >  }
> >
> >  /**
> > @@ -513,6 +524,8 @@ void evm_inode_post_setattr(struct dentry
> *dentry, int ia_valid)
> >  	if (!evm_key_loaded())
> >  		return;
> >
> > +	evm_reset_status(dentry->d_inode);
> > +
> >  	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
> >  		evm_update_evmxattr(dentry, NULL, NULL, 0);
> >  }

