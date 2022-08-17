Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9B596A7C
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiHQHhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 03:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiHQHhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 03:37:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA6B75FE5;
        Wed, 17 Aug 2022 00:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AD11B81AD6;
        Wed, 17 Aug 2022 07:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74930C433C1;
        Wed, 17 Aug 2022 07:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660721834;
        bh=ZAxgS652KqeD91U/AIUFVyV1BNS52jclWURAzMcA7i4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mF3/ERpW4N+EGyi6bsuUI6OytAjmFYF405Prqc+C8q2wNsn1Une5lH/VDWAxbpb3c
         g5R73S+wei95AGYJhpkedxWlRBUmOrxBmFOIjcu7YFRj/ZTQuYCD1w5jwUqqXNr6Se
         b9aw7tL3M9/l33PLEu1uYUZF4CBhdDnx3XAzhRKI=
Date:   Wed, 17 Aug 2022 09:37:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0784/1157] scsi: sd: Rework asynchronous resume
 support
Message-ID: <YvyaqO75Et1cN376@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180510.851284927@linuxfoundation.org>
 <b532e50f-7aa0-5ac3-c7a6-6a43ab9c1bc9@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b532e50f-7aa0-5ac3-c7a6-6a43ab9c1bc9@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 11:05:27AM -0700, Bart Van Assche wrote:
> On 8/15/22 11:02, Greg Kroah-Hartman wrote:
> > From: Bart Van Assche <bvanassche@acm.org>
> > 
> > [ Upstream commit 88f1669019bd62b3009a3cebf772fbaaa21b9f38 ]
> > 
> > For some technologies, e.g. an ATA bus, resuming can take multiple
> > seconds. Waiting for resume to finish can cause a very noticeable delay.
> > Hence this commit that restores the behavior from before "scsi: core: pm:
> > Rely on the device driver core for async power management" for most SCSI
> > devices.
> > 
> > This commit introduces a behavior change: if the START command fails, do
> > not consider this as a SCSI disk resume failure.
> > 
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=215880
> > Link: https://lore.kernel.org/r/20220630195703.10155-3-bvanassche@acm.org
> > Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> 
> Hi Greg,
> 
> It has been reported that this patch causes a regression, namely disks not
> coming back after a resume. That issue is worse than the issue fixed by this
> patch - eliminating a delay. Please drop this patch from the stable tree.
> 
> A revert of this patch has been posted on the linux-scsi mailing list. See
> also https://lore.kernel.org/linux-scsi/8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com/.

Now dropped from the queue, thanks.

greg k-h
