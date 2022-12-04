Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C375641DC6
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLDQHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 11:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLDQHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 11:07:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A336D62F3
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 08:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D7C6B80AC5
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 16:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96460C433C1;
        Sun,  4 Dec 2022 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670170064;
        bh=tpUUkF++iJoD436YneoHsbEYmaLSXsiDWOtNWt41TRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PvvWRf0kOfx69othS/27mIvzhLoLR5tA3uvr9VabaCeH6+wyzcEBUUm7574EMHBmV
         GVGqEA25Fr+aSRLYdRu/SasJGE2dZUCkEBEgz4nigVJprbLW9bmaXOztitrIGb0Qb0
         m3kdBJowsxzYPR9YgzNhm3PrFO5v23q3rPF+zWK4=
Date:   Sun, 4 Dec 2022 17:07:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cengiz Can <cengiz.can@canonical.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/3] Bluetooth: L2CAP: Fix accepting connection
 request for invalid SPSM
Message-ID: <Y4zFzNGlCC1wlyc2@kroah.com>
References: <20221203222434.669854-1-cengiz.can@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203222434.669854-1-cengiz.can@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 01:24:33AM +0300, Cengiz Can wrote:
> Hello,
> 
> commit 711f8c3fb3db ("Bluetooth: L2CAP: Fix accepting connection request for 
> invalid SPSM") did not apply to 5.4-stable tree previously.
> 
> One of the notable dependencies is commit 15f02b910562 ("Bluetooth: L2CAP: 
> Add initial code for Enhanced Credit Based Mode") and that doesn't apply to 
> 5.4-stable either due to a mismatch on `l2cap_sock_setsockopt_old` in 
> l2cap_sock.c.

And that commit does not seem relevant for stable backports at all as it
is a new feature.  If all you really want to do is fix the "bug", why
not just take half of commit 711f8c3fb3db, i.e. the half that actually
matters in this kernel tree?

Why wouldn't that just work for all of the older kernels?  I'll go do
that now as it seems like it will solve the issue, but it would be great
if people could actually test it (hint, why didn't you cc: the bluetooth
developers here?)

thanks,

greg k-h
