Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A413E444E
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhHIK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhHIK77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 06:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A79F060C3E;
        Mon,  9 Aug 2021 10:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628506779;
        bh=IV7WNfw0xGJP+oC24iUpdWysTHr82ErX2hhD3BRyng4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tNg0bqUqw3I8rZxTYxvRB6wM0/bsxBdQ3JLA9fnd6J3neSzYV6ikcu3rd85OJRgU2
         SzRsKa7A+ezKsLLHWo13iVv4R9grOrJz1FrzfE3PB4K2O6ZeD5nMt7hdHmaZG/IcXB
         RdelB+JpeYlmbMfu+U3OJaMmzhN4h9DheiLFEGLE=
Date:   Mon, 9 Aug 2021 12:59:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Sasha Levin <sashal@kernel.org>, Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: vdso: Avoid ISB after reading from cntvct_el0
Message-ID: <YREKmIjDO6EfDx3z@kroah.com>
References: <CGME20210809104221epcas2p32224190e0e8fd461c28076f4f4451cef@epcas2p3.samsung.com>
 <20210809104450.114771-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809104450.114771-1-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 07:44:50PM +0900, Chanho Park wrote:
> From: Will Deacon <will@kernel.org>
> 
> commit 77ec462536a13d4b428a1eead725c4818a49f0b1 upstream.
> (The upstream patch was not marked as fixed but this can fix
> Fixes: 28b1a824a4f4 ("arm64: vdso: Substitute gettimeofday() with C implementation")
> sysbench memory comparison:
> - Before: 3072.00 MB transferred (2601.11 MB/sec)
> - After:  3072.00 MB transferred (3217.86 MB/sec)
> )
> 
> We can avoid the expensive ISB instruction after reading the counter in
> the vDSO gettime functions by creating a fake address hazard against a
> dummy stack read, just like we do inside the kernel.
> 
> Fixes: 28b1a824a4f4 ("arm64: vdso: Substitute gettimeofday() with C implementation")
> Signed-off-by: Will Deacon <will@kernel.org>
> Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Link: https://lore.kernel.org/r/20210318170738.7756-5-will@kernel.org
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
> I found this regression while executing below sysbench benchmark command.
> It showed lower score compared with internal 4.19 version. The
> regression can be seen from 5.4/5.10 kernel version.

Now queued up, thanks.

greg k-h
