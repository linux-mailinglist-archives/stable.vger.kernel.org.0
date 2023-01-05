Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372AF65EA34
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 12:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjAELux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 06:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjAELut (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 06:50:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6483732EA6
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 03:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C062B81AB7
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 11:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7C9C433EF;
        Thu,  5 Jan 2023 11:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672919445;
        bh=9fOpU/v07ryFsz4CpBnPO4r0PZE5llczH03XZuW6etQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uWLPlQosEpiNN1aJ5i5y+yDDP1v+kEqSpks6Ea1cPMk/tsNavMN6sLiqqIcsKFDMy
         7DR3I8ilmWPixrb6vtE0vqZCdgaWbE/LBo40/Q6H6WljlqFrjKL/FGQrThVtQmeyiz
         qlZ2XrK3YE2PeJfl+gYVSx5YD1JfAAex3fm1M+zA=
Date:   Thu, 5 Jan 2023 12:50:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     mhiramat@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org,
        zanussi@kernel.org
Subject: Re: [PATCH 5.15] tracing: Fix issue of missing one synthetic field
Message-ID: <Y7a5kA9o/wrYrX2Y@kroah.com>
References: <16728414332518@kroah.com>
 <20230105035452.3092172-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105035452.3092172-1-zhengyejian1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 11:54:52AM +0800, Zheng Yejian wrote:
> [ Upstream commit ff4837f7fe59ff018eca4705a70eca5e0b486b97 ]
> 
> The maximum number of synthetic fields supported is defined as
> SYNTH_FIELDS_MAX which value currently is 64, but it actually fails
> when try to generate a synthetic event with 64 fields by executing like:
> 
>   # echo "my_synth_event int v1; int v2; int v3; int v4; int v5; int v6;\
>    int v7; int v8; int v9; int v10; int v11; int v12; int v13; int v14;\
>    int v15; int v16; int v17; int v18; int v19; int v20; int v21; int v22;\
>    int v23; int v24; int v25; int v26; int v27; int v28; int v29; int v30;\
>    int v31; int v32; int v33; int v34; int v35; int v36; int v37; int v38;\
>    int v39; int v40; int v41; int v42; int v43; int v44; int v45; int v46;\
>    int v47; int v48; int v49; int v50; int v51; int v52; int v53; int v54;\
>    int v55; int v56; int v57; int v58; int v59; int v60; int v61; int v62;\
>    int v63; int v64" >> /sys/kernel/tracing/synthetic_events
> 
> Correct the field counting to fix it.
> 
> Link: https://lore.kernel.org/linux-trace-kernel/20221207091557.3137904-1-zhengyejian1@huawei.com
> 
> Cc: <mhiramat@kernel.org>
> Cc: <zanussi@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: c9e759b1e845 ("tracing: Rework synthetic event command parsing")
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> [Fix conflict due to lack of c24be24aed405d64ebcf04526614c13b2adfb1d2]
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/trace/trace_events_synth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
