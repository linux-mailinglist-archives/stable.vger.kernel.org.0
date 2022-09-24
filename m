Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB945E8CB6
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIXMwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIXMwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:52:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8779B2BB09;
        Sat, 24 Sep 2022 05:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42599B80C72;
        Sat, 24 Sep 2022 12:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97759C433C1;
        Sat, 24 Sep 2022 12:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664023966;
        bh=gciZ9wNlGlmVdPTB7MobqtBOhMAqcyRa5gn7TyGTTVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0lFP26fo6xeUC9GgUJ/O8UYXKUkyBsg78y+mQyGpzZWM9FBJFmTLx3bpNfGgI9wYC
         LnbfVNF6CB3wHBWH+z8qAq+qxfI8OovkPd4Veqyw2OtLwyLlnCjmWK3SamDZNKwZ4G
         xxgTqL6khVxz19o5LRPOiL79uF10O0ETa/7RuHDg=
Date:   Sat, 24 Sep 2022 14:52:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] nvmem: core: Fix memleak in nvmem_register()
Message-ID: <Yy79m+NcW2tmbH5E@kroah.com>
References: <20220916120402.38753-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916120402.38753-1-srinivas.kandagatla@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 01:04:02PM +0100, Srinivas Kandagatla wrote:
> From: Gaosheng Cui <cuigaosheng1@huawei.com>
> 
> dev_set_name will alloc memory for nvmem->dev.kobj.name in
> nvmem_register, when nvmem_validate_keepouts failed, nvmem's
> memory will be freed and return, but nobody will free memory
> for nvmem->dev.kobj.name, there will be memleak, so moving
> nvmem_validate_keepouts() after device_register() and let
> the device core deal with cleaning name in error cases.
> 
> Fixes: de0534df9347 ("nvmem: core: fix error handling while validating keepout regions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Hi Greg,
> 
> Here is a fix in nvmem core which can possibly go in next rc.
> Could you please pick this up.

I missed this for 6.0-final, but as it's only on a not-ever-hit error
path, it can wait for 6.1-rc1.

thanks,

greg k-h
