Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99D94FB7DB
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbiDKJnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344776AbiDKJnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:43:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BC3344F0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E878FB80F4B
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6E9C385A5;
        Mon, 11 Apr 2022 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649670055;
        bh=iwizTwvZqV7X3A98VW1i/7ym2DJUZekRUP8fLEIjRZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/0BP5PIS4lWrHxF5Pfg7hNjxSNSyRYH5VHwpiZ+ppkEFLJiesGD1XX3ADbr4EX0n
         LrTEEswKwa43hUSKfKs0gpxrfeXXeZ0/C/0rJkdQjGFQXS3+ahbqafiV9EPAsUfAY3
         cK3iaybDWwBTK5hX1eG/nI4vzUfBs/E+qqVSxSnE=
Date:   Mon, 11 Apr 2022 11:40:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com, mlevitsk@redhat.com,
        seanjc@google.com, jon.grimm@amd.com
Subject: Re: [PATCH] KVM: SVM: Allow AVIC support on system w/ physical APIC
 ID > 255
Message-ID: <YlP3pb+heMJMkHxW@kroah.com>
References: <20220408113323.4066-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408113323.4066-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 06:33:23AM -0500, Suravee Suthikulpanit wrote:
> commit 4a204f7895878363ca8211f50ec610408c8c70aa upstream.
> 
> Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
> by the architecture.  The number of bits consumed by hardware is model
> specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
> to enumerate the "true" size.  So, KVM must allow using all bits, else it
> risks rejecting completely legal x2APIC IDs on newer CPUs.
> 
> This means KVM relies on hardware to not assign x2APIC IDs that exceed the
> "true" width of the field, but presumably hardware is smart enough to tie
> the width to the max x2APIC ID.  KVM also relies on hardware to support at
> least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
> assumptions are unavoidable due to the lack of any way to enumerate the
> "true" width.
> 
> Note:
> This patch has been modified from the upstream commit due to the conflict
> caused by the commit 391503528257 ("KVM: x86: SVM: move avic definitions
> from AMD's spec to svm.h")
> 
> Please apply this patch to the following kernel tree:
>   * 4.14-stable
>   * 4.9-stable
>   * 4.19-stable
>   * 5.4-stable
>   * 5.10-stable
>   * 5.15-stable
>   * 5.16-stable

It only applied to 5.15 and 5.16, we need backports that work (and
obviously have been tested) to apply this to older kernel trees.  Please
fix up and send if you want this in older trees.

thanks,

greg k-h
