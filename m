Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FA568DCA7
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 16:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjBGPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 10:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjBGPNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 10:13:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0C019A;
        Tue,  7 Feb 2023 07:13:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2801CE1DCE;
        Tue,  7 Feb 2023 15:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF6DC433EF;
        Tue,  7 Feb 2023 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675782782;
        bh=+iuzdFRsNhoD92k7qzMiT68UuchzgtnGrtdx2uA8Hv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUSONOSW6adCrv+WlH69HNhsmO3faIP8fMgeX0M9DuTQZkhY/N1r7gRvXxZKgY7/m
         WhmMzilQ2i0HoACidLaqU2eq2EXdkyXtL8WQvLXbst4yFPxk4ne5xW4LYCn7jpqOfJ
         UZzv4nACdlPwkM9nEwxHyyqs6C3uTOWfSkgki5ubGY1afI8wOq/MVcXu4fyVOCxJAx
         Pqbfv2jmZeFU7naTCoh4yxB18omZhmSrCmx0iLVGMC9Es744evJRWfP5a6orkmHuG3
         dK4vMbfzUwlGWT34DUxJDuXKawfVb7nER+18+GALur0PsIjgmKNMXHxlY535mJctxf
         8XMlk8guSO7IA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pPPf5-00027L-Nn; Tue, 07 Feb 2023 16:13:36 +0100
Date:   Tue, 7 Feb 2023 16:13:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     David Collins <quic_collinsd@quicinc.com>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        linux-arm-msm@vger.kernel.org, linux-rtc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 01/22] rtc: pm8xxx: fix set-alarm race
Message-ID: <Y+Jqn5/Yt0BaitQd@hovoldconsulting.com>
References: <20230202155448.6715-1-johan+linaro@kernel.org>
 <20230202155448.6715-2-johan+linaro@kernel.org>
 <efab844a-4ffe-bc68-d99e-8688ad222e3a@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efab844a-4ffe-bc68-d99e-8688ad222e3a@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 07:12:43PM -0800, David Collins wrote:
> On 2/2/23 07:54, Johan Hovold wrote:
> > Make sure to disable the alarm before updating the four alarm time
> > registers to avoid spurious alarms during the update.
> 
> What scenario can encounter a spurious alarm triggering upon writing the
> new alarm time inside of pm8xxx_rtc_set_alarm()?

The alarm is stored in four bytes in little-endian order. Consider
having had an alarm set and expired at:

	00 01 00 00

and now you want to set an alarm at

	01 02 00 00

Unless the alarm is disabled before the update the alarm could go off at

	01 01 00 00

after updating the first byte.
 
> > Note that the disable needs to be done outside of the ctrl_reg_lock
> > section to prevent a racing alarm interrupt from disabling the newly set
> > alarm when the lock is released.
> 
> What scenario shows the IRQ race issue that you mentioned?  How does not
> protecting this register write with a lock avoid the race condition?

If a previously set alarm goes off after disabling interrupts but before
disabling the alarm inside the critical section, then that interrupt
could be serviced as soon as interrupts are re-enabled and the handler
would disable the newly set alarm.

> > Fixes: 9a9a54ad7aa2 ("drivers/rtc: add support for Qualcomm PMIC8xxx RTC")
> > Cc: stable@vger.kernel.org      # 3.1
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  drivers/rtc/rtc-pm8xxx.c | 24 ++++++++++--------------
> >  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> Note that since locking is removed later in the patch series, my
> questions above are mainly for the sake of curiosity.

Johan
