Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0727C6B75C1
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMLSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjCMLSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5965728D38
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 04:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A89B81012
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 11:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC86EC433D2;
        Mon, 13 Mar 2023 11:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678706266;
        bh=vYR45BujtFxjWxeu/RQgwwfMtzRUd4FfSZhpHQ10YPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCHe8F+5Ma7s+0Adc2OpXpquxInQIksU2p+i0ufTNixM8ZvCbWPdRfoVPXNzfAizp
         CkueNx3FB67nJzla7qaZvgH0tWATcfrpfAMH3TpmFeU5GxvRMLicqEPXfVf1AAv8EG
         hfjlyoi4K/hY6l7q8NI4iJQ9CDG8dkys7rYO7BUUkh4vdewGWUr3DCDdkYogPCHN7Q
         4XTgexLQNd4Yh0nBI3lzgNA05UsyL7o1GFdAoGeK89qflSsdcZGFsWP3rHS5Eif3Ai
         MSgknZkH5K89pdMKoc7DttRVH2IOpssPmI67fzJiKsdo83xlTzOIFxZNdQvGo/q8nu
         UmFj04c/1rrfQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgCU-00068E-Ou; Mon, 13 Mar 2023 12:18:47 +0100
Date:   Mon, 13 Mar 2023 12:18:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Look for existing mapping only
 once" failed to apply to 5.15-stable tree
Message-ID: <ZA8GliA5EyxBGSif@hovoldconsulting.com>
References: <167812847919116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167812847919116@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 07:47:59PM +0100, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> git checkout FETCH_HEAD
> git cherry-pick -x 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812847919116@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
> 
> Possible dependencies:
> 
> 6e6f75c9c98d ("irqdomain: Look for existing mapping only once")

Both the below commit and the dependency were ultimately included in
5.15.y, but the initial failure to add them appears to have prevented
the subsequent fixes from being applied.

Specifically, 5.15.y is now missing

	d55f7f4c58c0 ("irqdomain: Refactor __irq_domain_alloc_irqs()")
	601363cc08da ("irqdomain: Fix mapping-creation race")

both which apply fine to the 5.15 stable tree.

Johan

> ------------------ original commit in Linus's tree ------------------
> 
> From 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba Mon Sep 17 00:00:00 2001
> From: Johan Hovold <johan+linaro@kernel.org>
> Date: Mon, 13 Feb 2023 11:42:46 +0100
> Subject: [PATCH] irqdomain: Look for existing mapping only once
> 
> Avoid looking for an existing mapping twice when creating a new mapping
> using irq_create_fwspec_mapping() by factoring out the actual allocation
> which is shared with irq_create_mapping_affinity().
> 
> The new helper function will also be used to fix a shared-interrupt
> mapping race, hence the Fixes tag.
> 
> Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
> Cc: stable@vger.kernel.org      # 4.8
> Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230213104302.17307-5-johan+linaro@kernel.org
