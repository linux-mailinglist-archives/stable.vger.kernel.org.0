Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ACD5E93E0
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIYPUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIYPUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 11:20:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2115A167C7;
        Sun, 25 Sep 2022 08:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68190CE0A89;
        Sun, 25 Sep 2022 15:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E17C433D6;
        Sun, 25 Sep 2022 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664119205;
        bh=aURnhK9kMYS0OZtAzceuko12dbf7YSn5f2cr1o3GkGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4QeUVozDQbmrGGnMpPGKzEBluDS5rYPSBHMgu8CoyrAl9QEtu88KtpjKnB+TWm9h
         k8BDTZMDHLdASp91kgbQI6hHhOU+OoPMuE7PiyaPo26mJzC+gAJgcJ3GhA4TaOctKy
         +y0SNvGMEZcA1yuN4hfBjjxJwdN+doqQITOn196HQTmYzpr5yKqJCfUMmMw3VB2cYC
         86o4KsCJH9ycX2MdyALEGoT/UrqT51J3FIMaGUMuaFMPVRurx1HWYwnRGhQEDuebr/
         l+e99yDqV+vfDo2hjnmyVAaZL+qvHbCO4dLgskm3JbxwGd3+H8B5fhkBRYvcuIN3UA
         fSvgKELtaHUkw==
Date:   Sun, 25 Sep 2022 11:20:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 5.10 25/39] Revert "serial: 8250: Fix reporting real
 baudrate value in c_ospeed field"
Message-ID: <YzBxpId55dT2eU6C@sashalap>
References: <20220921153645.663680057@linuxfoundation.org>
 <20220921153646.560456712@linuxfoundation.org>
 <20220921200502.GA32055@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220921200502.GA32055@duo.ucw.cz>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 10:05:02PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Johan Hovold <johan@kernel.org>
>>
>> commit d02b006b29de14968ba4afa998bede0d55469e29 upstream.
>>
>> This reverts commit 32262e2e429cdb31f9e957e997d53458762931b7.
>>
>> The commit in question claims to determine the inverse of
>> serial8250_get_divisor() but failed to notice that some drivers override
>> the default implementation using a get_divisor() callback.
>
>I believe it would be better to remove bad commit and its revert,
>since it was not yet released.

No - this way we can track the story of the commit. If someone shows up
a year from now and asks why this certain patch isn't in -stable it's
much easier to answer that (and not to queue it up by mistake).

-- 
Thanks,
Sasha
