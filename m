Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1A6AFF81
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 08:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCHHNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 02:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCHHNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 02:13:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E4322A1F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 23:13:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3D5D611D8
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5C1C433D2;
        Wed,  8 Mar 2023 07:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678259587;
        bh=86BwgrdtTe7yUiHXE8WjEpVeMs2BETlUnDFVbARJ/7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0BRdstG2z13Jd6t7HQz/Ra6kkRC6fN7BtSemTfqfginDjvwGnwxBYmrqLJt7Mo8nr
         U9TIdQwaWyWsV2xYDh2T9drLlrYfmZp9PE+wUFqf9HW6CIwsGlcIe7sniV9IiJIYCj
         qCY9DhCPzpL+U7+DqVEBm4ImpMFVClPSTStckImY=
Date:   Wed, 8 Mar 2023 08:13:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Colin Foster <colin.foster@in-advantage.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Douglas Anderson <dianders@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Subject: Re: [PATCH 5.15 330/567] driver core: fw_devlink: Add DL_FLAG_CYCLE
 support to device links
Message-ID: <ZAg1f1lArvf7JE9U@kroah.com>
References: <20230307165905.838066027@linuxfoundation.org>
 <20230307165920.205338995@linuxfoundation.org>
 <CAGETcx-sDPx3HySkP-8Rb7TZLZUVP8xTK97Hi2ZJ7PcRva5xkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx-sDPx3HySkP-8Rb7TZLZUVP8xTK97Hi2ZJ7PcRva5xkQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 11:09:01AM -0800, Saravana Kannan wrote:
> On Tue, Mar 7, 2023 at 11:02 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Saravana Kannan <saravanak@google.com>
> >
> > [ Upstream commit 67cad5c67019c38126b749621665b6723d3ae7e6 ]
> >
> > fw_devlink uses DL_FLAG_SYNC_STATE_ONLY device link flag for two
> > purposes:
> >
> > 1. To allow a parent device to proxy its child device's dependency on a
> >    supplier so that the supplier doesn't get its sync_state() callback
> >    before the child device/consumer can be added and probed. In this
> >    usage scenario, we need to ignore cycles for ensure correctness of
> >    sync_state() callbacks.
> >
> > 2. When there are dependency cycles in firmware, we don't know which of
> >    those dependencies are valid. So, we have to ignore them all wrt
> >    probe ordering while still making sure the sync_state() callbacks
> >    come correctly.
> >
> > However, when detecting dependency cycles, there can be multiple
> > dependency cycles between two devices that we need to detect. For
> > example:
> >
> > A -> B -> A and A -> C -> B -> A.
> >
> > To detect multiple cycles correct, we need to be able to differentiate
> > DL_FLAG_SYNC_STATE_ONLY device links used for (1) vs (2) above.
> >
> > To allow this differentiation, add a DL_FLAG_CYCLE that can be use to
> > mark use case (2). We can then use the DL_FLAG_CYCLE to decide which
> > DL_FLAG_SYNC_STATE_ONLY device links to follow when looking for
> > dependency cycles.
> >
> > Fixes: 2de9d8e0d2fe ("driver core: fw_devlink: Improve handling of cyclic dependencies")
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Tested-by: Colin Foster <colin.foster@in-advantage.com>
> > Tested-by: Sudeep Holla <sudeep.holla@arm.com>
> > Tested-by: Douglas Anderson <dianders@chromium.org>
> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
> > Link: https://lore.kernel.org/r/20230207014207.1678715-6-saravanak@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> These fw_devlink patches weren't tested with 5.15. It's also an
> extensive refactor. So I'm a little worried if it'll be finicky and
> break things in a kernel that's a year old.
> 
> Unless someone specifically wants these patches in 5.15, I'd prefer we
> don't pick it up in 5.15.

Good point, I'll go drop this from the 5.15.y queue.

thanks,

greg k-h
