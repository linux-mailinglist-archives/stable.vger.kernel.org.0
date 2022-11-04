Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC66192D3
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 09:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiKDIfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKDIfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 04:35:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2E728E1D;
        Fri,  4 Nov 2022 01:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF0FBB82C3B;
        Fri,  4 Nov 2022 08:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AEFC433C1;
        Fri,  4 Nov 2022 08:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667550914;
        bh=WEjpQeqZ+czaDcqzlymsAPVQX6ISl68VnQ6+y9Js5sw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=HyAgN8rLzX7g0yHlrPl0y581af8e3K+6Wm7HYidgsxo9H8IMp/Ky5UG+CAROOcXGD
         7Yyulk51ozEArph4wGbzfE2Udi5b0oCIykDq3wM6peR8c9/GAIFEPRBr9If9Yjt0tQ
         CthysPqq5nuKeHYeCANYR2btMCpstjCeoZAnELi3GKR/W6DG2Z2EY3DjqXuf7pxDvR
         vIERu5rJS60Q2xlFiA+eMo9nsh1hn3UaNpn66p/pbSIZPBc8vj+brHaNx/UoGfd/iT
         LtBNkO+6GByKoCCyA3N92RQlJOkWvdV5PepNzLQzIJvsMH8S6fJ4Cjhe2CGIG629QO
         W6u99IDs/c6TQ==
Date:   Fri, 4 Nov 2022 09:35:11 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH] HID: wacom: Fix logic used for 3rd barrel switch
 emulation
In-Reply-To: <20221103173304.128651-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2211040934560.29912@cbobk.fhfr.pm>
References: <20221103173304.128651-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Nov 2022, Jason Gerecke wrote:

> From: Jason Gerecke <killertofu@gmail.com>
> 
> When support was added for devices using an explicit 3rd barrel switch,
> the logic used by devices emulating this feature was broken. The 'if'
> statement / block that was introduced only handles the case where the
> button is pressed (i.e. 'barrelswitch' and 'barrelswitch2' are both set)
> but not the case where it is released (i.e. one or both being cleared).
> This results in a BTN_STYLUS3 "down" event being sent when the button
> is pressed, but no "up" event ever being sent afterwards.
> 
> This patch restores the previously-used logic for determining button
> states in the emulated case so that switches are reported correctly
> again.
> 
> Link: https://github.com/linuxwacom/xf86-input-wacom/issues/292
> Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
> CC: stable@vger.kernel.org #v5.19+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs

