Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EDE6BA9B5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCOHrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjCOHr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:47:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8237D60A84
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F00361B4D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A7C433D2;
        Wed, 15 Mar 2023 07:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678866411;
        bh=E84sHEu8GFPjgL6NM884Ks5GXFGd/1sxVkVmoOm8z9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wb/uuIWj88E5so0JqvxLz1I1Q3qCPG/PnTyDXb+1sqZfzhV7kRCFMwsxS1S3omC1g
         hg+bPWR2bTN/xh4r5C2wvQSnEWZ0fklOXloMq7E7iKhc4zKALK5J2eTBRxRl64ymp7
         rG9GBLlj4oNXwa8Cshmkcv2qU7dYke5BID0iIjE8=
Date:   Wed, 15 Mar 2023 08:46:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Cc:     brauner@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.2] filelocks: use mount idmapping for setlease
 permission check
Message-ID: <ZBF34S96xlmOpb61@kroah.com>
References: <167870482993162@kroah.com>
 <20230313192140.3986664-1-sforshee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313192140.3986664-1-sforshee@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 02:21:40PM -0500, Seth Forshee (DigitalOcean) wrote:
> From: Seth Forshee <sforshee@kernel.org>
> 
> [ Upstream commit 42d0c4bdf753063b6eec55415003184d3ca24f6e ]
> 
> A user should be allowed to take out a lease via an idmapped mount if
> the fsuid matches the mapped uid of the inode. generic_setlease() is
> checking the unmapped inode uid, causing these operations to be denied.
> 
> Fix this by comparing against the mapped inode uid instead of the
> unmapped uid.
> 
> Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
>  fs/locks.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
