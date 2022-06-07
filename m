Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF77453FB95
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiFGKmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241280AbiFGKmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F48C64;
        Tue,  7 Jun 2022 03:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21772B81EEE;
        Tue,  7 Jun 2022 10:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EADC385A5;
        Tue,  7 Jun 2022 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654598528;
        bh=4725KDrGpJOk1ZEF6lL67wXtvIpqznZRUIXV0TVSfK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wkxwy/3yYm9C+WSKRyN2dQEt5+0zMvxdp6LlzTA3aEzvWCToZ9oNg8IA41uBIO1Rv
         JpVt+F5jOEjVagupgf1FMwpSC3POZVlUdEdUesdkHoIgWXfTzIyQpQpJUBjk85TgMA
         J5+H7sUYNv0k3weM8T7LNm+vdF/xB6LzowvfPhKo=
Date:   Tue, 7 Jun 2022 12:42:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y 2/2] exportfs: support idmapped mounts
Message-ID: <Yp8rfaKG5Vj6YBak@kroah.com>
References: <20220607100840.1686673-1-brauner@kernel.org>
 <20220607100840.1686673-2-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607100840.1686673-2-brauner@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 12:08:39PM +0200, Christian Brauner wrote:
> Make the two locations where exportfs helpers check permission to lookup
> a given inode idmapped mount aware by switching it to the lookup_one()
> helper. This is a bugfix for the open_by_handle_at() system call which
> doesn't take idmapped mounts into account currently. It's not tied to a
> specific commit so we'll just Cc stable.
> 
> In addition this is required to support idmapped base layers in overlay.
> The overlay filesystem uses exportfs to encode and decode file handles
> for its index=on mount option and when nfs_export=on.
> 
> Cc: <stable@vger.kernel.org>
> Cc: <linux-fsdevel@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> Hey Greg,
> 
> This was missing a preliminary commit.
> My build machines are currently down so I couldn't do a test build but
> this should build cleanly.

Looks like it applies cleanly, let me apply it and run it through my
build systems...

thanks,

greg k-h
