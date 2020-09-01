Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54DD258D8C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgIALmj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Sep 2020 07:42:39 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726928AbgIALl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 07:41:59 -0400
Received: from lhreml726-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id F168EDFA3E5FEAFFAA85;
        Tue,  1 Sep 2020 12:41:57 +0100 (IST)
Received: from fraeml706-chm.china.huawei.com (10.206.15.55) by
 lhreml726-chm.china.huawei.com (10.201.108.77) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Tue, 1 Sep 2020 12:41:57 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 1 Sep 2020 13:41:56 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Tue, 1 Sep 2020 13:41:56 +0200
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
Thread-Index: AQHWRYqWnNLPRhTOMk2ID5bSdlZ6YalHdJUAgAx1KTCAAAkjgIAAJpbA
Date:   Tue, 1 Sep 2020 11:41:56 +0000
Message-ID: <7f3dd815639a44ba9b0fb532c217bd21@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-7-roberto.sassu@huawei.com>
         <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
         <a5e6a5acf2274a6d844b275dacfbabb8@huawei.com>
 <ae06c113ec91442e293f2466cae3dd1b81f241eb.camel@linux.ibm.com>
In-Reply-To: <ae06c113ec91442e293f2466cae3dd1b81f241eb.camel@linux.ibm.com>
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
> Sent: Tuesday, September 1, 2020 1:05 PM
> On Tue, 2020-09-01 at 09:08 +0000, Roberto Sassu wrote:
> > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > Sent: Monday, August 24, 2020 2:18 PM
> > > On Thu, 2020-06-18 at 18:04 +0200, Roberto Sassu wrote:
> > > > When EVM_ALLOW_METADATA_WRITES is set, EVM allows any
> operation
> > > on
> > > > metadata. Its main purpose is to allow users to freely set metadata
> when
> > > > they are protected by a portable signature, until the HMAC key is
> loaded.
> > > >
> > > > However, IMA is not notified about metadata changes and, after the
> first
> > > > appraisal, always allows access to the files without checking metadata
> > > > again.
> > >
> > > ^after the first successful appraisal
> > > >
> > > > This patch checks in evm_reset_status() if EVM_ALLOW_METADATA
> > > WRITES is
> > > > enabled and if it is, sets the IMA_CHANGE_XATTR/ATTR bits
> depending on
> > > the
> > > > operation performed. At the next appraisal, metadata are revalidated.
> > >
> > > EVM modifying IMA bits crosses the boundary between EVM and IMA.
> > > There
> > > is already an IMA post_setattr hook.  IMA could reset its own bit
> > > there.  If necessary EVM could export as a function it's status info.
> >
> > I wouldn't try to guess in IMA when EVM resets its status. We would have
> > to duplicate the logic to check if an EVM key is loaded, if the passed xattr
> > is a POSIX ACL, ...
> 
> Agreed, but IMA could call an EVM function.
> 
> >
> > I think it is better to set a flag, maybe a new one, directly in EVM, to notify
> > the integrity subsystem that iint->evm_status is no longer valid.
> >
> > If the EVM flag is set, IMA would reset the appraisal flags, as it uses
> > iint->evm_status for appraisal. We can consider to reset also the measure
> > flags when we have a template that includes file metadata.
> 
> When would IMA read the EVM flag?   Who would reset the flag?  At what
> point would it be reset?   Just as EVM shouldn't be resetting the IMA
> flag, IMA shouldn't be resetting the EVM flag.

IMA would read the flag in process_measurement() and behave similarly
to when it processes IMA_CHANGE_ATTR. The flag would be reset by
evm_verify_hmac().

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli
