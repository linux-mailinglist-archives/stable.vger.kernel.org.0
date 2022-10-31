Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB2613153
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJaHl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJaHlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6301097
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B733560FD3
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1FCC433D6;
        Mon, 31 Oct 2022 07:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667202114;
        bh=6VVTNOcpbGdlh98LxCTem5MiGPImXftwBjqM1NLm5e0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oln6SuFfEnxBdR4JOy9OMKPUe6uL8myts0Sfz3LrqkP6LmweXRCKbnuuLQMQXiSE4
         qfwrqe8MW1NbP5ZbttBfQga/CAFjetB1d7HbK6ycEod1stsdY9fZCXKDyBpaaDFsQx
         ideVS8Rx8W4Nbwud2SGVVoWVdFytWq+Pap5y1ut0=
Date:   Mon, 31 Oct 2022 08:42:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     stable@vger.kernel.org, lcapitulino@gmail.com,
        chenzhou10@huawei.com, lizefan.x@bytedance.com, mkoutny@suse.com,
        tj@kernel.org
Subject: Re: [PATCH stable 5.4] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Message-ID: <Y198V9XXl62YfLTG@kroah.com>
References: <20221028191113.14053-1-luizcap@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028191113.14053-1-luizcap@amazon.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 07:11:13PM +0000, Luiz Capitulino wrote:
> From: Chen Zhou <chenzhou10@huawei.com>
> 
> Commit 61e960b07b637f0295308ad91268501d744c21b5 upstream.
> 
> [ This backport uses invalf() instead of invalfc() since the latter is
>   only available starting with v5.6 ]
> 
> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
> all available controllers will be attached.
> For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
> mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
> enabled controllers will be attached except cpu.
> 
> Fix this by adding disabled controller check in cgroup1_parse_param().
> If the specified controller is disabled, just return error with information
> "Disabled controller xx" rather than attaching all the other enabled
> controllers.
> 
> Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> Reviewed-by: Zefan Li <lizefan.x@bytedance.com>
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
> ---
>  kernel/cgroup/cgroup-v1.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> Reviewers,
> 
> Only 5.4-stable is affected. The issue was introduced in 5.1 and fixed
> by Chen in 5.11 and 5.10-stable.
> 
> I tested the same reproducer on Amazon Linux 2 as described in the
> commit message (well, except that I used the cpuset controller).

Now queued up, thanks.

greg k-h
