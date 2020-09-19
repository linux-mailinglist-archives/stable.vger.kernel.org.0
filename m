Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C83D270953
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 02:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgISADt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 20:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISADt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 20:03:49 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D91D21D7B;
        Sat, 19 Sep 2020 00:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600473828;
        bh=oEBa36AVWkTR5WS0hFGxmPuS9UCLfzCx0uX7n3OmL40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fsP9RSFkTleWuPSduVxY6qlNLD5ArBqQUb1JK5arT7Uv7UyTKqL5AUNzl5t8gm4WW
         4O4v7Pw1nXZyG0L3WqDcsiupA2PlglXHlJOY8inZ/3vDUTJYxDzZVHpo5ZeWpWwAno
         0CZj1jNjRqriMN/Aov9YAhoZk9ZH+LnypkKcLn7Q=
Date:   Fri, 18 Sep 2020 19:09:25 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: use struct_size() and flex_array_size() helpers in
 kvm_io_bus_unregister_dev()
Message-ID: <20200919000925.GA23967@embeddedor>
References: <20200918120500.954436-1-rkovhaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918120500.954436-1-rkovhaev@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 05:05:00AM -0700, Rustam Kovhaev wrote:
> Make use of the struct_size() helper to avoid any potential type
> mistakes and protect against potential integer overflows
> Make use of the flex_array_size() helper to calculate the size of a
> flexible array member within an enclosing structure
> 
> Cc: stable@vger.kernel.org

I don't think this change applies for -stable.

> Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  virt/kvm/kvm_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf88233b819a..68edd25dcb11 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4350,10 +4350,10 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
>  			  GFP_KERNEL_ACCOUNT);
>  	if (new_bus) {
> -		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> +		memcpy(new_bus, bus, struct_size(bus, range, i));
>  		new_bus->dev_count--;
>  		memcpy(new_bus->range + i, bus->range + i + 1,
> -		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> +				flex_array_size(new_bus, range, new_bus->dev_count - i));
>  	} else {
>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
>  		for (j = 0; j < bus->dev_count; j++) {
> -- 
> 2.28.0
> 
