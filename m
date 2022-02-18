Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F434BB6F4
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiBRKeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:34:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiBRKeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:34:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0846E21837
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF353B825A8
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31DBC340E9;
        Fri, 18 Feb 2022 10:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645180420;
        bh=k56x9I+UwdrqBt+ZMW1J2JufEnxcpXoI910UjmTNaM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LmjCYqNPUPBvhCXDUAyerppD4tm83B29VV+1BSqexgskw5q0Pj5wpXywM/dV5ZDlH
         otO6DERxumpr0y6gUKfkSF5fPzXenSMD1kcysE99uXsPvDbWQwoFtFsCAh23qljXrH
         qLAUIjUzDsR/tH0FrH7CtYLQfryUoo3AIK9NdBNE=
Date:   Fri, 18 Feb 2022 11:33:37 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
Message-ID: <Yg92AW1onRd47G9z@kroah.com>
References: <16451252511822@kroah.com>
 <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 09:50:54AM +0000, Christian Löhle wrote:
> commit 54309fde1a352ad2674ebba004a79f7d20b9f037 upstream.
> 
> On reads with MMC_READ_MULTIPLE_BLOCK that fail,
> the recovery handler will use MMC_READ_SINGLE_BLOCK for
> each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
> The logic for this is fixed to never report unsuccessful reads
> as success to the block layer.
> 
> On command error with retries remaining, blk_update_request was
> called with whatever value error was set last to.
> In case it was last set to BLK_STS_OK (default), the read will be
> reported as success, even though there was no data read from the device.
> This could happen on a CRC mismatch for the response,
> a card rejecting the command (e.g. again due to a CRC mismatch).
> In case it was last set to BLK_STS_IOERR, the error is reported correctly,
> but no retries will be attempted.
> 
> Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
> 
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> ---
>  drivers/mmc/core/block.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)

What stable branch(s) is this backport for?

thanks,

greg k-h
