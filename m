Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF80E55DE01
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbiF0Pui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 11:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbiF0Puh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 11:50:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC99192B5;
        Mon, 27 Jun 2022 08:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86B6DB818AB;
        Mon, 27 Jun 2022 15:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECE7C3411D;
        Mon, 27 Jun 2022 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656345034;
        bh=smhJiPhNeK56DLa1ED5m/6stAGXDfLoVRyPY009fBCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/Zlnl9ftTEC/esbyTmyEizmKDCVPAKGwmPwTXlcw2leSWXchVM4/AHPlC8XWbLwU
         njpEh5Ded1dWUNG+o/Hafe9zG+HNVndzwjzJGjRiwD4incqi0QHmNiGLEUBMNxUrIQ
         e6l7UF8OIVqFAKkrY68h0CDaU8NenZQnp7RfhRP4=
Date:   Mon, 27 Jun 2022 17:50:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 097/181] Revert "net/tls: fix tls_sk_proto_close
 executed repeatedly"
Message-ID: <YrnRxxAUbk8fdjac@kroah.com>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.372126973@linuxfoundation.org>
 <20220627083313.285787a5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627083313.285787a5@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 08:33:13AM -0700, Jakub Kicinski wrote:
> On Mon, 27 Jun 2022 13:21:10 +0200 Greg Kroah-Hartman wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > 
> > [ Upstream commit 1b205d948fbb06a7613d87dcea0ff5fd8a08ed91 ]
> > 
> > This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.
> > 
> > This commit was just papering over the issue, ULP should not
> > get ->update() called with its own sk_prot. Each ULP would
> > need to add this check.
> > 
> > Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> Mm? How did 69135c572d1f get into stableh? 
> I reverted it before it hit Linus's tree.
> Don't see the notification about it either.

It is commit 075/181 in this series as you can see here:
	https://lore.kernel.org/r/20220627111946.738369250@linuxfoundation.org
