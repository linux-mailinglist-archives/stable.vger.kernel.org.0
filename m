Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB43A3DE008
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhHBT2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhHBT2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 15:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F39660F51;
        Mon,  2 Aug 2021 19:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627932476;
        bh=E+L74fp1D48FCSw30Tfs8UMixrXSCi/2zYw0XfbEwuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJD8ilLdlK1MbUh2hi14LSncmhmKxW8ukscPLnyhDXgeqWv75LyNQ8moy26qLvK/W
         L2lnM6Dl6iF+TlmZXSrt7tXjOWru2bX6KYzgyXVKO2SJ8CFr5fdfQawRY+TcjTUXjs
         hbxtaZJk9prFsWJmnYt6GzWUNofLDofqbtWWyV3X3gWMMK/8HLnKG2P4/gBsPTad/a
         hSeKtW5aRIMmV4aa9tBRdtx/w00PO4RwxvCoM7JuKUChR/mcW6D166Z2ZgdRpUgYKW
         impKAB2TL81iqYIsEqKl38RQIKH59bWCpbQDEvRyLp6YN0VL1gQ5k8ER0hyC8UKpJc
         ZKTTksw8bjujQ==
Date:   Mon, 2 Aug 2021 15:27:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        =?iso-8859-1?Q?P=E9ter?= Ujfalusi 
        <peter.ujfalusi@linux.intel.com>
Subject: Re: [PATCH] ASoC: Intel: boards: fix xrun issue on platform with
 max98373
Message-ID: <YQhHO6EmugpHfJGe@sashalap>
References: <20210802180614.23940-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210802180614.23940-1-pierre-louis.bossart@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:06:14PM -0500, Pierre-Louis Bossart wrote:
>From: Rander Wang <rander.wang@intel.com>
>
>commit 33c8516841ea4fa12fdb8961711bf95095c607ee upstream
>
>On TGL platform with max98373 codec the trigger start sequence is
>fe first, then codec component and sdw link is the last. Recently
>a delay was introduced in max98373 codec driver and this resulted
>to the start of sdw stream transmission was delayed and the data
>transmitted by fw can't be consumed by sdw controller, so xrun happened.
>
>Adding delay in trigger function is a bad idea. This patch enable spk
>pin in prepare function and disable it in hw_free to avoid xrun issue
>caused by delay in trigger.
>
>Fixes: 3a27875e91fb ("ASoC: max98373: Added 30ms turn on/off time delay")
>BugLink: https://github.com/thesofproject/sof/issues/4066
>Reviewed-by: Bard Liao <bard.liao@intel.com>
>Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
>Signed-off-by: Rander Wang <rander.wang@intel.com>
>Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>Link: https://lore.kernel.org/r/20210625205042.65181-2-pierre-louis.bossart@linux.intel.com
>Signed-off-by: Mark Brown <broonie@kernel.org>
>---
>
>backport to stable/linux-5.13.y and stable/linux-5.12.y since upstream
>commit does not apply directly due to a rename in 9c5046e4b3e7 which
>creates a conflict.

Any objections to bringing in:

9c5046e4b3e7 ("ASoC: Intel: boards: create sof-maxim-common module")
f6081af6cf2b ("ASoC: Intel: boards: handle hda-dsp-common as a module")

to 5.13 instead? This way we'll be better aligned with upstream and
avoid this type of failures in the future.

-- 
Thanks,
Sasha
