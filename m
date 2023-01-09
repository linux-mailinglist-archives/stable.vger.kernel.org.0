Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6BB6625B2
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 13:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjAIMfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 07:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjAIMfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 07:35:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672C9262;
        Mon,  9 Jan 2023 04:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE30F61062;
        Mon,  9 Jan 2023 12:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA36C43392;
        Mon,  9 Jan 2023 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673267729;
        bh=Gw7CvHdjKc8HwPi5QQEoTq9+XTu1vmAKL3TmGZisWcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iiNedENDzk+D5IwFc5TjAK3fVsmIF9LczOPprOhSeTYtLuNVxCWFTTbLDe++inHop
         DlbgRiZa1ba+tKcS1L2eK7b/VgUtLTybT+A7Fy9QhTjK/deFNSUrwX1wuz5nHx8Urm
         TK8FyGv0N0KBm4Km9iTJAtgzJBqy8DgbCWhMp/pQ5d/kxRq6K1mGY2gUNQjKRJWQhP
         6y6moJyuH0kLvCBD8MJcUPaRy91VhFGENWVu+zJAbcCaFTE3qK0W4f3LGkefcdUdy1
         SA4iExQB+c2KQIotFki+tDXX2cYLv/jioJGvHCsd1NCIx8JdItG0VXDIogQC6EK6WW
         9CLyRCAlyoscA==
Date:   Mon, 9 Jan 2023 07:35:27 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?iso-8859-1?Q?P=E9ter?= Ujfalusi 
        <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        Jaroslav Kysela <perex@perex.cz>, tiwai@suse.com,
        sound-open-firmware@alsa-project.org,
        Alsa-devel <alsa-devel@alsa-project.org>
Subject: Re: [PATCH AUTOSEL 6.1 1/7] ASoC: SOF: Revert: "core: unregister
 clients and machine drivers in .shutdown"
Message-ID: <Y7wKD6ayGW3HjV5N@sashalap>
References: <20221231200439.1748686-1-sashal@kernel.org>
 <alpine.DEB.2.22.394.2301041427580.3532114@eliteleevi.tm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2301041427580.3532114@eliteleevi.tm.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 02:34:55PM +0200, Kai Vehmanen wrote:
>Hi,
>
>On Sat, 31 Dec 2022, Sasha Levin wrote:
>
>> From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>>
>> [ Upstream commit 44fda61d2bcfb74a942df93959e083a4e8eff75f ]
>>
>> The unregister machine drivers call is not safe to do when
>> kexec is used. Kexec-lite gets blocked with following backtrace:
>
>this should be picked together with commit 2aa2a5ead0e ("ASoC: SOF: Intel:
>pci-tgl: unblock S5 entry if DMA stop has failed"), to not bring back old
>bugs (system failures to enter S5 on shutdown). The revert patch
>unfortunately fails to mention this dependency.
>
>If I'm too late with my reply, I can send the second patch separately to
>stable.

I took 2aa2a5ead0e along with this patch, thanks!

-- 
Thanks,
Sasha
