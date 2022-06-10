Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02678545B80
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 07:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbiFJFPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 01:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFJFPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 01:15:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694E5BD1
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 22:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 895ACCE2CA6
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FC6C34114;
        Fri, 10 Jun 2022 05:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654838106;
        bh=iwIrhyG/TU5w7j278ppgaovsn29ziyLEO7pflJmV+88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hwmx0zvnLX0SAD+FpXG1Qa4+DD2PiZt3gZTB0ziKNx0YJ8T85ENtElQstdDUUl5m/
         uD0s96rRPn3I/uHWcbGfAO3OqE8ZjJWAt4GKY3gP7k14Ti3PU3PIKw3RNu1YMC2Jmf
         KZMl3FlJpuAr8L43/cjY7S5rSPSSH2LPpo9QqFkI=
Date:   Fri, 10 Jun 2022 07:15:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     keescook@chromium.org, sarthakkukreti@google.com,
        snitzer@kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <YqLTV+5Q72/jBeOG@kroah.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610042200.2561917-1-ovt@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> I believe this commit introduced a regression in dm verity on systems
> where data device is an NVME one. Loading table fails with the
> following diagnostics:
> 
> device-mapper: table: table load rejected: including non-request-stackable devices
> 
> The same kernel works with the same data drive on the SCSI interface.
> NVME-backed dm verity works with just this commit reverted.
> 
> I believe the presence of the immutable partition is used as an indicator
> of special case NVME configuration and if the data device's name starts
> with "nvme" the code tries to switch the target type to
> DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> 
> The special NVME optimization case was removed in
> 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> affected.
> 

Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
immutable singleton target on NVMe") to those older kernels?  If so,
have you tested this and verified that it worked?

thanks,

greg k-h
