Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3D844D027
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhKKC6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhKKC6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:58:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F0AD6103C;
        Thu, 11 Nov 2021 02:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636599316;
        bh=atxczb/M0ONR08OuoKea1OCi+2gc/bRkfsLdlJ0nmDE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V0oSFPo9DbOlvlOYaloWsm/FbpJSCA2+P8W6xp49nVXQvFJpkQFDuDXf5E+XR3aMD
         S5Nk0XUVc8+3iNKQQHJYWwYULUkehUAiLQQ93yfjVQTgcaQaOhmW4UkMX0CBvck2Of
         SNVC0rdaNQ4PAgfJOUM23zt/4qYxcSWIHWAkiml6z0x7KQBdtSgDvXCKjBuDcGqeP1
         ube6bGqkUL7mM1/a1VwIze154veXq27ye7jM/U4cQzI05T3x6mzvX3t7QmRzvumNh3
         cHczocvrwKxiZKRweRykqVQfTeBPPVl7FYFBNEyCcG+gcWdGSwV40/7RZY8jj4lNli
         gRu6LfOH7E9gQ==
Message-ID: <94df4c660532a6bf414b6bbd8e25c3ea2e4eda5b.camel@kernel.org>
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 11 Nov 2021 04:55:14 +0200
In-Reply-To: <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
         <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
         <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-11-10 at 10:51 -0800, Reinette Chatre wrote:
> sgx_should_reclaim() would only succeed when sgx_nr_free_pages goes=20
> below the watermark. Once sgx_nr_free_pages becomes corrupted there is=
=20
> no clear way in which it can correct itself since it is only ever=20
> incremented or decremented.

So one scenario would be:

1. CPU A does a READ of sgx_nr_free_pages.
2. CPU B does a READ of sgx_nr_free_pages.
3. CPU A does a STORE of sgx_nr_free_pages.
4. CPU B does a STORE of sgx_nr_free_pages.

?

That does corrupt the value, yes, but I don't see anything like this
in the commit message, so I'll have to check.

I think the commit message is lacking a concurrency scenario, and the
current transcripts are a bit useless.

/Jarkko

