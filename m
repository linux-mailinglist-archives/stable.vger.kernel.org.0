Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD5D523F06
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 22:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347302AbiEKUn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 16:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343539AbiEKUn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 16:43:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B2816D5EC;
        Wed, 11 May 2022 13:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942BFB82613;
        Wed, 11 May 2022 20:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9F8C340EE;
        Wed, 11 May 2022 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652301803;
        bh=xEM/blzijv5Co5pQRjkedHvSJ+0PM6YfCWj1XIj4ZlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rpxV0gia6NaJ/rSETbrV1QhlvcpbI6rQ4WC3j/kvlTk8wpxdDQtIV0XN1IdiKxUPp
         A0Q+IKzDEPf/FGcQlfeJmqf2ZhKSzeddyxPxpXg9wbLQt2D6j6bhCMsHnJjL9S87rd
         7WcNtdTnmCRFW14s29jr20QwAF6X5k9lEx8YusMo=
Date:   Wed, 11 May 2022 13:43:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     Minchan Kim <minchan@kernel.org>, stable@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free
 and page migration
Message-Id: <20220511134322.54c44cb0cdd17a0f7fd9f761@linux-foundation.org>
In-Reply-To: <YnwTfBLn+6vYSe59@sultan-box.localdomain>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
        <Ynv53fkx8cG0ixaE@google.com>
        <YnwTfBLn+6vYSe59@sultan-box.localdomain>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 May 2022 12:50:20 -0700 Sultan Alsawaf <sultan@kerneltoast.com> wrote:

> > Shouldn't the fix be Fixes: 77ff465799c6 ("zsmalloc: zs_page_migrate: skip
> > unnecessary loops but not return -EBUSY if zspage is not inuse)?
> > Because we didn't migrate ZS_EMPTY pages before.
> 
> Hi,
> 
> Yeah, 77ff465799c6 indeed seems like the commit that introduced the bug.

I updated the changelog, thanks.
