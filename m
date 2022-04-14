Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36393500BB6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiDNLCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 07:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiDNLCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 07:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DE621E11
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF936122A
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2EDC385A5;
        Thu, 14 Apr 2022 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933990;
        bh=jvdbVaUuAjapmLAi7lOAyz8pM5TAuWSfm1Wgb4s8J+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yxrHQSkiEfYXdDOUFP/fuYYI0VeAXP3bLm3LmGF1KF9BWW53ik+BYZkw4VKuy5MBN
         VSptusubLz+L4hGLjXqvFOgP6yinV2Kc78lzzrXVQiW5QGatD2z2eFFNXmzgB7hCR3
         KGRQfc3qJz9lZDit72ZCBlDWnFjj49T2bOlOpThM=
Date:   Thu, 14 Apr 2022 12:59:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org, gregory.greenman@intel.com
Subject: Re: [PATCH 5.17] iwlwifi: yoyo: fix DBGI_SRAM ini dump header.
Message-ID: <Ylf+pLW54GU23JNS@kroah.com>
References: <1648991790212197@kroah.com>
 <20220413080600.281718-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220413080600.281718-1-luca@coelho.fi>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 11:06:00AM +0300, Luca Coelho wrote:
> From: Rotem Saado <rotem.saado@intel.com>
> 
> commit 34bc27783a31a05d2fb987d8fa0f4f702efd0359 upstream.
> 
> DBGI SRAM is new type of monitor, therefore it should be
> dump as monitor type with ini dump monitor header.
> 
> Signed-off-by: Rotem Saado <rotem.saado@intel.com>
> Fixes: 89639e06d0f3 ("iwlwifi: yoyo: support for new DBGI_SRAM region")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20220129105618.6c31f6a2dcfc.If311c1d548bc5f7157a449e848ea01f71f5592eb@changeid
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  .../net/wireless/intel/iwlwifi/cfg/22000.c    |  6 ++++
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 29 +++++++++++++++++--
>  .../net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
>  drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  2 ++
>  4 files changed, 36 insertions(+), 2 deletions(-)

Please always test-build your patches before sending them.  This broke
the build:

drivers/net/wireless/intel/iwlwifi/fw/dbg.c:2282:33: error: initialization of ‘void * (*)(struct iwl_fw_runtime *, struct iwl_dump_ini_region_data *, void *)’ from incompatible pointer type ‘void * (*)(struct iwl_fw_runtime *, struct iwl_dump_ini_region_data *, void *, u32)’ {aka ‘void * (*)(struct iwl_fw_runtime *, struct iwl_dump_ini_region_data *, void *, unsigned int)’} [-Werror=incompatible-pointer-types]
 2282 |                 .fill_mem_hdr = iwl_dump_ini_mon_dbgi_fill_header,
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{sigh}

Odds are your other backports will too, so I'm going to ignore them as
well and wait for working ones.
