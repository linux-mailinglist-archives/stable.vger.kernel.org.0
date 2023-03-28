Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91A6CBE7C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjC1MFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjC1MFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0997B86B9;
        Tue, 28 Mar 2023 05:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E319616E9;
        Tue, 28 Mar 2023 12:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35557C433EF;
        Tue, 28 Mar 2023 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680005088;
        bh=QPl8Cb9bKZSsJRqleYqzItXhifD9N0gM81emEwdCt+k=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=PUNcXkN2mrIZ5D2bV+M6jxZPPKO4uR7TgSQfdaKj3kh7P0xO6h3z5nmWPe3B2nP1S
         hxDGT2bv+c40rFJItA8277pubTZf9o+W9uzSivCiu1KSFs5GAp7mNZJNwS66By2gaV
         53T+fUVxwsP+K8V3gE47O8Hnv+U7tCaWg2yeQV7jBq6bFEhVP6A12Ue42tIKyIGGN1
         GL04zhY7E3WVZIJ6jl6Q7xNWM0ZAaKz35FANYgTM8GscfLYPQsim3fPJXLHnS6lsSP
         PeQytv47cQ88dKHS6RJJPYqsCYNUKbd272xZt4SSnYktP9w4fIG+h+b9AkOGhin3bA
         3oQ2hFOweaOYw==
Date:   Tue, 28 Mar 2023 14:04:44 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Tanu Malhotra <tanu.malhotra@intel.com>
cc:     srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, even.xu@intel.com,
        stable@vger.kernel.org, Shaunak Saha <shaunak.saha@intel.com>
Subject: Re: [PATCH v2] HID: intel-ish-hid: Fix kernel panic during warm
 reset
In-Reply-To: <20230327185838.2527560-1-tanu.malhotra@intel.com>
Message-ID: <nycvar.YFH.7.76.2303281404360.1142@cbobk.fhfr.pm>
References: <20230327185838.2527560-1-tanu.malhotra@intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Mar 2023, Tanu Malhotra wrote:

> During warm reset device->fw_client is set to NULL. If a bus driver is
> registered after this NULL setting and before new firmware clients are
> enumerated by ISHTP, kernel panic will result in the function
> ishtp_cl_bus_match(). This is because of reference to
> device->fw_client->props.protocol_name.
> 
> ISH firmware after getting successfully loaded, sends a warm reset
> notification to remove all clients from the bus and sets
> device->fw_client to NULL. Until kernel v5.15, all enabled ISHTP kernel
> module drivers were loaded right after any of the first ISHTP device was
> registered, regardless of whether it was a matched or an unmatched
> device. This resulted in all drivers getting registered much before the
> warm reset notification from ISH.
> 
> Starting kernel v5.16, this issue got exposed after the change was
> introduced to load only bus drivers for the respective matching devices.
> In this scenario, cros_ec_ishtp device and cros_ec_ishtp driver are
> registered after the warm reset device fw_client NULL setting.
> cros_ec_ishtp driver_register() triggers the callback to
> ishtp_cl_bus_match() to match ISHTP driver to the device and causes kernel
> panic in guid_equal() when dereferencing fw_client NULL pointer to get
> protocol_name.
> 
> Fixes: f155dfeaa4ee ("platform/x86: isthp_eclite: only load for matching devices")
> Fixes: facfe0a4fdce ("platform/chrome: chros_ec_ishtp: only load for matching devices")
> Fixes: 0d0cccc0fd83 ("HID: intel-ish-hid: hid-client: only load for matching devices")
> Fixes: 44e2a58cb880 ("HID: intel-ish-hid: fw-loader: only load for matching devices")
> Cc: <stable@vger.kernel.org> # 5.16+
> Signed-off-by: Tanu Malhotra <tanu.malhotra@intel.com>
> Tested-by: Shaunak Saha <shaunak.saha@intel.com>
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs

