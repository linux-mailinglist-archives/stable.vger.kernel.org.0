Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A763480DF5
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 00:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhL1Xrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 18:47:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56638 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhL1Xrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 18:47:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF516133B;
        Tue, 28 Dec 2021 23:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58377C36AE9;
        Tue, 28 Dec 2021 23:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640735267;
        bh=LHIXNAdfwq97zcaRsOz+4HTvnLDnN9j47uVZHM7bfHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYbplg1jixQsb4MoZdHkhPfOnr+aavZbT9IWG7G9fL5YbYRHIKxf01IVR0UboSihV
         PG9eAXVldwe3DWe+rm55VmewM25i/vpIXpfUj7wliwlsicKzns8TVZxWYKaBEpLdtJ
         6P7iRL/RrQGqWZrRXBleUMWtZRzcEaL/CKaJyXUq+8ppTzkIijxPZymo8e7bZQ0yxc
         jsubL6LJJMKijW8Aa2obvcsTHSepxnqnWuGTwDndgszbJ88I4F4+KExIJjNd1hgyOF
         Keqg4aQDLN2kG+S0z1sBbuKNIVI65dlhwPRF99YcmaZeVKoQTlTMEJLFDBptaichyA
         /hvs1MMYAvRDQ==
Date:   Wed, 29 Dec 2021 01:47:45 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tstruk@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm: Fix error handling in async work
Message-ID: <YcuiIdorMLEjhJn6@iki.fi>
References: <20211220211700.5772-1-tstruk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220211700.5772-1-tstruk@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 01:16:59PM -0800, Tadeusz Struk wrote:
> When an invalid (non exitsinting) handle is used in a tpm command,
> that uses the resource manager interface (/dev/tpmrm0) the resource
> manager tries to load it from its internal cache, but fails and
> returns an -EINVAL error to the caller. The existing async handler
> doesn't handle these error cases currently and the condition in the
> poll handler never returns mask with EPOLLIN set causing the userspace
> code to get stack. Make sure that error conditions also contribute
> to the poll mask so that a correct error code could passed back
> to the caller.

Can you instead describe a failure scenario? This is very cryptic.

/Jarkko
