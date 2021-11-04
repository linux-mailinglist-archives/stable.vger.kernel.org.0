Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA044560A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKDPML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhKDPMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02F9161216;
        Thu,  4 Nov 2021 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636038572;
        bh=2u485jVlBR+MjS7kkrhnaG+oRtQ8qBeh9FL711O0mcY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SJXObTaGYfMXJRGWEyYm/Mjepvm2+J4fNvEEq97mXfcbX11gQPrRAWNnso5BOry2x
         BlZn+WYh8faZpH0fYCXYM9Px7Z9TviGcsZ3B+hmVAT2FFKE9J9XPHB6A79oe+3aUjf
         LaQn80lQJ79xry13xm2JAHkvVvuJeY/6t6ktcaNBjPeAgMgSXWi89w3yxtSkEjYkVT
         dsWw9x8j65ONCc3yznUZ4eLvrQ8kfZo5wk99kU5rzNkFG3mX+5Vk1zwUw+c0aPz+HC
         ZycyUNRKPYgxnfe7efqvIslROClzhEbb4QcXU6mpuKlfbe3oV1wTdZxFFQjESL8VSa
         4cXTiWWd2+R5w==
Message-ID: <70894c6b668dbfc3cc76c3b858c293b9f3a8446e.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Nov 2021 17:09:29 +0200
In-Reply-To: <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
References: <20211103232238.110557-1-jarkko@kernel.org>
         <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
         <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-11-04 at 17:04 +0200, Jarkko Sakkinen wrote:
> This can be achieved by iterating through all of the enclave pages,
> which share the same shmem page for storing their PCMD's, as the one
> being faulted back. If none of those pages is swapped, the PCMD page can
> safely truncated.

We have bookkeeping in place for this: encl->page_array.

/Jarkko

