Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF368D6DB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjBGMfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjBGMfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C25EF8A;
        Tue,  7 Feb 2023 04:35:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C61661374;
        Tue,  7 Feb 2023 12:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC2C433EF;
        Tue,  7 Feb 2023 12:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675773340;
        bh=B1yqYk/6A/aeLnbi8ZCAvrU/n2HsoZIBq+L0c92QQzA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bv0QIeWKfpn3ZDkjnvuntP2gV7vEJE1EysC1w4rnGp2rmhe26XRim/hzHFFvx42Td
         6amqQ4CjhE+afT1aRClBO3ndLxrMi2Aeh3XMTBS0LvLIEMvwG9fNp8AIqGNTL9tZMV
         mYrwocbvB18T9TOq2F0TKr59Rh3YUGPxyES+z/qPy7O7MJNPKpIgTLwU0KghexeofH
         JovGmKtq9Aa6btDAav1oYCMCMkvYFaRh25ZgNJ3EQUnuBS12fJT80OYCsJzJLeiZVw
         Iq0LgFWReVStAEDUpId322L3JTDjnj+FMlg1sl2QmLcg42r0lt79VIbyrAffaebpCA
         ldZrHQ/BpcNwA==
Message-ID: <97b16883-64ec-ba32-ddf2-656ff7a5fc80@kernel.org>
Date:   Tue, 7 Feb 2023 20:35:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix kernel crash due to null io->bio
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230206034344.724593-1-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230206034344.724593-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/6 11:43, Jaegeuk Kim wrote:
> We should return when io->bio is null before doing anything. Otherwise, panic.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000010
> RIP: 0010:__submit_merged_write_cond+0x164/0x240 [f2fs]
> Call Trace:
>   <TASK>
>   f2fs_submit_merged_write+0x1d/0x30 [f2fs]
>   commit_checkpoint+0x110/0x1e0 [f2fs]
>   f2fs_write_checkpoint+0x9f7/0xf00 [f2fs]
>   ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
>   __checkpoint_and_complete_reqs+0x84/0x190 [f2fs]
>   ? preempt_count_add+0x82/0xc0
>   ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
>   issue_checkpoint_thread+0x4c/0xf0 [f2fs]
>   ? __pfx_autoremove_wake_function+0x10/0x10
>   kthread+0xff/0x130
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x2c/0x50
>   </TASK>
> 
> Cc: stable@vger.kernel.org # v5.18+
> Fixes: 64bf0eef0171 ("f2fs: pass the bio operation to bio_alloc_bioset")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
