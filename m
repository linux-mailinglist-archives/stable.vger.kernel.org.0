Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF856BAF67
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 12:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCOLh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjCOLh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 07:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE23C1515D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F0ECB81C82
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7392C433D2;
        Wed, 15 Mar 2023 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678880274;
        bh=twdZXV13mBNbJTd7pWuEeBh0pS5NgE7hcpjS8Z0P3ZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ip/cvMEyHzF+bnMGOoMbF9b67nBPOAqPKziigxuWKAHF4vejSQI0FeI0wimqJZeyk
         pAJjRpY2jQx2hvzrCIZsSpmS5FU1BGcYkPu8rj9DH+/wj+WcCi9VCmVFj+9IdXR6Pa
         ZMvafI4BBmhjCH6pD0NbTnbPyqtSAiZiNSIsg54s=
Date:   Wed, 15 Mar 2023 12:37:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4.y] s390/dasd: add missing discipline function
Message-ID: <ZBGuD7WnuM1hTich@kroah.com>
References: <1678267892145165@kroah.com>
 <20230315094532.908429-1-hoeppner@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230315094532.908429-1-hoeppner@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 10:45:32AM +0100, Jan Höppner wrote:
> From: Stefan Haberland <sth@linux.ibm.com>
> 
> Fix crash with illegal operation exception in dasd_device_tasklet.
> Commit b72949328869 ("s390/dasd: Prepare for additional path event handling")
> renamed the verify_path function for ECKD but not for FBA and DIAG.
> This leads to a panic when the path verification function is called for a
> FBA or DIAG device.
> 
> Fix by defining a wrapper function for dasd_generic_verify_path().
> 
> Fixes: b72949328869 ("s390/dasd: Prepare for additional path event handling")
> Cc: <stable@vger.kernel.org> #5.11
> Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
> Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Link: https://lore.kernel.org/r/20210525125006.157531-2-sth@linux.ibm.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/s390/block/dasd_diag.c | 7 ++++++-
>  drivers/s390/block/dasd_fba.c  | 7 ++++++-
>  drivers/s390/block/dasd_int.h  | 1 -
>  3 files changed, 12 insertions(+), 3 deletions(-)

What is the git commit id of this change in Linus's tree?

thanks,

greg k-h
