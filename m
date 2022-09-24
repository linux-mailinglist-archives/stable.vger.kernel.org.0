Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E0C5E8AF8
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiIXJhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiIXJhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B18822502;
        Sat, 24 Sep 2022 02:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58E2AB80DAB;
        Sat, 24 Sep 2022 09:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A209EC433D6;
        Sat, 24 Sep 2022 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664012224;
        bh=rww4KG8UuqfwOfyBLEiOuHilfH1HZYFAdHqdoJd/16k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDgFPTLbMgY8lmK7s3vzA23D7X0KoJKO0B5mF3V73bjLq6RV1IQfBU/b3huRX7YT0
         aceYZDM265lr40yeOmnQMIlRqd/OzzCExgEV1dz7Ar2pAjLJV6ADS2XEus2MMWpDaS
         PdRpQZ7bIQopM91TNkskgIbVsWO9ocYltuZdnims=
Date:   Sat, 24 Sep 2022 11:37:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Varsha Teratipally <teratipally@google.com>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 5.10] xfs: fix up non-directory creation in SGID
 directories
Message-ID: <Yy7PvRO2fhiK1BVu@kroah.com>
References: <20220922084956.74262-1-amir73il@gmail.com>
 <Yyx9eaKyYC08vOvq@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyx9eaKyYC08vOvq@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 08:21:29AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 22, 2022 at 11:49:56AM +0300, Amir Goldstein wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> > 
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
> > 
> > Switch XFS to use the generic helper for the normal path to fix this,
> > just keeping the simple field inheritance open coded for the case of the
> > non-sgid case with the bsdgrpid mount option.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Acked-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> (H)acked-off-by?  I suppose we /are/ grafting bits of trees... :D
> 
> Acked-by: Darrick J. Wong <djwong@kernel.org>

Now queued up, thanks.

greg k-h
