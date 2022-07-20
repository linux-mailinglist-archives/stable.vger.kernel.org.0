Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2FD57B466
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 12:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiGTKUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 06:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiGTKUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 06:20:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB527DB9;
        Wed, 20 Jul 2022 03:20:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9EF632088D;
        Wed, 20 Jul 2022 10:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658312446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yRNLFALfo3JzdiLRUOet7Bysw0ehkydRnEvlaNcyKw=;
        b=VrgDuenn+USESylfDRGe9sEEG2ADxGr5s+H8S4rAIeBwr2PWEL9K5F3DezqiuxXa+/kXD5
        xY44XBmB2trNe18evZwBgMjdLIMKIVZ+s27M4pHw6IyHfCdXB1hMU4uHimNLyVXh830cp6
        ZE9hZjtF1dGC6PTXCVhst89kzVrHOZo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 678AF13AAD;
        Wed, 20 Jul 2022 10:20:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dz+MFv7W12LcJgAAMHmgww
        (envelope-from <nborisov@suse.com>); Wed, 20 Jul 2022 10:20:46 +0000
Message-ID: <6dd5918a-4d6b-f118-d233-56a865ac0683@suse.com>
Date:   Wed, 20 Jul 2022 13:20:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/3] btrfs: enhance unsupported compat RO flags
 handling
Content-Language: en-US
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1658293417.git.wqu@suse.com>
 <937879049c71370b6a1ca192b67fbcf2989d5915.1658293417.git.wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <937879049c71370b6a1ca192b67fbcf2989d5915.1658293417.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 20.07.22 г. 8:06 ч., Qu Wenruo wrote:
> Currently there are two corner cases not handling compat RO flags
> correctly:
> 
> - Remount
>    We can still mount the fs RO with compat RO flags, then remount it RW.
>    We should not allow any write into a fs with unsupported RO flags.
> 
> - Still try to search block group items
>    In fact, behavior/on-disk format change to extent tree should not
>    need a full incompat flag.
> 
>    And since we can ensure fs with unsupported RO flags never got any
>    writes (with above case fixed), then we can even skip block group
>    items search at mount time.
> 
> This patch will enhance the unsupported RO compat flags by:
> 
> - Reject RW remount if there is unsupported RO compat flags
> 
> - Go dummy block group items directly for unsupported RO compat flags
>    In fact, only changes to chunk/subvolume/root/csum trees should go
>    incompat flags.
> 
> The latter part should allow future change to extent tree to be compat
> RO flags.
> 
> Thus this patch also needs to be backported to all stable trees.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
