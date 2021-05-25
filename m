Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A461E390D0C
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 01:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEYXun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 19:50:43 -0400
Received: from mout.gmx.net ([212.227.15.15]:59885 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhEYXun (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 19:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621986550;
        bh=7sjtfNUVqZ+W1lJRsSA2Ok5ARxoqncFwhXIMsik8uTs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LC8z6EC41ecd0bKEt0aq/Zr0lr+lTzAEVs6oLYH/zCvDG/Bx0xVb1pNFyiAD4NWoo
         5RY6K/LC0zRmMoFB5sY8f8V8bZjTZEt2iKVOuEGBVhSDvIk43Snvsdsu4Tfw078PuJ
         GwqMpBfB1Dzx2KzgC5flEhlRxEFohiGoVpwOczgA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MgeoI-1lDSR70omq-00h78a; Wed, 26
 May 2021 01:49:10 +0200
Subject: Re: [PATCH 2/9] btrfs: clear defrag status of a root if starting
 transaction fails
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1621961965.git.dsterba@suse.com>
 <183259751d20f64fa45dab806b7083923e718ceb.1621961965.git.dsterba@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cda66879-c558-f683-4734-aa50c7cc49a6@gmx.com>
Date:   Wed, 26 May 2021 07:49:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <183259751d20f64fa45dab806b7083923e718ceb.1621961965.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PTH8Xhi2kzOXd0o6BaIk9PbaWw1ItJG1mjgNJKll0SAVhusy1K4
 ZtYNuAHO4EDgF7EtwvPPz47hzfVPtkBq7sjVZ8ldU3QPSsgiomcNFeXnQj7AC9jJYMTeXyL
 qzku1JvCNZgt/K0GRVpdyka/os4UDJMUOdPUNk7YsfiInp3d2BwInphHdYDM8AgpWv4QwdP
 TUtWj15neFUdsChg29Hng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dTl8AV6YUks=:4fDoZIgvHDtlEVdrv4r+72
 ruRuLTR5uDxveMyD+vQIy8YcIFyxKj185e32TDKRl+gXth9hbhIwGx4ciPXme2dycKIwkHt2l
 08KDMp2gtiQzvl3N6GH4T546AnlL7GfQlhzLuWX3twq13O5uUNHU+scSpTYBhdnj8Z3ejB6H1
 lVKv4npcsJh81uGQtTUEws3ykrpw6FuGp3seZRIcRVxp4fLH3P3iwZHB5n0ZcTi2G4cC9iFai
 NYfOQXD5GjR1Et+YFyCx3e0EpzVDNEBModLrHt8n8y7679RZjdkiOnBLGCaIGTcYNEgz/eBCa
 jDsaC6vwNcy8GN/Bd6atQQFrmfDU/E/82ZqNxkUT7eay4WnQgrIy/BqFnbPe3ExUPVqkVEfdg
 weyTuhic6Wgc0ATp5IefNkAc3JL9Y3XE7Ft2S8oGxN8AvE8wt42c+WXyV1zLJhzKfKIGVq/Gn
 fQj24w7F6gIf/MEcONzRI4cyfx4bSCCi7wdqVV8LX+gPVi6Sm6olM0KwBRFvXzCfJ4UTA7J7x
 wqafQvxtD08LFwrRpjLgLMH7L/u3fDjHj6VLicY9qR56F3pEfrCIJtcOh7yl74ho7a0mw6PcH
 7GRWNO43kNBU6x3uRxLAzxj2GAiaAGx/G3/EMOEcy7u9v0MBcoG1Gxh17fcNf5JLcHrGfnHmW
 NZgmeWjURFSLfCNdBRU7u+RjGx3tCyVKzIVBZV3wJpx/La2oJ4x23KmGpdjNWiyyphPhXkyj0
 Q052Zr4gNyzuvCaUV0YB6nFPWyo+ebaoGucB0Xr23zcydJXATQKCCkTwbmX51wLJsGpH9HdhH
 4FkgsePxGtifAJ9c3q3fb8Q2TeHKTVFM2SeJRMGWOxrqhfxzLgBQRdLLhph2JYGSSwekMsSt7
 DFmzREXLmAm+hSh+4W9+xipesUXSRJ0sNgOsh3wMM4hv7S58ZzmFKWvj5KlVVIueTgF7Tr/kc
 NiU+FsFS7/xn2SKdjLczkIEEgH2I/bYAPrhYrtV7Q1LlOR5ycAtHeietwpAwu0hLphv701rnp
 Jw8Lc4Ztvh9I0Qpu0l+auV0OddFzzOIyf+1xoMMPTpS6UVAbaa7P1oO0ZLrh7MN2gpoxGMhqO
 SL89EJk77/TE9nUEdOMrSk8IXMY+EoXYv90OYPDsa3ZopWuZvXRneGyVsD72W+X3HyMzUNw3e
 3ay+eeNEc1uusDAwLhNUxRpM+Z6CpRNvJWsuw9XH+2o47U2iOWwEmiRrutN72I90uzLKbG4pz
 gKYiucXGazN/4RN9j
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/5/26 =E4=B8=8A=E5=8D=881:08, David Sterba wrote:
> The defrag loop processes leaves in batches and starting transaction for
> each. The whole defragmentation on a given root is protected by a bit
> but in case the transaction fails, the bit is not cleared
>
> In case the transaction fails the bit would prevent starting
> defragmentation again, so make sure it's cleared.
>
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/transaction.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index e0a82aa7da89..22951621363f 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1406,8 +1406,10 @@ int btrfs_defrag_root(struct btrfs_root *root)
>
>   	while (1) {
>   		trans =3D btrfs_start_transaction(root, 0);
> -		if (IS_ERR(trans))
> -			return PTR_ERR(trans);
> +		if (IS_ERR(trans)) {
> +			ret =3D PTR_ERR(trans);
> +			break;
> +		}
>
>   		ret =3D btrfs_defrag_leaves(trans, root);
>
>
