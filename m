Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7971C0B54
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgEAAoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAAoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 20:44:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C89C20757;
        Fri,  1 May 2020 00:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588293851;
        bh=P9Ev5x7vbb3vacTNEHEY7X81vZksEt4984EO2CqNHp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spvc3AzL+IMXUFHCnhiaduGAMj1wjR/f51KLiZdxFxSreRimWJIaTGndfcPF2WE6g
         UodRNjvdLmbJBQJ5BaGPzVxcKZE0raPrYoDcPGctZHGk3kWTcxLhg7Phqx6baNorpk
         mNCdV5JbXeXYBoHt+jAwxkLt0tg9wFsXVZ4N0sY0=
Date:   Thu, 30 Apr 2020 20:44:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johannes.berg@intel.com, kvalo@codeaurora.org,
        luciano.coelho@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iwlwifi: mvm: limit maximum queue
 appropriately" failed to apply to 4.19-stable tree
Message-ID: <20200501004410.GC13035@sasha-vm>
References: <1588003092239253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1588003092239253@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 05:58:12PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From e5b72e3bc4763152e24bf4b8333bae21cc526c56 Mon Sep 17 00:00:00 2001
>From: Johannes Berg <johannes.berg@intel.com>
>Date: Fri, 17 Apr 2020 10:08:12 +0300
>Subject: [PATCH] iwlwifi: mvm: limit maximum queue appropriately
>
>Due to some hardware issues, queue 31 isn't usable on devices that have
>32 queues (7000, 8000, 9000 families), which is correctly reflected in
>the configuration and TX queue initialization.
>
>However, the firmware API and queue allocation code assumes that there
>are 32 queues, and if something actually attempts to use #31 this leads
>to a NULL-pointer dereference since it's not allocated.
>
>Fix this by limiting to 31 in the IWL_MVM_DQA_MAX_DATA_QUEUE, and also
>add some code to catch this earlier in the future, if the configuration
>changes perhaps.
>
>Cc: stable@vger.kernel.org # v4.9+
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>Link: https://lore.kernel.org/r/iwlwifi.20200417100405.98a79be2db6a.I3a4af6b03b87a6bc18db9b1ff9a812f397bee1fc@changeid

iwl_mvm_find_free_queue() lives in a different file. Fixed and queued up
for 4.9+.

-- 
Thanks,
Sasha
