Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82064B2502
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 12:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349758AbiBKL5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 06:57:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347799AbiBKL5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 06:57:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1139F61
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 03:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEFF61B5A
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD720C340E9;
        Fri, 11 Feb 2022 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644580611;
        bh=9Luj/eOToRiQ/vojPdbcQy0ff9jXdaz2VR5U3DZ7Ozw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/fwbKoq4aHXINecz0eAmx6dZ+kB0m0Td5sajxjvfodY58po21fgvxzN4LdvHpMAF
         wzBTqdDFYAMBYzzS/S3lriCpObaBAlJ0Y7UnU7HJun4R0CZpGiM/VvIo6LWdB3XKhz
         vqtI2NrNtAVBGbzIipFnm1hxVFHhByLV4vlX2IfA=
Date:   Fri, 11 Feb 2022 12:56:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [4.9] net: axienet: Misplaced backport of "Wait for PhyRstCmplt
 after core reset"
Message-ID: <YgZPADnzN12UXAr6@kroah.com>
References: <1644338071-24326-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644338071-24326-1-git-send-email-guillaume.bertholon@ens.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 05:34:31PM +0100, Guillaume Bertholon wrote:
> The upstream commit b400c2f4f4c5 ("net: axienet: Wait for PhyRstCmplt
> after core reset") add new instructions in the `__axienet_device_reset`
> function to wait until PhyRstCmplt bit is set, and return a non zero-exit
> value if this exceeds a timeout.
> 
> However, its backported version in 4.9 (commit 9f1a3c13342b ("net:
> axienet: Wait for PhyRstCmplt after core reset")) insert these
> instructions in `axienet_dma_bd_init` instead.
> 
> Unlike upstream, the version of `__axienet_device_reset` currently present
> in branch stable/linux-4.9.y does not return an integer for error codes.
> Therefore the backport cannot be as simple as moving the inserted
> instructions in the right place.
> 
> Where and how should we backport the patch in this case ?
> Should we simply revert it instead ?

We should just revert it.  Can you make up a patch that does so?

thanks,

greg k-h
