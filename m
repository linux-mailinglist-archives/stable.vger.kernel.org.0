Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1E56BAF72
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 12:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCOLms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 07:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCOLmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 07:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13B7604B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F450B81DB5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81818C433EF;
        Wed, 15 Mar 2023 11:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678880563;
        bh=Th2ZaRDra0VZLiVDYR9599h/mDdU2WSV9aziTMMN2Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M5Q/i8/u4W1tRP1eiWsT3wxK+HGNSFy4YBCL89oqcXu3Mp4o/G91ZgP5G2FPEmQY3
         KSm/39igP/FbSCm4w2GWJKhYLhUjfYO9llB59MEq4brws/813qqAIJerWeItwdX/Wh
         L/KXfmhSd/2HFNSGML9hlONwfQof+gmLRAev30CU=
Date:   Wed, 15 Mar 2023 12:42:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4.y] s390/dasd: add missing discipline function
Message-ID: <ZBGvMSCI8psvK0wo@kroah.com>
References: <1678267892145165@kroah.com>
 <20230315094532.908429-1-hoeppner@linux.ibm.com>
 <ZBGuD7WnuM1hTich@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBGuD7WnuM1hTich@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 12:37:51PM +0100, Greg KH wrote:
> On Wed, Mar 15, 2023 at 10:45:32AM +0100, Jan Höppner wrote:
> > From: Stefan Haberland <sth@linux.ibm.com>
> > 
> > Fix crash with illegal operation exception in dasd_device_tasklet.
> > Commit b72949328869 ("s390/dasd: Prepare for additional path event handling")
> > renamed the verify_path function for ECKD but not for FBA and DIAG.
> > This leads to a panic when the path verification function is called for a
> > FBA or DIAG device.
> > 
> > Fix by defining a wrapper function for dasd_generic_verify_path().
> > 
> > Fixes: b72949328869 ("s390/dasd: Prepare for additional path event handling")
> > Cc: <stable@vger.kernel.org> #5.11
> > Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
> > Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > Link: https://lore.kernel.org/r/20210525125006.157531-2-sth@linux.ibm.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  drivers/s390/block/dasd_diag.c | 7 ++++++-
> >  drivers/s390/block/dasd_fba.c  | 7 ++++++-
> >  drivers/s390/block/dasd_int.h  | 1 -
> >  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> What is the git commit id of this change in Linus's tree?

Nevermind, I dug in the tree and found it...
