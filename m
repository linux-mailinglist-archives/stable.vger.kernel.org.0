Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9D67FDF9
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 10:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjA2J5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 04:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjA2J5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 04:57:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C4222EC
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 01:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D108A60B9E
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 09:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A1C433D2;
        Sun, 29 Jan 2023 09:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674986240;
        bh=apEDmRZhX3hyzHCBx6zt5RDKOOhTd7PNbo0vhXbka+U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UkfyTI69OqX/LaUwiUjTKbaYkYGuLR8zZ0+TgaR+4jpF87E7NlZGOtol74V/ByaX5
         gAVp1hIpdpmSj9xOaAtH2YOVXj/C9I6yfgmVqjGGaU00QRhcEAuNAZ4cCEEUbgX3n7
         y0WBep9b8TAbl2NFr4Sh6WdRrvHA0k1PbKCBD3S8espeYklhnMFpvogXFxU0xpN9mn
         kB/Ep7v2xIqAJTp0+xyI9NnaV4gBKDHYSbKe5pQD35Ly+M4pXHYO0yXzmUb098i9nn
         OWhJCkF/gANHHA+p4wBK4qKazZbB8xxyEQAwPMe0RRvX6fsMvMlkOORrWYCUqZQjUt
         BGjk+um2ph+tA==
Message-ID: <fc687ff5-9663-0f80-41d0-f9668c743602@kernel.org>
Date:   Sun, 29 Jan 2023 17:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] f2fs: fix information leak in f2fs_move_inline_dirents()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Alexander Potapenko <glider@google.com>, stable@vger.kernel.org
References: <20230123070414.138052-1-ebiggers@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230123070414.138052-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/23 15:04, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When converting an inline directory to a regular one, f2fs is leaking
> uninitialized memory to disk because it doesn't initialize the entire
> directory block.  Fix this by zero-initializing the block.
> 
> This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
> initializing when converting inline dentry"), which didn't consider the
> security implications of leaking uninitialized memory to disk.
> 
> This was found by running xfstest generic/435 on a KMSAN-enabled kernel.
> 
> Fixes: 4ec17d688d74 ("f2fs: avoid unneeded initializing when converting inline dentry")
> Cc: <stable@vger.kernel.org> # v4.3+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
