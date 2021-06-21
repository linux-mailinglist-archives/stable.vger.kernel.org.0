Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8A93AE14E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 03:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFUBgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 21:36:01 -0400
Received: from mout.gmx.net ([212.227.15.18]:58559 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhFUBgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Jun 2021 21:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1624239222;
        bh=iM9D/+0Yrt9eVXTASL66BsWz34bYlt1kCDTYfG36Hx8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=e+zBsF3Tf7CvPZxdJ/i7PiP1ehNRwYHZDHuMehjn5Okkz/TvqkWBYlw7fuesCD4QV
         rpzcyiEGDiqUihWmBPvC8bnz9UQGyEpSTsDgm2r0OjxFCgbq64tr/GdHQ5WZuHiUY8
         itma32xy4nwogaqcoclx/+39DPPf7pInT1WKsKb4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M8QWA-1lzYf80KNk-004Sd5; Mon, 21
 Jun 2021 03:33:42 +0200
Subject: Re: [PATCH] btrfs: fix unbalanced unlock in qgroup_account_snapshot()
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable <stable@vger.kernel.org>
References: <20210621012114.1884779-1-naohiro.aota@wdc.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1f926610-8620-c736-f338-8acc7d45e8a7@gmx.com>
Date:   Mon, 21 Jun 2021 09:33:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621012114.1884779-1-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BhqnwfZxJVhyeVcAFHQwawO7pUqkn3thylp0O0WQJyNSHNCsavd
 wxjW0QP03vWBkxp7SMB4M1EadYxbtg8u5UBClPkjOtRyZPcW7EqgTwmtBZ5c94ZNkOtqKUu
 RvOFTDhQ2N0jadYzR1HyJiY7foRTbMIMygDVK3Af7qUuIyAw+UKqUDQ14mScTDVwGniFbjd
 i67x56lOj+l2QZMwTSKbw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LR1VrEYHWuc=:atfGrjWZ1rIRYtjsQbC6wX
 tYnt2cXpV0PnIcKeSqXbR5HvzTyohE5JBH8fnC6SmmcOkDBP9JOOIVPz5FPKSaQsONwhwmbOh
 RUZfH3E5K5f9HvuKBLQY9H/ZsoCLpG5liORFjXD5ksp0qYzZXVId1/lH+Ulf1ABk8ykFPFcUv
 abgH6NBtLTNtnlCwPSv27cVVOXNQRe3IhgkA87+Oor0EJSHLBJWxfsd5qzZMhpLyRprxUjgUI
 4nbtwL3F85AjmwL762sWn8UQVMIBY7S/xPeFOULQ06wmJTqIIBhV+i94Rg4JqmqSindO0jYJ6
 s689dMbrtBY86ggh6QWsrDbM5IXnTOBVe/kUuHKCYO1SyBU5oJLXRllf6VkTd7o2oRonzDsRq
 ph0SSnTqVfbAH8nOc8WwfU+VmTnA1YgFxDhLpg7gxlpozkXQoe00eLXJLRRI+uDN8d9aP6E9d
 jnOz2hgJ9ZbuGBy4bZHucXXMG1XkatNyAR+vL4rNzURfCqfRHj4wD47A0RfYFcn9ZFIOggzK9
 UTjSzfzLLb2O0TXNzmPW9dsFWOd/9MJJghYjg06k6GqPVjfhE1MJ/31ykTNF88fCKtDh+JqjB
 1c+rEjQLNrLCGptCJj60djtp4A2RdYtDhrBPNrG9dxjlCK4XbmHazTIE3Oj/oKLTYkRnMs1JW
 Z9Yih8X4dydtrW1oAAkvQaoWn+PDPXQNd1Q98iTNra+/Goxn+AKQKISELvUStQvfzyFFc/1lc
 5i6iZdiQVXmio9LtvRGUzGl1agB5YmqrjaZfG1L3wx4Hq/AVxzopOtHpIXvBJiUuxmdvdb4ms
 /wOwdq6kH3adQTFwg63ketvfaNDOGqFqhhqrAaCg5JUbfBQLiQtbzNrDtVg2rkVZH7qADF8rr
 1r+zuT2DUqJbNrh9FjPw2/zb/ezkyM3lO+CA0xyxXD+RDCzw1Yt6C+7AyFFt0bC/IrsH5zawj
 osNlf82wQX6wxaKEThkxuUekLN8gO/lp4zqNmJFygb6WsWgncB8kdq8Xoh4ukOfOCJ7MVrqji
 VF7fjhrlHgM11UOonjED4l7uG2aEtyVhfE+c1+GOvzZuARFE5KOIbPd5SnaI55Ikyl5641Yvl
 rgHacxXZlkD/TL5yq0un30Drj0bcdFulMQkiItzuWVQOaqm3kIK5V1Paw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/6/21 =E4=B8=8A=E5=8D=889:21, Naohiro Aota wrote:
> qgroup_account_snapshot() is trying to unlock the not taken
> tree_log_mutex in a error path. Since ret !=3D 0 in this case, we can
> just return from here.
>
> Fixes: 2a4d84c11a87 ("btrfs: move delayed ref flushing for qgroup into q=
group helper")
> Cc: stable <stable@vger.kernel.org> # 5.12
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/transaction.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index f75de9f6c0ad..6aca64cf77dc 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1476,7 +1476,7 @@ static int qgroup_account_snapshot(struct btrfs_tr=
ans_handle *trans,
>   	ret =3D btrfs_run_delayed_refs(trans, (unsigned long)-1);
>   	if (ret) {
>   		btrfs_abort_transaction(trans, ret);
> -		goto out;
> +		return ret;
>   	}
>
>   	/*
>
