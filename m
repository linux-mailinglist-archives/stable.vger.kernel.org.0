Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61054E18C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiFPNMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376854AbiFPNMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:12:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB03286CF
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 06:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DD8DB823A6
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 13:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF80BC34114;
        Thu, 16 Jun 2022 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655385120;
        bh=KyBh+gjPFtvj63Ud5cS3O0GfwZGLtZZEWoDO4cTLWws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s+q47rd2jujEet9/xXVJIOkwV2eZ84wQ3wyFzehQd0IZgavu6fwU4d8LMGj0mjl6K
         RqA5LwL7QjQQJOefufnTxvXzwqsWIG1O6WJNRJazH5JG2o5LBSE71R09mZKhi2BWv+
         XFMs3/mKftyjBSz2psQ2OLHgdqvXtRRan6gFgns8=
Date:   Thu, 16 Jun 2022 15:11:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     stable@vger.kernel.org, groeck@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org
Subject: Re: [PATCH] nfc: st21nfca: fix incorrect sizing calculations in
 EVT_TRANSACTION
Message-ID: <YqssHc1zNhpi9iXe@kroah.com>
References: <20220616032924.3726425-1-mfaltesek@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616032924.3726425-1-mfaltesek@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 10:29:24PM -0500, Martin Faltesek wrote:
> commit f2e19b36593caed4c977c2f55aeba7408aeb2132 upstream.
> 
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seem intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
> 
> The last validation check for transaction->params_len is also incorrect
> since it employs the same accounting error.
> 
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as those checks are
> moved ahead of memory allocation.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> Reviewed-by: Guenter Roeck <groeck@chromium.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Change-Id: I22f9d58293b64566c43a7ba254d9e0e8c4dc35fe

change-id makes no sense for kernel work, sorry.

I'll delete it...

