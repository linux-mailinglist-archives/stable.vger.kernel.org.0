Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFA74B2446
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 12:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiBKL3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 06:29:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiBKL3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 06:29:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0237CE5E
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 03:29:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1537B8286C
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE34C340E9;
        Fri, 11 Feb 2022 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644578967;
        bh=gjtiXdPMflT2FKkDJ9SNKjbTlX4vf8jg3WINRVHAhAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLrMUDyPYQRe4is/ixcCvuJfnfXS8edGuL9lNVORcLjguadMhtRCn6mlobRM7Kmac
         FJoGUl9wRurv3mJuKSUQ3POZxLYT2vX/6pZ5Eb1pVJdA6912cEjWODr/MBcypk6G4K
         4Fthy2nhZeWnKjIFW2905sXrHeKUB7MrGbpBBNI8=
Date:   Fri, 11 Feb 2022 12:29:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uday Shankar <ushankar@purestorage.com>
Cc:     stable@vger.kernel.org,
        Prabhath Sajeepa <psajeepa@purestorage.com>,
        linux-nvme@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Apply "nvme: Fix parsing of ANA log page" to 5.4
Message-ID: <YgZIlVkguNSY/a5u@kroah.com>
References: <20220210001721.GA151884@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210001721.GA151884@dev-ushankar.dev.purestorage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 05:17:21PM -0700, Uday Shankar wrote:
> Hello,
> 
> Please apply the patch "nvme: Fix parsing of ANA log page" to 5.4.
> 
> The commit ID in Linus's tree is:
> 	64fab7290dc3561729bbc1e35895a517eb2e549e
> 
> The patch was originally submitted on the linux-nvme mailing list, but
> for reasons unknown to me it never landed on 5.4 - this thread indicates
> it should have been accepted for 5.4.
> https://lore.kernel.org/linux-nvme/1572303408-37913-1-git-send-email-psajeepa@purestorage.com/T/#u
> 
> Without the patch, we perform the check
> 	WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc))
> at the end of the enclosing loop. This check only makes sense if we are
> about to read another nvme_ana_group_desc from the ana_log_buf, but
> that's not the case at the end of the last iteration of the loop. In the
> last iteration, the warning fires and the function nvme_parse_ana_log
> fails. When nvme native multipath is enabled, this translates into
> failure to establish a connection to the controller.
> 
> The patch fixes the issue by moving the above check to a correct
> position within the loop body.

Now queued up,t hanks.

greg k-h
