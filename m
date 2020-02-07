Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053BE1559F8
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 15:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgBGOrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 09:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGOrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 09:47:42 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9EB20720;
        Fri,  7 Feb 2020 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581086862;
        bh=78E8bx+aEJWfnalPJN2FgX8UCelWHY/ZMQW4TN6udxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dq+rSOHvHLCUc98GvyGjfS4sO8dZJRE7G0q58ADPRc8PfWlPXAnWYcqb5gkK3ziXh
         fQH/WSBX1uYKiQNSdaotW6/KLpAwhS0YUtWgW27cN9nVBuSDQQD64JwJzNazY9hFvZ
         7YNLT220Mzm+wYJ5am15+6D3AOEaNiSsoJhKinRs=
Date:   Fri, 7 Feb 2020 09:47:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        kai.vehmanen@linux.intel.com, tiwai@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: core: release resources on
 errors in" failed to apply to 5.5-stable tree
Message-ID: <20200207144741.GV31482@sasha-vm>
References: <1581065627242228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581065627242228@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 09:53:47AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 410e5e55c9c1c9c0d452ac5b9adb37b933a7747e Mon Sep 17 00:00:00 2001
>From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>Date: Fri, 24 Jan 2020 15:36:21 -0600
>Subject: [PATCH] ASoC: SOF: core: release resources on errors in
> probe_continue
>
>The initial intent of releasing resources in the .remove does not work
>well with HDaudio codecs. If the probe_continue() fails in a work
>queue, e.g. due to missing firmware or authentication issues, we don't
>release any resources, and as a result the kernel oopses during
>suspend operations.
>
>The suggested fix is to release all resources during errors in
>probe_continue(), and use fw_state to track resource allocation
>state, so that .remove does not attempt to release the same
>hardware resources twice. PM operations are also modified so that
>no action is done if DSP resources have been freed due to
>an error at probe.
>
>Reported-by: Takashi Iwai <tiwai@suse.de>
>Co-developed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>Bugzilla:  http://bugzilla.suse.com/show_bug.cgi?id=1161246
>Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>Reviewed-by: Takashi Iwai <tiwai@suse.de>
>Link: https://lore.kernel.org/r/20200124213625.30186-4-pierre-louis.bossart@linux.intel.com
>Signed-off-by: Mark Brown <broonie@kernel.org>
>Cc: stable@vger.kernel.org

Conflict due to missing 285880a23d10 ("ASoC: SOF: Make creation of
machine device from SOF core optional") and a "random" space added in
this commit. Cleaned up and queued for 5.5 and 5.4.

-- 
Thanks,
Sasha
