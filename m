Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0906A4CE508
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiCENlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:41:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90A32396BC
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A36DC61298
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5DDC004E1;
        Sat,  5 Mar 2022 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646487633;
        bh=KF75qUQ9UJEjxqeZBs9365EAvbYl89BhV2TMzKnVNTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IqNdSAdA6zhk8Xg7Ckr5QT3YgCWb95/fJ4sGFo+aoSwwrI7Okth/UCe21hNNiBkfF
         EwD/n/xdjuHvcUPH2QJreDMMdnm68QQZndkLHbBfXr6DoEujvkVX/f22rzyK2WvQEG
         fVhQlyOiLb17m3KHNDo7SH/ETv6k6spAngxbz3/o=
Date:   Sat, 5 Mar 2022 14:40:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Message-ID: <YiNoTr4uvOSC+RXC@kroah.com>
References: <20220228204915.3261623-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228204915.3261623-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:49:13PM -0800, Jacob Keller wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> 
> [I had to fix the cherry-pick manually as the patch added a line around
> some context that was missing.]
> 
> The VF can be configured via the PF's ndo ops at the same time the PF is
> receiving/handling virtchnl messages. This has many issues, with
> one of them being the ndo op could be actively resetting a VF (i.e.
> resetting it to the default state and deleting/re-adding the VF's VSI)
> while a virtchnl message is being handled. The following error was seen
> because a VF ndo op was used to change a VF's trust setting while the
> VIRTCHNL_OP_CONFIG_VSI_QUEUES was ongoing:
> 
> [35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
> [35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
> [35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6
> 
> Fix this by making sure the virtchnl handling and VF ndo ops that
> trigger VF resets cannot run concurrently. This is done by adding a
> struct mutex cfg_lock to each VF structure. For VF ndo ops, the mutex
> will be locked around the critical operations and VFR. Since the ndo ops
> will trigger a VFR, the virtchnl thread will use mutex_trylock(). This
> is done because if any other thread (i.e. VF ndo op) has the mutex, then
> that means the current VF message being handled is no longer valid, so
> just ignore it.
> 
> This issue can be seen using the following commands:
> 
> for i in {0..50}; do
>         rmmod ice
>         modprobe ice
> 
>         sleep 1
> 
>         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> 
>         ip link set ens785f1 vf 0 trust on
>         ip link set ens785f0 vf 0 trust on
> 
>         sleep 2
> 
>         echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
>         sleep 1
>         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
>         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> 
>         ip link set ens785f1 vf 0 trust on
>         ip link set ens785f0 vf 0 trust on
> done
> 
> Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
> Cc: <stable@vger.kernel.org> # 5.13.x
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> This should apply to 5.13

5.13 is also end-of-life, sorry.
