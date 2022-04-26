Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8350F151
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbiDZGps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245613AbiDZGpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3751FF1EC0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E7B6147B
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE64C385AE;
        Tue, 26 Apr 2022 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650955359;
        bh=n8HSVt9hXiYKFxnlhdXE6sVXrPOQE2ipuCqNqz3/s3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SHvLJpEXj7oxwBHmqOesXz/SGAo0OkVbdk/fZM1TbTnKQNzq+GJM9EZ0q+nedxNTk
         Tn3RyvFli2XfedM19w0GB5LIK1K7iequnTpOmZZ0lJ0JV1IwZBr1p+yzxFxIcOe408
         d+pdi8IlpsCWYl0qudEwX+zWwAV5Fd+fSuQkO2OA=
Date:   Tue, 26 Apr 2022 08:42:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH v5.10] dm: fix mempool NULL pointer race when completing
 IO
Message-ID: <YmeUXC3DZGLPJlWw@kroah.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> Hi

Not really needed in a changelog text :)

> This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> and dm_wait_for_bios_completion") for the kernel 5.10.

Can you just make these 2 different patches?

> 
> The bugs fixed by these patches can cause random crashing when reloading
> dm table, so it is eligible for stable backport.
> 
> This patch is different from the upstream patches because the code
> diverged significantly.
> 

This change is _VERY_ different.  I would need acks from the maintainers
of this code before I could accept this, along with a much more detailed
description of why the original commits will not work here as well.

Same for the other backports.

thanks,

greg k-h
