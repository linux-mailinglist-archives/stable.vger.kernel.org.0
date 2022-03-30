Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2EA4EC93D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348591AbiC3QGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245352AbiC3QGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:06:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3655238D30;
        Wed, 30 Mar 2022 09:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8549B61773;
        Wed, 30 Mar 2022 16:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955C6C340EC;
        Wed, 30 Mar 2022 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648656294;
        bh=SgjhWVJpkYUealo7YVxtMaf9+1We6QkbgJfT05eWG9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/CBu2B+ZaBcm1qbcCKFoSEuNQz5F58uclL4ZNf3MtXuifcgcMKdDb2dLzkAqExgP
         HgYoyHiYSZnqDH8WfrI322KgbFkujKSlitt2YwIpBSZqm7OUyVdGRI2Qp/ZQTlR812
         lho5Y8Tf1YtW510S/hFK/bN7WIFg61aWiMgi8TMP+y7Ko1VFGv1uOWxq/ZCppzLFrd
         IDL1pheFLn99KK7WvgPYt0QMNsijG2uzj7tN5ALRShGY+Kc7m5q8SoMPji4H/t2Twe
         IQp5wHjn+A0XRxnKiFne4Gj0+YQyuodpe7bbWJ3o46aIXWZTtnAZdz9DTcwOfbhWZ9
         BO1vpBiLO4VZw==
Date:   Wed, 30 Mar 2022 18:04:48 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/19] exportfs: support idmapped mounts
Message-ID: <20220330160448.bugfza2akk3zsici@wittgenstein>
References: <20220330102409.1290850-1-brauner@kernel.org>
 <20220330102409.1290850-3-brauner@kernel.org>
 <20220330152635.GB4835@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220330152635.GB4835@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 05:26:35PM +0200, Christoph Hellwig wrote:
> On Wed, Mar 30, 2022 at 12:23:50PM +0200, Christian Brauner wrote:
> > Make the two locations where exportfs helpers check permission to lookup
> > a given inode idmapped mount aware by switching it to the lookup_one()
> > helper. This is a bugfix for the open_by_handle_at() system call which
> > doesn't take idmapped mounts into account currently. It's not tied to a
> > specific commit so we'll just Cc stable.
> > 
> > In addition this is required to support idmapped base layers in overlay.
> > The overlay filesystem uses exportfs to encode and decode file handles
> > for its index=on mount option and when nfs_export=on.
> 
> This probably wants a Fixes tag, as without it NFS exporting idmapped
> file will give slightly unexpected results.

I made it so that the nfs kernel server will refuse to be mounted on top
of idmapped mounts in check_export() similar to what I did originally do
for overlayfs. It's unclear what the Fixes: tag would be so I'll just Cc
stable.

> 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
