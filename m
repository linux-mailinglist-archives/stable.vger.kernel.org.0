Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA4529F56
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiEQKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344271AbiEQKY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA2613CEC;
        Tue, 17 May 2022 03:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58B3FB81822;
        Tue, 17 May 2022 10:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDF8C385B8;
        Tue, 17 May 2022 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652783033;
        bh=rReOvOmhDEHjFGqHgf89jVP6b2wbvBVISjGbIlFVMfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ax+B0LvHN+fGTU2qRbOnMAeBdyPtqmbOWfX91NMKl4fyZ30ALqFs/H4jGul7dNMsH
         Giy0aYr0b7toT8SaD8XiFejt3j8hpPGPX2kKHCVqiM0QALP6zwBGLCjp7WlZFO+OBa
         32lZwWUakuJ4cNHG9qOqvnO9Hdtz9Uo0eBy/AtHQ=
Date:   Tue, 17 May 2022 12:23:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] platform/chrome: check *dest of memcpy
Message-ID: <YoN3su+KZFwjypXc@kroah.com>
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
> 
> Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
> ---
>  drivers/platform/chrome/cros_ec_proto.c | 2 +-
>  drivers/regulator/cros-ec-regulator.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index c4caf2e2de82..da175c57cff7 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -938,7 +938,7 @@ int cros_ec_command(struct cros_ec_device *ec_dev,
>  	if (ret < 0)
>  		goto error;
>  
> -	if (insize)
> +	if (indata && insize)
>  		memcpy(indata, msg->data, insize);
>  error:
>  	kfree(msg);
> diff --git a/drivers/regulator/cros-ec-regulator.c b/drivers/regulator/cros-ec-regulator.c
> index c4754f3cf233..1c7ff085e492 100644
> --- a/drivers/regulator/cros-ec-regulator.c
> +++ b/drivers/regulator/cros-ec-regulator.c
> @@ -44,7 +44,7 @@ static int cros_ec_cmd(struct cros_ec_device *ec, u32 version, u32 command,
>  	if (ret < 0)
>  		goto cleanup;
>  
> -	if (insize)
> +	if (indata && insize)
>  		memcpy(indata, msg->data, insize);
>  
>  cleanup:
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
