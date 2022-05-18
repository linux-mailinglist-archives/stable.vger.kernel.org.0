Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7044652B0F2
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 05:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiERD4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 23:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiERD4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 23:56:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3D92F0;
        Tue, 17 May 2022 20:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5580AB81E68;
        Wed, 18 May 2022 03:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5C9C385AA;
        Wed, 18 May 2022 03:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652846160;
        bh=HdoByi/zUhr+JLFYPlfgIYQGec1a21OZIoDG/tTTYtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZWFnKVyh8Be2jF5K2H8hThsO6wQ3G8KT5xsDUz70vKDlEGUYG/MDgECp90jx5GDu6
         RSnnwXt4hzh8+7PVRNzMq+q/2qtS4Z+B90P2pjNscQGb1c4JKPnAcwtQyGhQcqZFjQ
         BAkqT5/RSP2FgU5bVlNluFlnJrxWZKMbtnueJUeIFXG2Ad3UmiuSBxKMkhaTmOnVmc
         +V1CxDTUsCYPwiYdw3Idg5ui/AZZv+jS7r/nmuX5lEsdHlABBSgKstUD5x3p65bgio
         U67kgY2tzjrFHFxDrY6B6J9biUpfUAfquzsp7pqsjWAXnZEFY22LOuBFAC0g0krkhF
         ehMFhkcwQtK0Q==
Date:   Wed, 18 May 2022 11:55:56 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] platform/chrome: check *dest of memcpy
Message-ID: <YoRuTN3q2WqruIaR@google.com>
References: <20220517095521.6897-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095521.6897-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:55:21PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> In regulator/cros-ec-regulator.c, cros_ec_cmd is sometimes called
> with *indata set to NULL.
> 
> static int cros_ec_regulator_enable(struct regulator_dev *dev){
> ...
>      cros_ec_cmd(data->ec_dev, 0, EC_CMD_REGULATOR_ENABLE, &cmd,
> 			  sizeof(cmd), NULL, 0)
> ...}
> 
> Don't do memcpy if indata is NULL.

The fix makes less sense to me.  Did you find somewhere that `indata` is NULL
but `insize` is not 0?
