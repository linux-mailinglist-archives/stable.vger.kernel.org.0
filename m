Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9794473E2
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 17:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhKGQsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 11:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhKGQsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 11:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 600716105A;
        Sun,  7 Nov 2021 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636303537;
        bh=ikEqkWoGV0ZZ05Cxs8H6ZUvViZmPvoGfggCdVVdXbo4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SDgq5+4oPQhSMUwCFFUf8R3og8CKaj6wDxgDXYeHlEXK0566GfNdtaT4gLwlChX4h
         uWcxDlXIIFGSuAgXYROWl6mR/GkEpv4j9vh1y2W4HIqpGuMtediBry2fH9wNHDzSag
         jB/eRAJFkl8JwrALWZsRbw/u4LjVxmMZx3HvS6XRlpDieTQO0O0LPA0uHQ5XuRKgRN
         T5fpHfZK0sOzW4uIXxj3I4T0SyZR4jY8iYX63hUJGtvpX+HRYPeDj5Zwtw//EvOkSC
         SAHcmh/LT6gcpCcpW0oMjqf+3xE04GqJ3EtjJONlQsId/0Tl7rIFSd01eMGecoi/ct
         V4theHKdNimlA==
Message-ID: <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Sun, 07 Nov 2021 18:45:35 +0200
In-Reply-To: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
> The consequence of sgx_nr_free_pages not being protected is that
> its value may not accurately reflect the actual number of free
> pages on the system, impacting the availability of free pages in
> support of many flows. The problematic scenario is when the
> reclaimer never runs because it believes there to be sufficient
> free pages while any attempt to allocate a page fails because there
> are no free pages available. The worst scenario observed was a
> user space hang because of repeated page faults caused by
> no free pages ever made available.

Can you go in detail with the "concrete scenario" in the commit
message? It does not have to describe all the possible scenarios
but at least one sequence of events.

/Jarkko

