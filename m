Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4988A2454D7
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 01:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHOXHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 19:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgHOXHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Aug 2020 19:07:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F263A206B2;
        Sat, 15 Aug 2020 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597532837;
        bh=vbDlWWWieOXnPlFIM98LP93HYAdkUHUPdDyNGIA1rkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tILIil1E1gh1U4rHqJMpKtxCiRk+RUvOsq7ob2CxNvfn8BOMbjJBfHUXGj6ub45KF
         grpc2EinPRBT71ti9AtpyX04YC2w4U29lRyekgF0Uj+gk6bGvwqV9aNdm3d/PcUSNe
         QkqCc4XQ5JQsc3/W8jPUJH3hLHt/5Gj3sSSmWN+Q=
Date:   Sat, 15 Aug 2020 19:07:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>, jbaron@akamai.com
Subject: Re: [PATCH AUTOSEL 5.7 52/60] dyndbg: prefer declarative init in
 caller, to memset in callee
Message-ID: <20200815230715.GT2975990@sasha-vm>
References: <20200810191028.3793884-1-sashal@kernel.org>
 <20200810191028.3793884-52-sashal@kernel.org>
 <20200811051332.GA1237801@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200811051332.GA1237801@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 07:13:32AM +0200, Greg Kroah-Hartman wrote:
>On Mon, Aug 10, 2020 at 03:10:20PM -0400, Sasha Levin wrote:
>> From: Jim Cromie <jim.cromie@gmail.com>
>>
>> [ Upstream commit 9c9d0acbe2793315fa6945a19685ad2a51fb281b ]
>>
>> ddebug_exec_query declares an auto var, and passes it to
>> ddebug_parse_query, which memsets it before using it.  Drop that
>> memset, instead initialize the variable in the caller; let the
>> compiler decide how to do it.
>>
>> Acked-by: <jbaron@akamai.com>
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> Link: https://lore.kernel.org/r/20200719231058.1586423-10-jim.cromie@gmail.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  lib/dynamic_debug.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
>> index e3755d1f74bd2..4f0bd560478f7 100644
>> --- a/lib/dynamic_debug.c
>> +++ b/lib/dynamic_debug.c
>> @@ -327,7 +327,6 @@ static int ddebug_parse_query(char *words[], int nwords,
>>  		pr_err("expecting pairs of match-spec <value>\n");
>>  		return -EINVAL;
>>  	}
>> -	memset(query, 0, sizeof(*query));
>>
>>  	if (modname)
>>  		/* support $modname.dyndbg=<multiple queries> */
>> @@ -445,7 +444,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
>>  static int ddebug_exec_query(char *query_string, const char *modname)
>>  {
>>  	unsigned int flags = 0, mask = 0;
>> -	struct ddebug_query query;
>> +	struct ddebug_query query = {};
>>  #define MAXWORDS 9
>>  	int nwords, nfound;
>>  	char *words[MAXWORDS];
>> --
>> 2.25.1
>>
>
>There's no need for this in stable kernels, please drop it from
>everywhere.

Dropped, thanks!

-- 
Thanks,
Sasha
