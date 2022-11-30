Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27963D400
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiK3LJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiK3LJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:09:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD9F220E4;
        Wed, 30 Nov 2022 03:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6C17B81AC8;
        Wed, 30 Nov 2022 11:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4421AC433C1;
        Wed, 30 Nov 2022 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669806583;
        bh=ocPZhZgzoPIVfxsA4toGQ0IWxLCIQtMwwZ9pKtidytE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YaNqiWxk5onijvPaHZ5T1WndtTkIwLqtTg7g62uxDlS+P60MGMJJjOtJWdRCqgP/n
         YW4RjbCtAqNJhiPHoUgYEtGRH98991uNxFS1CEZJ7Eg6lsH+8g7Cq8HO1wFY7boa/e
         jpe4ZtarsDM47lo85uMuDlkBHgTjOaut9DNZB0R4=
Date:   Wed, 30 Nov 2022 12:09:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ji-Ze Hong <hpeter@gmail.com>
Subject: Re: [PATCH] USB: serial: f81232: fix division by zero on line-speed
 change
Message-ID: <Y4c59EVP+0lb4ZHI@kroah.com>
References: <20221129141749.15270-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141749.15270-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 03:17:49PM +0100, Johan Hovold wrote:
> The driver leaves the line speed unchanged in case a requested speed is
> not supported. Make sure to handle the case where the current speed is
> B0 (hangup) without dividing by zero when determining the clock source.
> 
> Fixes: 268ddb5e9b62 ("USB: serial: f81232: add high baud rate support")
> Cc: stable@vger.kernel.org      # 5.2
> Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
