Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF86656A1
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 10:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjAKI72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 03:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbjAKI7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 03:59:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E77210568
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 00:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF5461AEA
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB4AC433D2;
        Wed, 11 Jan 2023 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673427551;
        bh=6iFVV81L49bpmIaYNQ32xiK9kXUYo4MV/uaBZYW1tIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fn/B/BUyC1W1zxDdN4L+PXJIXxmYql9ecdtSTTVc05C+hdco/SSBnAzOx+TEZRzgY
         XfBtBLCjxbwZZHyDVul2uslTV9bGc4bFr+XrpbV7UKeUz1qTvnJ4NA15bXLA2ZobGc
         bezTkDteDBdYrygdTvTsDW75KWBsIVPTUmLLFWU8=
Date:   Tue, 10 Jan 2023 19:34:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify
 trc_read_check_handler() atomic operations
Message-ID: <Y72vxOQxqtoztLO+@kroah.com>
References: <20230110180031.620810905@linuxfoundation.org>
 <20230110180033.597780936@linuxfoundation.org>
 <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
 <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 01:27:02PM -0500, Joel Fernandes wrote:
> On Tue, Jan 10, 2023 at 1:26 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Paul E. McKenney <paulmck@kernel.org>
> > >
> > > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.
> >
> > Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
> > learn, anything I did wrong or should have done differently?
> 
> Never mind, I think it is just coming from your queue after you picked
> mine up...

Yes, this is the one you sent me to have applied :)
