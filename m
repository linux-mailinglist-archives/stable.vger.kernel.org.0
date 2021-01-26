Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67704304067
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392762AbhAZOex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392748AbhAZOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 09:31:29 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E84C061D73
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 06:30:48 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id d15so12265983qtw.12
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 06:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cnQKRa1F2EPOzJJlOmZC39ZEc9CoOc05/pnXM6vhQqM=;
        b=CqAIGBek2YTA0stJ19SPJ0SnPEZycikjeY7CnanSn4ZRyjS3R5O0Jw/kBb6sW+GpNv
         RSntH39V+WBlBz+d0FIDe6vGApF+EXdsRFTY+cP0Y9oLF94KgApG4RRHvWftK2DNqPST
         c9Hqu7nzlOwuNZAIIBmaJyBYWYWc6Npz/1I3rXipdd7ivNUPjRUgkrH/94xqDRegM0ld
         6x3fo/VzwHlIguvgHVzL4v/Qq3Tow3yV9D0MV1Otad59Olqx+ssg5KBujuaEMn8WHbgf
         7oTQPBYVbcMwF+Fz7P8rqcHqJr9S7nvH1Ldm720no8yzgEyNfx8MsDqE1KZawRNoXOa/
         nHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnQKRa1F2EPOzJJlOmZC39ZEc9CoOc05/pnXM6vhQqM=;
        b=PdsV3avlMoVs8ge03jNzwsfEPPG6VuNHQQOmfUNHhWq/u/n2eHQK5llVyUlunBAAo6
         8lY2xCoBaBhsnCNWPEK9fTkitdUKQSdmQde3BdwKqXWO2z4tRcB3/3UEL363y9qaqEgO
         YmAq2EXPLjhtn+Ocusrv7akfuNccMBTZd2sxLWBudWVoSIjjxL62tkwBZhszjQriiLGh
         ei89mJyUuQ7HUOkxE1i/Ag7itx6J6iKEbyF8KrVpe3cfGE3vxO1N64J2YJ1es9xjyoqZ
         XyuWTDpQ4PANcPZPjZI0dPFrLSMBacQWXkJENMw2a30PD6L8ionRMn1hYp09MvUX2mB/
         nzgQ==
X-Gm-Message-State: AOAM530taUI6XUU/UQq2lzxm7BJQ6J8wMiIqJfNtdUGAqVcY49JgvjD+
        mp8Wj7+DspvZug0NkJAPJthsraz8BPdcPPb/
X-Google-Smtp-Source: ABdhPJx1dfNA+3TC6TmAw/g8cbA7ibCQPo6igGadI3jLfsIn4j6YIBUeA2X/Atpah6vFvKLsPESV+A==
X-Received: by 2002:aed:2644:: with SMTP id z62mr5394060qtc.146.1611671447521;
        Tue, 26 Jan 2021 06:30:47 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id c12sm13611176qtq.76.2021.01.26.06.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:30:46 -0800 (PST)
Subject: Re: [PATCH] btrfs: avoid double put of block group when emptying
 cluster
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     stable@vger.kernel.org
References: <5ca694ff4f8cff4c0ef6896593a1f1d01fbe956d.1611610947.git.josef@toxicpanda.com>
 <bf8cd92d-12a0-3bb3-34c0-dd9c938bf349@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <ad0ea42a-5e41-f9b9-986d-8c70e9f2eed3@toxicpanda.com>
Date:   Tue, 26 Jan 2021 09:30:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <bf8cd92d-12a0-3bb3-34c0-dd9c938bf349@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 4:02 AM, Nikolay Borisov wrote:
> 
> 
> On 25.01.21 г. 23:42 ч., Josef Bacik wrote:
>> In __btrfs_return_cluster_to_free_space we will bail doing the cleanup
>> of the cluster if the block group we passed in doesn't match the block
>> group on the cluster.  However we drop a reference to block_group, as
>> the cluster holds a reference to the block group while it's attached to
>> the cluster.  If cluster->block_group != block_group however then this
>> is an extra put, which means we'll go negative and free this block group
>> down the line, leading to a UAF.
> 
> Was this found by code inspection or did you hit in production. Also why
> in btrfs_remove_free_space_cache just before
> __btrfs_return_cluster_to_free_space there is:
> 

It was found in production sort of halfway.  I was doing something for WhatsApp 
and had to convert our block group reference counting to the refcount stuff so I 
could find where I made a mistake.  Turns out this was where the problem was, my 
stuff had just made it way more likely to happen.  I don't have the stack trace 
because this was like 6 months ago, I'm going through all my WhatsApp magic and 
getting them actually usable for upstream.

> WARN_ON(cluster->block_group != block_group);
> 
> IMO this patch should also remove the WARN_ON if it's a valid condition
> to have the passed bg be different than the one in the cluster. Also
> that WARN_ON is likely racy since it's done outside of cluster->lock.
> 

Yup that's in a follow up thing, I wanted to get the actual fix out before I got 
distracted by my mountain of meetings this week.  Thanks,

Josef
