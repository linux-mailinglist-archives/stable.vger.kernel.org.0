Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E546A4D0526
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiCGRXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 12:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiCGRXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 12:23:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5A113F18;
        Mon,  7 Mar 2022 09:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFF961205;
        Mon,  7 Mar 2022 17:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B38CC340E9;
        Mon,  7 Mar 2022 17:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646673764;
        bh=v/58+UyDdN2jPjBM8BSf7jrYCXlFV0DWZDBtp2tmpeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOyy+2tW2bq4tJ4vbp9kKk0ln0YFjNtoYffwSrW7sAbtaZz7JWl2GK479UM1er2mi
         mZGNPJgQh0M0/u+Y9BmGLnPvaB6x8FJap2/C1A1hDFDzM6+bAO92BOhPWRavlQAhvI
         WscjTohPAdHRfVtCujbVRMUBOZH+CVkUVFb8O7Ew=
Date:   Mon, 7 Mar 2022 18:22:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Gutierrez, Agustin" <Agustin.Gutierrez@amd.com>,
        "Wheeler, Daniel" <Daniel.Wheeler@amd.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
 code to DML folder
Message-ID: <YiY/YaU7YdGZQ4B0@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <20220307091705.301226097@linuxfoundation.org>
 <BL1PR12MB5144BBA7ACECD892E9DE088AF7089@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144BBA7ACECD892E9DE088AF7089@BL1PR12MB5144.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 05:19:20PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, March 7, 2022 4:17 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > stable@vger.kernel.org; Koenig, Christian <Christian.Koenig@amd.com>;
> > Wu, Hersen <hersenxs.wu@amd.com>; Anson Jacob
> > <Anson.Jacob@amd.com>; Wentland, Harry <Harry.Wentland@amd.com>;
> > Siqueira, Rodrigo <Rodrigo.Siqueira@amd.com>; Gutierrez, Agustin
> > <Agustin.Gutierrez@amd.com>; Wheeler, Daniel
> > <Daniel.Wheeler@amd.com>; Zhuo, Qingqing (Lillian)
> > <Qingqing.Zhuo@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
> > code to DML folder
> > 
> > From: Qingqing Zhuo <qingqing.zhuo@amd.com>
> > 
> > [ Upstream commit d738db6883df3e3c513f9e777c842262693f951b ]
> > 
> > [Why & How]
> > As part of the FPU isolation work documented in
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatc
> > hwork.freedesktop.org%2Fseries%2F93042%2F&amp;data=04%7C01%7Calex
> > ander.deucher%40amd.com%7Cf4f4d5bfb9f74edfb8b108da001e6d8f%7C3dd
> > 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637822427968538535%7CUn
> > known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> > Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=2Mm24%2FPkRkih%2BToJ
> > oBGx2wpeth0Z0Rv3dG77D06fHbw%3D&amp;reserved=0, isolate code that
> > uses FPU in DSC to DML, where all FPU code should locate.
> > 
> > This change does not refactor any functions but move code around.
> > 
> 
> This is not a really bug fix, just general reworking of the FP code.  I don't know that this is stable material.

I think it's needed for a follow-on patch in this series, right?

