Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D34F2FDE3D
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 01:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbhAUAys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 19:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393220AbhAUAad (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 19:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB2222360D;
        Thu, 21 Jan 2021 00:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611188988;
        bh=Bf6IO1ATdMc1vvu9RwHpYCGphEkPnoTilBxPqOFvYr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ExELCMAdDuoz/4llJH1V/29Y/8TRNhsh6RmJe3bopnZ0HpgOkrK5ikepUoEFw30km
         mGtEE2GF6aWlsoeVXwO3vVnsATYe+DQ3dLHGpxmRAz2NjEGGKa3Aarcaa3R7bTiwFr
         OaMjf5VSWImvUnveUXA1BM/lyLcwR8IODiquZpqzaOanU/kIJpOkliMsXzx8EUcFgT
         47hT49hMXDV5U9DVAygdUdOW+/VBizXhTLNcYN/JgwwrTpMJuX1lcAbIy0zCLvo0za
         d8Nn0Z3AyDXjTEtQQDgl/7YXFfAxv5bQ8vYQjEwijIk//xSnZAOp3b4rCIHg5y7ksU
         6od8hkx2qrYBQ==
Date:   Thu, 21 Jan 2021 02:29:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAjK9n6zct2VTp74@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <YAhp4Jrj6hIcvgRC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAhp4Jrj6hIcvgRC@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 09:35:28AM -0800, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, jarkko@kernel.org wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > The most trivial example of a race condition can be demonstrated with this
> > example where mm_list contains just one entry:
> > 
> > CPU A                   CPU B
> > sgx_release()
> >                         sgx_mmu_notifier_release()
> >                         list_del_rcu()
> > sgx_encl_release()
> >                         synchronize_srcu()
> > cleanup_srcu_struct()
> > 
> > To fix this, call synchronize_srcu() before checking whether mm_list is
> > empty in sgx_release().
> 
> Why haven't you included the splat that Haitao provided?  That would go a long
> way to helping answer Boris' question about exactly what is broken...

I've lost the klog.

/Jarkko
