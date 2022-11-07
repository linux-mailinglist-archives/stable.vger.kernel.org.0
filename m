Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD6661F0EA
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 11:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiKGKii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 05:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKGKig (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 05:38:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536C013F4A;
        Mon,  7 Nov 2022 02:38:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 02FC1225CC;
        Mon,  7 Nov 2022 10:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667817514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbeLfyJky1v75oriim4ZYh1QFlLi4n3gXIRyn58KfE0=;
        b=G4bEtaCFSEmDzZH8kFWz904DG9xHbhn/UgL49GHrA6aTbchXxGDHDdEGSD9QIzp1bl2npF
        hsP85iylJ38kskzCPXWWEc+XBblClRYcBQrWM9Ysb056JMI8rEprlEgrzEIpm/68UMh/vU
        lGGDP/zy1VPmFy/9+HTpNoLrGK8vz7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667817514;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbeLfyJky1v75oriim4ZYh1QFlLi4n3gXIRyn58KfE0=;
        b=sOBxIjC2k5/jxTWuhgV/xApjsEBChpiY8zFoP0OsA2QQRRWmEz/n5fKzPlx9KZKmyKZIcM
        f2S2fIoOha3veeCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8290E13494;
        Mon,  7 Nov 2022 10:38:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R9TcHCngaGPfdQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 07 Nov 2022 10:38:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 3164be64;
        Mon, 7 Nov 2022 10:39:35 +0000 (UTC)
Date:   Mon, 7 Nov 2022 10:39:35 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ceph: avoid putting the realm twice when docoding snaps
 fails
Message-ID: <Y2jgZ52dV+TzWhlQ@suse.de>
References: <20221107071759.32000-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221107071759.32000-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 03:17:59PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When decoding the snaps fails it maybe leaving the 'first_realm'
> and 'realm' pointing to the same snaprealm memory. And then it'll
> put it twice and could cause random use-after-free, BUG_ON, etc
> issues.
> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..baf17df05107 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	if (realm_to_rebuild && p >= e)
>  		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>  
> -	if (!first_realm)
> +	if (!first_realm) {
>  		first_realm = realm;
> -	else
> +		realm = NULL;
> +	} else {
>  		ceph_put_snap_realm(mdsc, realm);
> +	}
>  
>  	if (p < e)
>  		goto more;
> -- 
> 2.31.1
> 

This patch looks correct to me.  But I wonder if there's a deeper problem
there (probably not on the kernel client).  Because the other question is:
why are we failing to decode the snaps?  But I guess this fix is worth it
anyway.

Reviewed-by: Luís Henriques <lhenriques@suse.de>


Cheers,
--
Luís
