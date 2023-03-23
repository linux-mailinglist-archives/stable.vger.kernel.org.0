Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B386C6B08
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 15:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjCWOb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 10:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCWObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 10:31:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85472A14C;
        Thu, 23 Mar 2023 07:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5270462766;
        Thu, 23 Mar 2023 14:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E407AC433EF;
        Thu, 23 Mar 2023 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679581898;
        bh=Sv3YybIQKDgWMcn1KW6KjvbVZBTE9wL1diTv47fKkqs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gFywPhWzMoKqSKt+w9EW24FI9Ut3lF7kvBz/A9Q7RSqioTBgu8qyebBsk9D5c7lCw
         8mYHdZ32zH6q13p7SUs9vQkPM3J1iRx9GWhaRIBq+FEIJJq/I5mwBTrecnPvggwGDH
         /juttkIXqnaCkT9yvwQtGtD10qz3k6cfXxggcnM/yiBd9SbEy8IF87yWBHh/j8Tft8
         ZCink1m69aeWohxXaDL1ByWTb+ri8aY5Su/odbyVs1FQqc+RDOgUTqYsvk0BgQs/k3
         d0h2Tf3fdIZzFnxK+146+01Vg3/Le3YZRtllkEWH5CVTwVxZILEj6I+jrikAiQz9Ye
         lA3M32DfTDhWQ==
Message-ID: <dabe799f-001d-6514-f18f-16466c11653d@kernel.org>
Date:   Thu, 23 Mar 2023 22:31:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [f2fs-dev] [PATCH 2/3] f2fs: factor out discard_cmd usage from
 general rb_tree use
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230313201216.924234-1-jaegeuk@kernel.org>
 <20230313201216.924234-3-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230313201216.924234-3-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/14 4:12, Jaegeuk Kim wrote:
> This is a second part to remove the mixed use of rb_tree in discard_cmd from
> extent_cache.
> 
> This should also fix arm32 memory alignment issue caused by shared rb_entry.
> 
> [struct discard_cmd]               [struct rb_entry]
> [0] struct rb_node rb_node;        [0] struct rb_node rb_node;
>    union {                              union {
>      struct {                             struct {
> [16]  block_t lstart;              [12]    unsigned int ofs;
>        block_t len;                         unsigned int len;
>                                           };
>                                           unsigned long long key;
>                                         } __packed;
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 004b68621897 ("f2fs: use rb-tree to track pending discard commands")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
