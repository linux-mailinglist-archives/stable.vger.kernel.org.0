Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441156073E2
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 11:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiJUJUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 05:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJUJU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 05:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C2A4C616;
        Fri, 21 Oct 2022 02:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5DF9B82B8B;
        Fri, 21 Oct 2022 09:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B8C433D6;
        Fri, 21 Oct 2022 09:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666344001;
        bh=n61WhtB8RDgb/YLx/+f1mYKaXfwPFpMD7fM3DSUCbGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HRubYOAn0g2mvXoP3PuhzS3UzkN/HXpk3plxrTr3UBSCv+6q4lNk+9jHnshNK+Ml/
         asTyszrggGPR7HgHT7yWjrfxHRCrf7pP8uHFfduDzXBiiGkhRu9DYd3TI4WRXorRma
         f4D/T1xSdvW6lTW3Pd+KEsguTNgTARW458iYoPuc9W+9Rg3/QBVDVVV8q6AqyBmMUz
         Ny2xCrbBrCT+x7c/4NjP72w8wMqK54aEXAIwkQ4GMwUhlJt0lR9JLrscSfGySDQ12q
         UTt1rLLNDAwj8kYYNFq46sgjeGAugJgxgbLQa7+cjlcOyJnJweoM0Rdcx874vmVpWl
         Te3o5xCpOzQfQ==
Date:   Fri, 21 Oct 2022 11:19:55 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
Message-ID: <20221021091955.s2kictcxek5e456w@wittgenstein>
References: <20221020160037.4002270-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221020160037.4002270-1-arnd@kernel.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 06:00:29PM +0200, Arnd Bergmann wrote:
> From: Thomas Schmitt <scdbackup@gmx.net>
> 
> Change the return type of function iso_date() from int to time64_t,
> to avoid truncating to the 1902..2038 date range.
> 
> After this patch, the reported timestamps should fall into the
> range reported in the s_time_min/s_time_max fields.
> 
> Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
> Cc: stable@vger.kernel.org
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800627
> Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
> Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
> [arnd: expand changelog text slightly]
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks good to me,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
