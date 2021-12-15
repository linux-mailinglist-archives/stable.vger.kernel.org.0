Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD484759C0
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhLONec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:34:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbhLONec (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:34:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A4DDB81F21
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B65C34604;
        Wed, 15 Dec 2021 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639575270;
        bh=ITsO7SL5JpsTPWKvZdm6TLbITnlTpq5vVeQrrn1IVeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFRN6GicZfMj1gzZO51J9hs5C0uYMZOWj7uBM+mc3PstU3iASlcO1SuEUwcmoIH3A
         t9nsuyyk4ecrE1gCw4/L0kt3Q+xAhr9MNy7t0oNvJ8f0xfonDSoCidhQxhI/3oKig1
         b7aHMF8ci34xA3kaOBUKJ6/TIVgZ+fPIQKI9Xw1A=
Date:   Wed, 15 Dec 2021 14:34:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Connor O'Brien <connoro@google.com>
Cc:     stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH] bpf: Fix integer overflow in argument calculation for
 bpf_map_area_alloc
Message-ID: <Ybnu4weOY6yMK/pD@kroah.com>
References: <20211215020139.126521-1-connoro@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215020139.126521-1-connoro@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 02:01:39AM +0000, Connor O'Brien wrote:
> From: Bui Quang Minh <minhquangbui99@gmail.com>
> 
> commit 7dd5d437c258bbf4cc15b35229e5208b87b8b4e0 upstream.
> 
> In 32-bit architecture, the result of sizeof() is a 32-bit integer so
> the expression becomes the multiplication between 2 32-bit integer which
> can potentially leads to integer overflow. As a result,
> bpf_map_area_alloc() allocates less memory than needed.
> 
> Fix this by casting 1 operand to u64.
> 
> Fixes: 0d2c4f964050 ("bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps")
> Fixes: 99c51064fb06 ("devmap: Use bpf_map_area_alloc() for allocating hash buckets")
> Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20210613143440.71975-1-minhquangbui99@gmail.com
> Signed-off-by: Connor O'Brien <connoro@google.com>
> ---
> Hello,
> 
> This is for the 5.4 and 5.10 kernels.

Now queued up, thanks.

greg k-h
