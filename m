Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A844529E9D
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiEQJ7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbiEQJ7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 05:59:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408BF35877;
        Tue, 17 May 2022 02:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2C36B817FA;
        Tue, 17 May 2022 09:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D08C385B8;
        Tue, 17 May 2022 09:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652781559;
        bh=IjTrdkC91KRp+rvEIbIDiMLZHXKC2n8pE+7UtzloPrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xn2gVi05KA3hpbMmcoE8VN3hUgnIIdxfa2xbfWTu2M+p5r82NT70wL9ohPKO2MIkp
         6NPCY7ZXgy1CoQ+CtpCd3JaHZmivUEkqY+D+em7HjxVCE6UPPpxwl07IQWb0Xuj10Z
         DvPzZ8d8fGgqN989RoDqKMpI+7ZidI7gD6iqlJRY=
Date:   Tue, 17 May 2022 11:59:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace
Message-ID: <YoNx8a8+gvOWwfc9@kroah.com>
References: <20220517072708.245265-1-Jerome.Pouiller@silabs.com>
 <c1479285-7fd8-b73a-9672-6e0d7db4cbdf@amd.com>
 <3847797.kQq0lBPeGt@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3847797.kQq0lBPeGt@pc-42>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 10:32:15AM +0200, Jérôme Pouiller wrote:
> [add stable@vger.kernel.org to the recipients]
> 
> On Tuesday 17 May 2022 09:30:24 CEST Christian König wrote:
> > Am 17.05.22 um 09:27 schrieb Jerome Pouiller:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > The typedefs u32 and u64 are not available in userspace. Thus user get
> > > an error he try to use DMA_BUF_SET_NAME_A or DMA_BUF_SET_NAME_B:
> > >
> > >      $ gcc -Wall   -c -MMD -c -o ioctls_list.o ioctls_list.c
> > >      In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1,
> > >                       from /usr/include/linux/ioctl.h:5,
> > >                       from /usr/include/asm-generic/ioctls.h:5,
> > >                       from ioctls_list.c:11:
> > >      ioctls_list.c:463:29: error: ‘u32’ undeclared here (not in a function)
> > >        463 |     { "DMA_BUF_SET_NAME_A", DMA_BUF_SET_NAME_A, -1, -1 }, // linux/dma-buf.h
> > >            |                             ^~~~~~~~~~~~~~~~~~
> > >      ioctls_list.c:464:29: error: ‘u64’ undeclared here (not in a function)
> > >        464 |     { "DMA_BUF_SET_NAME_B", DMA_BUF_SET_NAME_B, -1, -1 }, // linux/dma-buf.h
> > >            |                             ^~~~~~~~~~~~~~~~~~
> > >
> > > The issue was initially reported here[1].
> > >
> > > [1]: https://urldefense.com/v3/__https://nam11.safelinks.protection.outlook.com/?url=https*3A*2F*2Fgithub.com*2Fjerome-pouiller*2Fioctl*2Fpull*2F14&amp;data=05*7C01*7Cchristian.koenig*40amd.com*7C4b665e3c2222463014ec08da37d6b3f4*7C3dd8961fe4884e608e11a82d994e183d*7C0*7C0*7C637883692533547283*7CUnknown*7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0*3D*7C3000*7C*7C*7C&amp;sdata=prj*2BSOuf*2B1IWK1XKGD381LhDuL9qOoj7lYy8xMoV*2B6o*3D&amp;reserved=0__;JSUlJSUlJSUlJSUlJSUlJSUlJSUlJSUlJSU!!N30Cs7Jr!Vp-6M6kuBq4uqEHaYTbkJbN3BTkd85DAeGS7xNYLPbNMp00kBlbD0iQPjJdQ5OVCFeCp_XVrsYIhxvLlpLQDmRhK5QXhQA$
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > 
> > Good catch, Reviewed-by: Christian König <christian.koenig@amd.com>
> > 
> > CC: stable?
> 
> Done

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
