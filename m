Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825EA53E934
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiFFNZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbiFFNZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:25:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF77B28E32;
        Mon,  6 Jun 2022 06:25:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9DC6A21A38;
        Mon,  6 Jun 2022 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654521914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07kAA0Ftv0j0U7D6cNNh9Bdmf7TtnI/6ZB7Qp5AVBAg=;
        b=dtcgAzdtFALYgeEFnsBKxLhEwspeJKxFYr2UVrwHA/03nr5MCIxoSHuJW4ZLZU4OIvB+dy
        KIYg+e5zNVsxFZqS0dWZmLTgm6nSeFqNxYjcsh3caASZV0wFWSz9vIE5kr/TCM3YCIM9QF
        zfRqM+147aG4aXduDh2HvIW+J6FyMIs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F90B13A5F;
        Mon,  6 Jun 2022 13:25:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C9GqFDoAnmJHTQAAMHmgww
        (envelope-from <nborisov@suse.com>); Mon, 06 Jun 2022 13:25:14 +0000
Message-ID: <e15d486f-6283-3485-d14e-119720c6dec7@suse.com>
Date:   Mon, 6 Jun 2022 16:25:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] btrfs: add error messages to all unrecognized mount
 options
Content-Language: en-US
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220606110819.3943-1-dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <20220606110819.3943-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6.06.22 г. 14:08 ч., David Sterba wrote:
> Almost none of the errors stemming from a valid mount option but wrong
> value prints a descriptive message which would help to identify why
> mount failed. Like in the linked report:
> 
>    $ uname -r
>    v4.19
>    $ mount -o compress=zstd /dev/sdb /mnt
>    mount: /mnt: wrong fs type, bad option, bad superblock on
>    /dev/sdb, missing codepage or helper program, or other error.
>    $ dmesg
>    ...
>    BTRFS error (device sdb): open_ctree failed
> 
> Errors caused by memory allocation failures are left out as it's not a
> user error so reporting that would be confusing.
> 
> Link: https://lore.kernel.org/linux-btrfs/9c3fec36-fc61-3a33-4977-a7e207c3fa4e@gmx.de/
> CC: stable@vger.kernel.org # 4.9+
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
