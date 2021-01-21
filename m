Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3222FDE36
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 01:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbhAUAxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 19:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390733AbhAUA1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 19:27:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14A052360D;
        Thu, 21 Jan 2021 00:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611188822;
        bh=MSfZCiK9RQFqZDpp5Yh8bHp6v47xml7viuNEpHIbXdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZ8uuqxQg5lJlJWSYDjs/DCnftdty8gqIkD7M9LxQYlwp30SruxajfYtxuUQfbFyf
         wWsaTixyiFw2vNR92CqWgDWthkZt8nfaFUoUY8+X/mMbwOEApySeUeYly/7dm0H/1V
         20TrVO4XA9zG5m47UbdZK8I3vBADovHdCPXYRQPsiWLIXyED0hFCJm6XFvDbLUpA0W
         Vu3S1vcigXuJJ0OoO7yRwrDOFei3mMG+Jv4VC6xxRtQfXkD4024flOQxCOWsTJfWg4
         t0Ed+kYh4gcfBtu34X+C3Dd4d8iWW6XUjtw7URQwD2qHo0jWiKiv1uXvcbyRGlijR+
         bm8F0Y2JqUQBg==
Date:   Thu, 21 Jan 2021 02:26:56 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAjKUO+nI2pJs1HD@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <20210115071809.GA9138@zn.tnic>
 <YAJ11v5tuS2uMuNm@kernel.org>
 <20210118185712.GE30090@zn.tnic>
 <YAhBeaItbqYmf0oF@kernel.org>
 <bb46fd98-0f67-76a7-9ba9-3a646c2a8f84@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb46fd98-0f67-76a7-9ba9-3a646c2a8f84@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 09:34:10AM -0800, Dave Hansen wrote:
> On 1/20/21 6:43 AM, Jarkko Sakkinen wrote:
> >> So why do you need the synchronize_srcu() call when this process sees an
> >> empty mm_list already?
> >>
> >> Thx.
> > The other process aka some process using the enclave calls list_del_rcu()
> > (and synchronize_srcu()), which starts a new grace period. If we don't
> > do it, then the cleanup_srcu() will race with that grace period.
> 
> To me, this is only a partial explanation.
> 
> That goal of synchronize_srcu() is to wait for the completion of a
> *previous* grace period: one that might have observed the old state of
> the list.
> 
> Could you explain the *actual* effects of the misplaced
> synchronize_srcu()?  If the race _occurs_, what is the side-effect?

As I haven't been able to reproduce this regression myself, I need
to take steps back and try to reproduce the it with Graphene.

WARN_ON()'s trigger inside cleanup_srcu_struct(), which causes a memory
leak since free_percpu() gets never called. If I recall correctly, it
was srcu_readers_active() but unfortunately I don't have a log available.

Perhaps Haitao could provide us one.

/Jarkko
