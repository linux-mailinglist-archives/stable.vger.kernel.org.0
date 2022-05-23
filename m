Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE600531302
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiEWPQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiEWPQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:16:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA724245A3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE4CB810B3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D04C385A9;
        Mon, 23 May 2022 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653318970;
        bh=ossOfFMkNkplZ24VOjmqipWeY0pD/6/sTd2L2URApOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fj80lp5Fh3FhXchxlrXyP9A6aOcLRJt9YYGwC66fO99r4q/MBrQXkPLhdzlbNf1KG
         bUYm92/hATinPfnoLhXrB7hGT+k5S6RZhs6DX32vheUNAkGdavDzt68IwBfZkRUzVg
         OVLvlum8YF6RxLU2EP5rVvtVLzOQ7tuNbW5NsDPU=
Date:   Mon, 23 May 2022 17:16:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>
Cc:     stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] firmware_loader: use kernel credentials when reading
 firmware
Message-ID: <YoulN3eE37EUncSR@kroah.com>
References: <20220523052444.2421369-1-tweek@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220523052444.2421369-1-tweek@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 03:24:44PM +1000, Thiébaud Weksteen wrote:
> commit 581dd69830341d299b0c097fc366097ab497d679 upstream.
> 
> Device drivers may decide to not load firmware when probed to avoid
> slowing down the boot process should the firmware filesystem not be
> available yet. In this case, the firmware loading request may be done
> when a device file associated with the driver is first accessed. The
> credentials of the userspace process accessing the device file may be
> used to validate access to the firmware files requested by the driver.
> Ensure that the kernel assumes the responsibility of reading the
> firmware.
> 
> This was observed on Android for a graphic driver loading their firmware
> when the device file (e.g. /dev/mali0) was first opened by userspace
> (i.e. surfaceflinger). The security context of surfaceflinger was used
> to validate the access to the firmware file (e.g.
> /vendor/firmware/mali.bin).
> 
> Previously, Android configurations were not setting up the
> firmware_class.path command line argument and were relying on the
> userspace fallback mechanism. In this case, the security context of the
> userspace daemon (i.e. ueventd) was consistently used to read firmware
> files. More Android devices are now found to set firmware_class.path
> which gives the kernel the opportunity to read the firmware directly
> (via kernel_read_file_from_path_initns). In this scenario, the current
> process credentials were used, even if unrelated to the loading of the
> firmware file.
> 
> Signed-off-by: Thiébaud Weksteen <tweek@google.com>
> Cc: <stable@vger.kernel.org> # 5.4
> Reviewed-by: Paul Moore <paul@paul-moore.com>
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>
> Link: https://lore.kernel.org/r/20220502004952.3970800-1-tweek@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/firmware_loader/main.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Now queued up, thanks.

greg k-h
