Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81414EA639
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 06:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiC2EBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 00:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiC2EBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 00:01:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82812527D2;
        Mon, 28 Mar 2022 21:00:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso1519453pjb.5;
        Mon, 28 Mar 2022 21:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OWkCUVTLbfq1NKmJxlJd/ysvs8c0KynadnvQjyOCC5g=;
        b=JcqQzWpACYUOsRdtG/Cwf7yk58Mj8nR9TJZUUL3wZZN3/1f06ZGseVQKPM2TzuUfHp
         2VK5FJQ8vwTUczxd2jXsNTSDEPTaetfudJhSnX+q81YAaJ0IaVlNd0YbhjSIN6aqgpgn
         ZL5TyNAul3QgM1oD/Wmwp//BL7p+jofYixi29S2KfyTt1yxGSgKOS9gwS3M6ucEZtRde
         OLqAGtVXVcDj9mC8xbw+zPPP+CY7kTGBV05fcfjC269kiymCcztifjjBqjbmLPJ0tHIL
         Ywlcfg6dgVyPthh9wtGsqlXyL5UKuWiHM9RrOuZPfttfdLmYeBTfW8QdG8a2A+Z3/SVm
         fbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OWkCUVTLbfq1NKmJxlJd/ysvs8c0KynadnvQjyOCC5g=;
        b=BR/etNHV1jvN1BiFEY7XcEdFqr8vyjG8g7TgZ+CoZNuJoOtBczc+y6B0jO99/H8QKY
         Y7UnATtq1YALAcosxI6tBulM2dx22GUxeQRkwhmcJp8rqvG5/VAxPI9jH6BZPf+Gzcry
         jr9WHP1Nieu+LfdbT2eNeMdP+TmxOaOxdhfK0MjB2L2a0ayNQ1cZ3ujfmpV9l6rPoOlj
         MFszSYq6gsEo8RFTEqtw6dOIBIQGnDNlBZiiKaj/JeSe3F4ouNHDp07pKJSWcwm0386p
         kbVcKnjQ9YIJYM1NoAzJvFTw/c/Sub+FRDw5vDnhfg1sCYd99y2uwSeqmcbtBmbfrCm2
         oPXQ==
X-Gm-Message-State: AOAM530Gt43S0s/Wbci4BPapmyDiFqIqiYatN0mbicHRsn4COIIFqS6v
        ED0LEVpQtO8nWFaeuUu720A=
X-Google-Smtp-Source: ABdhPJwzhFcoIqpDhSAdeWjElwphCYrligxbinbodOg7X8EPCgswUtct254Eh+qdq3/G2yU7VI+iaA==
X-Received: by 2002:a17:903:2352:b0:155:d4e8:12c6 with SMTP id c18-20020a170903235200b00155d4e812c6mr20837753plh.27.1648526411012;
        Mon, 28 Mar 2022 21:00:11 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id j14-20020a056a00174e00b004f776098715sm18250526pfc.68.2022.03.28.21.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 21:00:10 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     trondmy@hammerspace.com
Cc:     anna@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list iterator
Date:   Tue, 29 Mar 2022 12:00:02 +0800
Message-Id: <20220329040002.14484-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <c4af251c0b90180b187e8a328d4ce5b948db9fcd.camel@hammerspace.com>
References: <c4af251c0b90180b187e8a328d4ce5b948db9fcd.camel@hammerspace.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 13:24:57 +0000, Trond Myklebust wrote:
> Let's just do the following.
> 
> 8<-----------------------------------------------
> From 7c9d845f0612e5bcd23456a2ec43be8ac43458f1 Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date: Mon, 28 Mar 2022 08:36:34 -0400
> Subject: [PATCH] NFSv4/pNFS: Fix another issue with a list iterator pointing
>  to the head
> 
> In nfs4_callback_devicenotify(), if we don't find a matching entry for
> the deviceid, we're left with a pointer to 'struct nfs_server' that
> actually points to the list of super blocks associated with our struct
> nfs_client.
> Furthermore, even if we have a valid pointer, nothing pins the super
> block, and so the struct nfs_server could end up getting freed while
> we're using it.
> 
> Since all we want is a pointer to the struct pnfs_layoutdriver_type,
> let's skip all the iteration over super blocks, and just use APIs to
> find the layout driver directly.
> 
> Reported-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> ---
>  fs/nfs/callback_proc.c | 27 +++++++++------------------
>  fs/nfs/pnfs.c          | 11 +++++++++++
>  fs/nfs/pnfs.h          |  2 ++
>  3 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
> index 39d1ec870d90..c8520284dda7 100644
> --- a/fs/nfs/callback_proc.c
> +++ b/fs/nfs/callback_proc.c
> @@ -358,12 +358,11 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
>  				  struct cb_process_state *cps)
>  {
>  	struct cb_devicenotifyargs *args = argp;
> +	const struct pnfs_layoutdriver_type *ld = NULL;
>  	uint32_t i;
>  	__be32 res = 0;
> -	struct nfs_client *clp = cps->clp;
> -	struct nfs_server *server = NULL;
>  
> -	if (!clp) {
> +	if (!cps->clp) {
>  		res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
>  		goto out;
>  	}
> @@ -371,23 +370,15 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
>  	for (i = 0; i < args->ndevs; i++) {
>  		struct cb_devicenotifyitem *dev = &args->devs[i];
>  
> -		if (!server ||
> -		    server->pnfs_curr_ld->id != dev->cbd_layout_type) {
> -			rcu_read_lock();
> -			list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link)
> -				if (server->pnfs_curr_ld &&
> -				    server->pnfs_curr_ld->id == dev->cbd_layout_type) {
> -					rcu_read_unlock();
> -					goto found;
> -				}
> -			rcu_read_unlock();
> -			continue;
> +		if (!ld || ld->id != dev->cbd_layout_type) {
> +			pnfs_put_layoutdriver(ld);
> +			ld = pnfs_find_layoutdriver(dev->cbd_layout_type);
> +			if (!ld)
> +				continue;
>  		}
> -
> -	found:
> -		nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id);
> +		nfs4_delete_deviceid(ld, cps->clp, &dev->cbd_dev_id);
>  	}
> -
> +	pnfs_put_layoutdriver(ld);
>  out:
>  	kfree(args->devs);
>  	return res;
> diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
> index de318bb5d349..856c962273c7 100644
> --- a/fs/nfs/pnfs.c
> +++ b/fs/nfs/pnfs.c
> @@ -92,6 +92,17 @@ find_pnfs_driver(u32 id)
>  	return local;
>  }
>  
> +const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id)
> +{
> +	return find_pnfs_driver(id);
> +}
> +
> +void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld)
> +{
> +	if (ld)
> +		module_put(ld->owner);
> +}
> +
>  void
>  unset_pnfs_layoutdriver(struct nfs_server *nfss)
>  {
> diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
> index f4d7548d67b2..07f11489e4e9 100644
> --- a/fs/nfs/pnfs.h
> +++ b/fs/nfs/pnfs.h
> @@ -234,6 +234,8 @@ struct pnfs_devicelist {
>  
>  extern int pnfs_register_layoutdriver(struct pnfs_layoutdriver_type *);
>  extern void pnfs_unregister_layoutdriver(struct pnfs_layoutdriver_type *);
> +extern const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id);
> +extern void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld);
>  
>  /* nfs4proc.c */
>  extern size_t max_response_pages(struct nfs_server *server);
> -- 

Thank you, i have resend a PATCH v2 with fix as you suggested, and also with
some changes, please check it.

--
Xiaomeng Tong
