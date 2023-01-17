Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22E166DAB4
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbjAQKPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbjAQKPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:15:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7517E2B0A1
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 02:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B84D9CE13D0
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 10:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA90C433D2;
        Tue, 17 Jan 2023 10:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673950548;
        bh=JuhOuzSiGGxzX1xGjp/vqNYEDez0AnGnPtXY9stAP+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RX5rfIFyMmtkgYdD4zCAjwrcO2T4ICzgZ2qYsunqU+EoFTFC0CONlNWQdgRuQbk3N
         wR0vU+aaXSudKp0/H10ZrecgBE5L7e+FjVU6n3k9XP0n8a/06Zyh3lVYAsn1ObYn9O
         HI6bxfsOB46Q5/hghrWZQW8Fhs1fQUnYxvVLsxds=
Date:   Tue, 17 Jan 2023 09:38:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: Re: [PATCH 5.4 537/658] drm/amdgpu: make display pinning more
 flexible (v2)
Message-ID: <Y8Zenkiijx6RDyFu@kroah.com>
References: <20230116154909.645460653@linuxfoundation.org>
 <20230116154934.097314689@linuxfoundation.org>
 <BL1PR12MB514444FC720081DAC5423410F7C19@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB514444FC720081DAC5423410F7C19@BL1PR12MB5144.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 04:35:05PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, January 16, 2023 10:50 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Tuikov, Luben <Luben.Tuikov@amd.com>; Koenig,
> > Christian <Christian.Koenig@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>
> > Subject: [PATCH 5.4 537/658] drm/amdgpu: make display pinning more
> > flexible (v2)
> > 
> > From: Alex Deucher <alexander.deucher@amd.com>
> > 
> > commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.
> > 
> > Only apply the static threshold for Stoney and Carrizo.
> > This hardware has certain requirements that don't allow mixing of GTT and
> > VRAM.  Newer asics do not have these requirements so we should be able to
> > be more flexible with where buffers end up.
> > 
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2270
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2291
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2255
> > Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> > Reviewed-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Let's drop this patch.  There are regressions for hibernation on some platforms on kernels older than 6.1.x

Ok, is there a revert anywhere for the 5.10 and 5.15 releases that
already have this in it?  I'll go drop it from the remaining queues now.

thanks,

greg k-h
