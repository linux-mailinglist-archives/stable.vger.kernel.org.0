Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD33D6C9244
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 05:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCZDuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 23:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjCZDuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 23:50:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4824B465;
        Sat, 25 Mar 2023 20:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 421D1CE0DFD;
        Sun, 26 Mar 2023 03:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61959C433EF;
        Sun, 26 Mar 2023 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679802611;
        bh=LAvyz1060gPts0GjgiePob4/2gg+XoL6lIGQJ0eqymE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oMdWRUCI7vyRF/7sNx7BmpUPSljpIETnIY4NiA5GAzheECGpBk25/7+7o5295RqXN
         DblR5G3MGypfWmRuNjyyW29ieZeuOK8s4oDNEJYfnjGpn61Sg5iptF+dDdYLBF5R5W
         ZlOfd2KgN0PjDV1hrQHIhuq89CVpyEOnVrdwQ7u5ohISUNrHYV3rJT8FWu8r/U6hwl
         q/KVL3UcaUzN4Gz3QXU17b+Rd5QA/1c/t1cRSp9dUy0sBwIpuxcTWpwuxtz4joAXus
         IZwYJf53Mesk3Mu75e3lP5ytIdTQItjZ1xGlCjvSqI/Z0N71cwXwkogfC18PXqhcVk
         84vpePlJe7rUg==
Message-ID: <c6a70066-6b23-a1a0-1762-d4b740af1283@kernel.org>
Date:   Sun, 26 Mar 2023 11:50:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [f2fs-dev] [PATCH 2/3 v2] f2fs: factor out discard_cmd usage from
 general rb_tree use
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230313201216.924234-1-jaegeuk@kernel.org>
 <20230313201216.924234-3-jaegeuk@kernel.org> <ZB3Wc6jdbvLiZNl5@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <ZB3Wc6jdbvLiZNl5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/25 0:57, Jaegeuk Kim wrote:
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

