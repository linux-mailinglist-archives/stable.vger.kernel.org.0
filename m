Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E968DD60
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 16:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjBGPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBGPzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 10:55:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2FF4687;
        Tue,  7 Feb 2023 07:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 145B2B80AED;
        Tue,  7 Feb 2023 15:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC638C4339C;
        Tue,  7 Feb 2023 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675785350;
        bh=5mhpI+u4oUJT36z1i/S8OyG8M5avFgLEbPsJiJcXGh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HO8mbrNb0EMrF+aeW6Zq9fgZrXW4uWcZHRVsy7+J1WzP71OQzrS2VRoeS+kdjeNZ3
         D3wfAfnTCcw3PDEEhx43sNxLGsCfjeutl/lCPN/fNqyiG3h48JSstX99jLTCieytQZ
         qABTIZlKB18pMVBA6N573zv1e+WpcM9vIeBPuPi0uJQ3oMFUPhPiGxTb9WyiCQTqey
         7wjlONL9aU6C7Mu+e6ka5fLDgRPNbvnR7k91HYEkXoREoXPsLhDgRY6vB6KHGZaK7Q
         Vnp141fW7mI46vU/lNKyqf/JpoLW3Sk8fZqp/7NBaiecWJ7hKuPm9+wTS3YV1+zCcc
         Wqzp/AzEussWA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pPQKW-0002JP-Hx; Tue, 07 Feb 2023 16:56:24 +0100
Date:   Tue, 7 Feb 2023 16:56:24 +0100
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
Message-ID: <Y+J0qHrIcDYSuKKW@hovoldconsulting.com>
References: <20230202155448.6715-1-johan+linaro@kernel.org>
 <20230202155448.6715-2-johan+linaro@kernel.org>
 <efab844a-4ffe-bc68-d99e-8688ad222e3a@quicinc.com>
 <Y+Jqn5/Yt0BaitQd@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Jqn5/Yt0BaitQd@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 04:13:36PM +0100, Johan Hovold wrote:
> On Mon, Feb 06, 2023 at 07:12:43PM -0800, David Collins wrote:
> > On 2/2/23 07:54, Johan Hovold wrote:
> > > Make sure to disable the alarm before updating the four alarm time
> > > registers to avoid spurious alarms during the update.
> > 
> > What scenario can encounter a spurious alarm triggering upon writing the
> > new alarm time inside of pm8xxx_rtc_set_alarm()?
> 
> The alarm is stored in four bytes in little-endian order. Consider
> having had an alarm set and expired at:

This was just supposed to say "Consider having an alarm set at:" as the
alarm must still be enabled. Let me update the example I gave:

Consider having an alarm set at
 
 	10 01 00 00

and now you want to set an alarm at

 	01 02 00 00
 
Unless the alarm is disabled before the update the alarm could go off at
 
 	01 01 00 00
 
after updating the first byte.

Johan
