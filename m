Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22BD257540
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgHaIY3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 31 Aug 2020 04:24:29 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2709 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728240AbgHaIYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 04:24:14 -0400
Received: from lhreml717-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id F1F1CF6FF3E8EA4DA731;
        Mon, 31 Aug 2020 09:24:09 +0100 (IST)
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Mon, 31 Aug 2020 09:24:09 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 31 Aug 2020 10:24:08 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Mon, 31 Aug 2020 10:24:08 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "mjg59@google.com" <mjg59@google.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
Subject: RE: [PATCH 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the
 HMAC key is loaded
Thread-Topic: [PATCH 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the
 HMAC key is loaded
Thread-Index: AQHWRYof9RvD1u4yLUW/etQ+7VmgjKlDQsYAgA8N9fA=
Date:   Mon, 31 Aug 2020 08:24:08 +0000
Message-ID: <0c1c8fb398c340d89531360be7e3418b@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <20200618160133.937-3-roberto.sassu@huawei.com>
 <caedd49bc2080a2fb8b16b9ecacab67d11e68fd7.camel@linux.ibm.com>
In-Reply-To: <caedd49bc2080a2fb8b16b9ecacab67d11e68fd7.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.205.186]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Friday, August 21, 2020 10:15 PM
> Hi Roberto,
> 
> On Thu, 2020-06-18 at 18:01 +0200, Roberto Sassu wrote:
> > Granting metadata write is safe if the HMAC key is not loaded, as it won't
> > let an attacker obtain a valid HMAC from corrupted xattrs.
> evm_write_key()
> > however does not allow it if any key is loaded, including a public key,
> > which should not be a problem.
> >
> 
> Why is the existing hebavior a problem?  What is the problem being
> solved?

Hi Mimi

currently it is not possible to set EVM_ALLOW_METADATA_WRITES when
only a public key is loaded and the HMAC key is not. The patch removes
this limitation.

> > This patch allows setting EVM_ALLOW_METADATA_WRITES if the
> EVM_INIT_HMAC
> > flag is not set.
> >
> > Cc: stable@vger.kernel.org # 4.16.x
> > Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of
> EVM-protected metadata")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/integrity/evm/evm_secfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/security/integrity/evm/evm_secfs.c
> b/security/integrity/evm/evm_secfs.c
> > index cfc3075769bb..92fe26ace797 100644
> > --- a/security/integrity/evm/evm_secfs.c
> > +++ b/security/integrity/evm/evm_secfs.c
> > @@ -84,7 +84,7 @@ static ssize_t evm_write_key(struct file *file, const
> char __user *buf,
> >  	 * keys are loaded.
> >  	 */
> >  	if ((i & EVM_ALLOW_METADATA_WRITES) &&
> > -	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
> > +	    ((evm_initialized & EVM_INIT_HMAC) != 0) &&
> >  	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
> >  		return -EPERM;
> 
> >
> 
> Documentation/ABI/testing/evm needs to be updated as well.

Ok.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli

> thanks,
> 
> Mimi
> 
> 

