Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46B613130
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJaH0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJaH0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD216543;
        Mon, 31 Oct 2022 00:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BF71B810BD;
        Mon, 31 Oct 2022 07:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92165C433D6;
        Mon, 31 Oct 2022 07:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667201209;
        bh=tgUBlfY8snQZBBc3cJPN5qUjvsdEdl9zbZGSBWO2aY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mFI3lXkI9G5zJOLNs+6Whq5Pc4+eovMEPSgkbk9a5NnBdcTjj5/dFjQjgVVWeo0Dm
         zK/uWfTp1YKAhAhddiSq1Av+k2PMaWaS8Z7hz9iuC2DCCWug3CDB5kpH+YxW4IjGgj
         2mMIeuU2pNCvUV0+LHpo1BBuGxc17B/xCJGxpH1k=
Date:   Mon, 31 Oct 2022 08:27:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, stable@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.com,
        linux-scsi@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 5.10/5.15] scsi: sd: Revert "scsi: sd: Remove a local
 variable"
Message-ID: <Y1948gTyjnU0/ljk@kroah.com>
References: <20221029025837.1258377-1-yukuai1@huaweicloud.com>
 <fb98be99-58e9-9f09-7179-cef70b45a8dc@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb98be99-58e9-9f09-7179-cef70b45a8dc@acm.org>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 29, 2022 at 04:10:47PM -0700, Bart Van Assche wrote:
> On 10/28/22 19:58, Yu Kuai wrote:
> > This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.
> > 
> > Because it introduces a problem that rq->__data_len is set to the wrong
> > value.
> > 
> > before this patch:
> > 1) nr_bytes = rq->__data_len
> > 2) rq->__data_len = sdp->sector_size
> > 3) scsi_init_io()
> > 4) rq->__data_len = nr_bytes
> > 
> > after this patch:
> > 1) rq->__data_len = sdp->sector_size
> > 2) scsi_init_io()
> > 3) rq->__data_len = rq->__data_len -> __data_len is wrong
> > 
> > It will cause that io can only complete one segment each time, and the io
> > will requeue in scsi_io_completion_action(), which will cause severe
> > performance degradation.
> 
> It's probably worth mentioning that the code affected by this patch has been
> removed from the master branch and hence that this patch is only needed for
> stable kernels. Anyway:

Yes, that needs to be in the changelog in lots of detail.

Yu, please fix this up and resend.

thanks,

greg k-h
