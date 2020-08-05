Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E790A23D1AF
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgHEUFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgHEQge (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5522313E;
        Wed,  5 Aug 2020 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596638069;
        bh=gDP4cNqSVT6Y18LAsqey+eKbm0Unv/hgfGjP95S5Eik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1R1euXRY6Zz0q5Rlbv0hbqXsHAaYISrTkhQXsGeeuWtfTBpae74z/GYpgDhHEyT3R
         dqvSiM0QHAPhpdurv8I1b617s+qeRrMvPCFZWNM1VqrONI6+OYFKE6h0zg9vRmGPBP
         tW+NhV2t4wBJShDe8uD+Mz+hOqG+Mxiom8CqfRbo=
Date:   Wed, 5 Aug 2020 16:34:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH stable-5.4.y] bpf: sockmap: Require attach_bpf_fd when
 detaching a program
Message-ID: <20200805143446.GE2154236@kroah.com>
References: <20200804084747.42530-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804084747.42530-1-lmb@cloudflare.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 09:47:47AM +0100, Lorenz Bauer wrote:
> commit bb0de3131f4c60a9bf976681e0fe4d1e55c7a821 upstream.
> 
> The sockmap code currently ignores the value of attach_bpf_fd when
> detaching a program. This is contrary to the usual behaviour of
> checking that attach_bpf_fd represents the currently attached
> program.
> 
> Ensure that attach_bpf_fd is indeed the currently attached
> program. It turns out that all sockmap selftests already do this,
> which indicates that this is unlikely to cause breakage.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20200629095630.7933-5-lmb@cloudflare.com
> ---
> The 5.4 tree needs a dedicated backport, since some headers have
> changed sufficiently to cause the patch to fail. bpf_prog_detach
> needs further massaging to pass the correct program type to
> sock_map_prog_detach. Please queue this patch together with
> commit f43cb0d672aa ("selftests: bpf: Fix detach from sockmap tests").

Thanks for the backport, now queued up.

greg k-h
