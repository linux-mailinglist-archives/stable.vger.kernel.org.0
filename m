Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B769C56BC5
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 16:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFZOYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 10:24:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48648 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZOYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 10:24:06 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hg8q6-0003Sq-Hc; Wed, 26 Jun 2019 16:23:58 +0200
Date:   Wed, 26 Jun 2019 16:23:57 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        mingo@redhat.com, Borislav Petkov <bp@alien8.de>,
        rkrcmar@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even
 if host does not
In-Reply-To: <f258b10f-dae3-7cf4-5a0c-47fe067065b4@redhat.com>
Message-ID: <alpine.DEB.2.21.1906261622570.32342@nanos.tec.linutronix.de>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com> <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com> <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de> <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
 <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de> <b6c2ac14-d647-0fa2-f19d-88944c63c37a@redhat.com> <alpine.DEB.2.21.1906261440570.32342@nanos.tec.linutronix.de> <f258b10f-dae3-7cf4-5a0c-47fe067065b4@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Jun 2019, Paolo Bonzini wrote:
> On 26/06/19 14:41, Thomas Gleixner wrote:
> >> I think it's better to leave the guest in control of SSBD even if it's
> >> globally disabled.  The harm cannot escape the guest and in particular
> >> it cannot escape to the sibling hyperthread.
> >
> > SSB allows guest to guest attacks IIRC
> 
> SSB requires something like
> 
>    p = &foo;
>    ...
>    p = &bar;
>    q = *p;
> 
> where "p = &foo;" is executed from one privilege domain and the others
> are executed by another process or privilege domain.  Unless two guests
> share memory, it is not possible to use it for guest-to-guest attacks.

Fair enough. It's way too hot to think clearly about these kind of problems
and there are simply way too many of them...

Thanks,

	tglx
