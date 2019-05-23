Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F1628071
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 17:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfEWPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 11:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbfEWPCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 11:02:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7638317917D;
        Thu, 23 May 2019 15:02:42 +0000 (UTC)
Received: from [10.10.66.2] (ovpn-66-2.rdu2.redhat.com [10.10.66.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D54187D59D;
        Thu, 23 May 2019 15:02:40 +0000 (UTC)
From:   "Benjamin Coddington" <bcodding@redhat.com>
To:     "Sasha Levin" <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Roberto Bergantinos Corpas" <rbergant@redhat.com>,
        "Anna Schumaker" <Anna.Schumaker@Netapp.com>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 004/375] NFS: make nfs_match_client killable
Date:   Thu, 23 May 2019 11:02:39 -0400
Message-ID: <E7EBFAFD-D312-4EBA-970B-54F07EDD1F9D@redhat.com>
In-Reply-To: <20190522192115.22666-4-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 23 May 2019 15:02:47 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,  if you take this one, you'll need the fix for it:

c260121a97a3 ("NFS: Fix a double unlock from nfs_match,get_client")

I didn't see this fix go through my inbox for your stable tree, so 
apologies if maybe I missed it.

Looks like you are also applying this one to 4.19 and 4.14, -- I'll just 
reply once here.

Ben

On 22 May 2019, at 15:15, Sasha Levin wrote:

> From: Roberto Bergantinos Corpas <rbergant@redhat.com>
>
> [ Upstream commit 950a578c6128c2886e295b9c7ecb0b6b22fcc92b ]
>
>     Actually we don't do anything with return value from
>     nfs_wait_client_init_complete in nfs_match_client, as a
>     consequence if we get a fatal signal and client is not
>     fully initialised, we'll loop to "again" label
>
>     This has been proven to cause soft lockups on some scenarios
>     (no-carrier but configured network interfaces)
>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/nfs/client.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index 90d71fda65cec..350cfa561e0e8 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -284,6 +284,7 @@ static struct nfs_client *nfs_match_client(const 
> struct nfs_client_initdata *dat
>  	struct nfs_client *clp;
>  	const struct sockaddr *sap = data->addr;
>  	struct nfs_net *nn = net_generic(data->net, nfs_net_id);
> +	int error;
>
>  again:
>  	list_for_each_entry(clp, &nn->nfs_client_list, cl_share_link) {
> @@ -296,8 +297,10 @@ static struct nfs_client *nfs_match_client(const 
> struct nfs_client_initdata *dat
>  		if (clp->cl_cons_state > NFS_CS_READY) {
>  			refcount_inc(&clp->cl_count);
>  			spin_unlock(&nn->nfs_client_lock);
> -			nfs_wait_client_init_complete(clp);
> +			error = nfs_wait_client_init_complete(clp);
>  			nfs_put_client(clp);
> +			if (error < 0)
> +				return ERR_PTR(error);
>  			spin_lock(&nn->nfs_client_lock);
>  			goto again;
>  		}
> @@ -407,6 +410,8 @@ struct nfs_client *nfs_get_client(const struct 
> nfs_client_initdata *cl_init)
>  		clp = nfs_match_client(cl_init);
>  		if (clp) {
>  			spin_unlock(&nn->nfs_client_lock);
> +			if (IS_ERR(clp))
> +				return clp;
>  			if (new)
>  				new->rpc_ops->free_client(new);
>  			return nfs_found_client(cl_init, clp);
> -- 
> 2.20.1
