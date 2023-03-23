Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E376C6ACF
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 15:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCWOWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 10:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCWOWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 10:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F02310D;
        Thu, 23 Mar 2023 07:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D35C9B820D1;
        Thu, 23 Mar 2023 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A6C433EF;
        Thu, 23 Mar 2023 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679581362;
        bh=oLBZ5saccObS7spgsMIqKWYoT4RvPNG3T4ino9R/8ZY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nuLlZifEIypUrr/JFr527EJNPaJFb4L0y4JjGyYA02xIuA4BlL9kGmqwZT8O7t0+8
         Wz0g7aXR4rq2VsWkf3h1Z+jv3nh6stkcw3/DBBj9AQIN75gA8YZ6+t88eHUjASaCEt
         cXvy9zakN1/wo3a4lkko+Ia/X+DhQHu1EDkzfJVj6SDViL3dXqHeoOKxm+xcxDUGi/
         Q4ypRMQo0WzIbPhCsnmZDgkYNHhEo2vBXc/yVsjoiLolv2O1SzcrJcrtDKV/7/kTBo
         0jrdVKdCRkswTxu1/EmobAiNJbNEgtFWhqMjmkAm7JIaKJqawowu04jR94WWKMgPqZ
         S/3sIdyAol7CQ==
Message-ID: <12dfeede-70e3-5c1b-7d3d-9f21c8ee9ff7@kernel.org>
Date:   Thu, 23 Mar 2023 22:22:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: factor out victim_entry usage from
 general rb_tree use
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230313201216.924234-1-jaegeuk@kernel.org>
 <20230313201216.924234-2-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230313201216.924234-2-jaegeuk@kernel.org>
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

On 2023/3/14 4:12, Jaegeuk Kim wrote:
> Let's reduce the complexity of mixed use of rb_tree in victim_entry from
> extent_cache and discard_cmd.
> 
> This should fix arm32 memory alignment issue caused by shared rb_entry.
> 
> [struct victim_entry]              [struct rb_entry]
> [0] struct rb_node rb_node;        [0] struct rb_node rb_node;
>                                         union {
>                                           struct {
>                                             unsigned int ofs;
>                                             unsigned int len;
>                                           };
> [16] unsigned long long mtime;     [12] unsigned long long key;
>                                         } __packed;
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
