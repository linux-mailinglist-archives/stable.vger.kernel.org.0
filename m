Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092BA3C191B
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhGHSWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHSWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C84161624;
        Thu,  8 Jul 2021 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768390;
        bh=p+hFKrvhmYbXylriW8rlFFxTI8KmTmEO2gVwths0WVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxJeeMTIihGtxwreQMVvPB7Lo4SClHR6xTvFyEMBRIXoUvTSS7LBcsTU6X5xwkB6d
         NfpJoEU6dOcN0dnPB0ipcBG84FiwpLBM6iApY2L2VP/UK3lBYtO4qbLDgdpD7ZRxe9
         QbifbvS8Mrp8K3mbIjMOKN12LlP5MZi3/ZVifQtA=
Date:   Thu, 8 Jul 2021 20:19:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        stable@vger.kernel.org, sashal@kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH for 4.19, 5.4] KVM: SVM: Periodically schedule when
 unregistering regions on destroy
Message-ID: <YOdBxCmbAKXPkq8r@kroah.com>
References: <20210708050253.341098-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <e6bb1290-6db7-97c1-cb24-403beb4e1609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6bb1290-6db7-97c1-cb24-403beb4e1609@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 11:17:33AM +0200, Paolo Bonzini wrote:
> On 08/07/21 07:02, Nobuhiro Iwamatsu wrote:
> > From: David Rientjes <rientjes@google.com>
> > 
> > commit 7be74942f184fdfba34ddd19a0d995deb34d4a03 upstream.
> 
> Part of 5.9.
> 
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index c5673bda4b66df..3f776e654e3aec 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -1910,6 +1910,7 @@ static void sev_vm_destroy(struct kvm *kvm)
> >   		list_for_each_safe(pos, q, head) {
> >   			__unregister_enc_region_locked(kvm,
> >   				list_entry(pos, struct enc_region, list));
> > +			cond_resched();
> >   		}
> >   	}
> > 
> 
> Patch is the same as the upstream commit, except for the name of the file.
> Thanks!
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Now queued up, thanks.

greg k-h
