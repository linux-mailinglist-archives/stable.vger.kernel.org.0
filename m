Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D019A4E396C
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 08:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiCVHNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 03:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiCVHNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 03:13:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A33261E
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 00:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91488B81BAC
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 07:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8FCC340EC;
        Tue, 22 Mar 2022 07:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647933097;
        bh=2x/89kFR0hFflVkV8SyeWAhJzNlnu2pfg6yL/J4KGHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zhkQI37LhmrrvI2a2lKJsfXL5sK7GgXjB+OwCi4e0r4YG0Wr5bxI8VZ73Rqeuq9Lp
         YNqRTJ737EBikpd7QRIVP3e2SPLx24L+ZDaprmywt/tUGin86/0CvAkjnk+V0bDGqf
         fXTIJlzJvF3TTks8ExwWPL1kYHS/tM9uvBsCey9E=
Date:   Tue, 22 Mar 2022 08:11:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Jordy Zomer <jordy@pwning.systems>, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH] nfc: st21nfca: Fix potential buffer overflows in
 EVT_TRANSACTION
Message-ID: <Yjl2pJ5zL4kw+5eT@kroah.com>
References: <20220111164451.3232987-1-jordy@pwning.systems>
 <20220321174006.47972-1-denis.e.efremov@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321174006.47972-1-denis.e.efremov@oracle.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 08:40:06PM +0300, Denis Efremov wrote:
> From: Jordy Zomer <jordy@pwning.systems>
> 
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
> 
> Link: https://lore.kernel.org/all/20220111164451.3232987-1-jordy@pwning.systems/#t
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Cc: stable@vger.kernel.org # 4.0+
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> ---
> CVE-2022-26490 was assigned to this patch. It looks like it's not in
> the stable trees yet. I only added Link:/Fixes:/Cc: stable... to the
> commit's message.
> 
>  drivers/nfc/st21nfca/se.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

What is the git commit id of this patch in Linus's tree?

And your "To:" line was corrupted, might want to check your email client :(

thanks,

greg k-h
