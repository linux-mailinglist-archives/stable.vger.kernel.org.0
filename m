Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24DB5B1BD5
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 13:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiIHLsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 07:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIHLsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 07:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38F11450;
        Thu,  8 Sep 2022 04:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07CC4B820CE;
        Thu,  8 Sep 2022 11:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D43C433C1;
        Thu,  8 Sep 2022 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662637686;
        bh=RGUYsIyKiM5K9baF1Oe7PxKZyAlFt5TcXpEH7waYx3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y8TstqL8IsDrA90x/bzJq7GHJfS68qcVdWXr92wQ02Vhc0xCEUY7xxEzc99XYZ559
         Xghn6EDCQOwTj2mgwzJUdusdft9zIkVUEnkfypIhi1x5Ir4z1HG3X/AwUJBCqISgzQ
         +mpmzb5iq2sc27TSNi47RdKFQKddXjJGnqTetJrM=
Date:   Thu, 8 Sep 2022 13:48:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Varsha Teratipally <teratipally@google.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <YxnWi5YcuY6Rbodt@kroah.com>
References: <20220906183600.1926315-1-teratipally@google.com>
 <20220906183600.1926315-2-teratipally@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906183600.1926315-2-teratipally@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 06:36:00PM +0000, Varsha Teratipally wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.
> 
> Switch XFS to use the generic helper for the normal path to fix this,
> just keeping the simple field inheritance open coded for the case of the
> non-sgid case with the bsdgrpid mount option.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Why did you not sign off on this if you are forwarding it on?

Also, what is the git id of this commit in Linus's tree (we need that
hint...)

Please fix both up and resend and get the ack of the stable xfs
developers on it as well.

thanks,

greg k-h
