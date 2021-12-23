Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C647DF6E
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 08:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbhLWHQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 02:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346665AbhLWHQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 02:16:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE2BC061401;
        Wed, 22 Dec 2021 23:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A6C4B81F7C;
        Thu, 23 Dec 2021 07:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D52C36AE9;
        Thu, 23 Dec 2021 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640243779;
        bh=0+7xI3fjq8N0+4pFxhckK9Vss9x+h659RdiSazrM9Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFv9zbgao2K5GAKT7OFAHykZ5BaXh/U3cCM9kaTec23oWilYG3rk8qwvZ1gDX2RVK
         NxvucRUmM5nKlGE1eN69rssu7n69ZxFveS/3iQuF/vo3gGpH7Yd0jxrr3XKPEBKrdk
         DlX1mSeskjq5SYNGIky3xBn7ZgGfvc3CFtOhiq4E=
Date:   Thu, 23 Dec 2021 08:16:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sameer Pujar <spujar@nvidia.com>
Cc:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz, jonathanh@nvidia.com,
        mkumard@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
Message-ID: <YcQiP+MxrlLi+R94@kroah.com>
References: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
 <1640147751-4777-2-git-send-email-spujar@nvidia.com>
 <fb8cf33f-41fb-79c0-3134-524c290e4fc1@gmail.com>
 <f734e48f-dd60-ddb8-510a-3c4f37d8fb52@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f734e48f-dd60-ddb8-510a-3c4f37d8fb52@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 10:04:19AM +0530, Sameer Pujar wrote:
> 
> 
> On 12/23/2021 12:10 AM, Dmitry Osipenko wrote:
> > 22.12.2021 07:35, Sameer Pujar пишет:
> > > HDA regression is recently reported on Tegra194 based platforms.
> > > This happens because "hda2codec_2x" reset does not really exist
> > > in Tegra194 and it causes probe failure. All the HDA based audio
> > > tests fail at the moment. This underlying issue is exposed by
> > > commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
> > > response") which now checks return code of BPMP command response.
> > > Fix this issue by skipping unavailable reset on Tegra194.
> > > 
> > > Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> > > Cc: stable@vger.kernel.org
> > > Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
> > Is "Depends-on" a valid tag? I can't find it in Documentation/.
> 
> I do find the usage of the tag in many commits though there is no reference
> of this in doc. I always thought it would act as a reference when commits
> get pulled to other branches. If this is not true and it does not mean
> anything, I will drop this.

It is not true at all, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.
