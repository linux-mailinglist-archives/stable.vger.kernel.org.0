Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C79D646DA7
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiLHK7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiLHK7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:59:18 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ED192A03;
        Thu,  8 Dec 2022 02:51:25 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8B055208AD;
        Thu,  8 Dec 2022 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670496684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSaHkEqadKz6Lj4LX693awEbtIj1UyMwaIh3AiAJ7l0=;
        b=TCQfldZoLzBcalU+ldxeRz8jICL2nDry/ntYAUdvGgipsJwBVmVfbBmzZeHdK5oDK/dODv
        BPKpva7x9xgZh4H46H1+j9Nkb8cbuZkPB/Jy67GHIsiQHnnnxGlz9dA/jO+wJ46gf5++AW
        zWu8AsBqavIBKrjYXie/adLrOf5t1a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670496684;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSaHkEqadKz6Lj4LX693awEbtIj1UyMwaIh3AiAJ7l0=;
        b=Pw8tmZ6Jl716sFYtiV8lkZcndzW3ky7Ka09wMIX04atMtcSl8XXxV+CcsVYN1xBkPslmXq
        q5y89az6rMVvO2BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5163513416;
        Thu,  8 Dec 2022 10:51:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 14wnE6zBkWP6GAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 08 Dec 2022 10:51:24 +0000
Message-ID: <6d13f2ba-7598-4522-e0e6-32f1577a2655@suse.cz>
Date:   Thu, 8 Dec 2022 11:51:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20221128195651.322822-1-Jason@zx2c4.com>
 <Y4zTnhgunXuwVXHe@kernel.org> <Y4zUotH0UeHlRBGP@kernel.org>
 <Y4zxly0XABDg1OhU@zx2c4.com> <Y5Gs9jaSIGTNdRbV@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y5Gs9jaSIGTNdRbV@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/8/22 10:23, Jarkko Sakkinen wrote:
> On Sun, Dec 04, 2022 at 08:14:31PM +0100, Jason A. Donenfeld wrote:
>> > 
>> > Applied to  git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
>> 
>> Oh thank goodness. You'll send this in for rc8 today?
> 
> for 6.2-rc1

Linus took it directly to rc8, so it would conflict now.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.1-rc8&id=23393c6461422df5bf8084a086ada9a7e17dc2ba

> BR, Jarkko

