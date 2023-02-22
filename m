Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4EF69F2C0
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 11:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBVKer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 05:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjBVKep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 05:34:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C07A36690;
        Wed, 22 Feb 2023 02:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7CFB8114D;
        Wed, 22 Feb 2023 10:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF0FC433D2;
        Wed, 22 Feb 2023 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677062081;
        bh=e8v4XCU1u5r3OOwzPTQbSSDuEJ4FPYol/U8MNPiswxA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=opsIK39NX6Lf2ZzNwo0Y8Av7NYc5IybugBN6KaSePVvOv9JRgp5yeqQzsgi1N+LvA
         xBE+oWyyGZV55UgGTn26nl8/+W04iqgOVK7W7MU1k3RuHO9g4Nql5zmmNIUzv8nmdr
         opiSnsNF5Q4vij0QApB0u0PHKpNb0ad8v1bWFwj4I8bY9wwzeatxxa/cgi/YBtcCVl
         vbfpm6l3E177mXlTCMOJPJwkILeoIQEmzIAgCWFmx0C0bXJKBtk6wgue2cJsC9dVnb
         CN+itborJ48gluiKbqkpNkrmPonAhFs75UyGZiLFOzqgT1fcoQElABcLgYKhS+nzv4
         JvbH/M5NpYtow==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: ath11k: allow system suspend to survive ath11k
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230201183201.14431-1-len.brown@intel.com>
References: <20230201183201.14431-1-len.brown@intel.com>
To:     Len Brown <len.brown@intel.com>
Cc:     rafael@kernel.org, kvalo@codeaurora.org, linux-pm@vger.kernel.org,
        linux-wireless@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Carl Huang <cjhuang@codeaurora.org>, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706207598.17049.13538001164844345072.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 10:34:39 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Len Brown <len.brown@intel.com> wrote:

> When ath11k runs into internal errors upon suspend,
> it returns an error code to pci_pm_suspend, which
> aborts the entire system suspend.
> 
> The driver should not abort system suspend, but should
> keep its internal errors to itself, and allow the system
> to suspend.  Otherwise, a user can suspend a laptop
> by closing the lid and sealing it into a case, assuming
> that is will suspend, rather than heating up and draining
> the battery when in transit.
> 
> In practice, the ath11k device seems to have plenty of transient
> errors, and subsequent suspend cycles after this failure
> often succeed.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=216968
> 
> Fixes: d1b0c33850d29 ("ath11k: implement suspend for QCA6390 PCI devices")
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: stable@vger.kernel.org

Patch applied to wireless.git, thanks.

7c15430822e7 wifi: ath11k: allow system suspend to survive ath11k

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230201183201.14431-1-len.brown@intel.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

