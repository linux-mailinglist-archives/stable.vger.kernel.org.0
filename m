Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3E24D851B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiCNMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245417AbiCNMc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00F0237CB
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 05:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A12160C6D
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 12:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FBBC340E9;
        Mon, 14 Mar 2022 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260923;
        bh=1NYjtA5DMMgEanG0CqD6xxgo9byDr6tfvwPI4/GG10w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JdRNhbjQYnwiOlxxHlgSSEoJmatAiT2M5Uil6y8KXcRjRtuZFdb2t0FTkfF/OFf1N
         rT57sDuyo4U+RhQpDq8xNzpbeqxKc2vSUi008MW732AASC8h1DPpWSSM5oRsl8U6pP
         d65SFo4hOJjlSgtvzmJtXPzEQc8WZ+1xQw01u/Fo=
Date:   Mon, 14 Mar 2022 13:28:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: kintegrityd workqueue fix backported, but only to some LTS
Message-ID: <Yi809h0I28SN0qG8@kroah.com>
References: <Yi8r+UyK092FE12X@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi8r+UyK092FE12X@x1-carbon>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 11:50:18AM +0000, Niklas Cassel wrote:
> Hello Christoph, stable,
> 
> I recently saw a crash caused by the kintegrityd workqueue that could only
> be reproduced on older kernels.
> A null pointer dereference in function bio_integrity_verify_fn.
> 
> The fix in Linus's tree for this:
> 3df49967f6f1 ("block: flush the integrity workqueue in blk_integrity_unregister")
> was first merged in v5.15.
> 
> The fix has been backported to v5.10 LTS branch in:
> 1ef68b84bc11 ("block: flush the integrity workqueue in blk_integrity_unregister")
> 
> The fix doesn't have a fixes tag, but from inspecting the code,
> I don't understand why this was only backported to v5.10, AFAICT it should
> at least have been backported to v5.4, v4.19 and v4.14 LTS as well.
> 
> Original series:
> https://lore.kernel.org/all/20210914070657.87677-3-hch@lst.de/
> 
> The blk_flush_integrity() call that actually fixes the crash should be
> trivial to backport/add before clearing the flag and doing the memset.

A backported patch series would be great to have, to show that you have
tested that it works properly.

thanks,

greg k-h
