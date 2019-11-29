Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D1810D4DF
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 12:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfK2Lbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 06:31:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24775 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726215AbfK2Lbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 06:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575027092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdpoK6aXLSJcDdFCbNgtPgEP940wC0mFml1bPEtXfps=;
        b=aGeXFEDaYz4e4ngCuRl/PeqblSm0wm1x4RAtHIsvWD/eZ0VcAVctQt1WFZiDR+vUPnVCA0
        kGDq97GrfpI6JFVOwodyRAkmKE7cmav77dyxO/+kFmcvwfiFjo4AKUn5RYS2asISrKXq2/
        73GgVY8Xtz1cwwVardcB/fCqSCxXeJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-18R8PMqJNYSHFKnv-xroYA-1; Fri, 29 Nov 2019 06:31:31 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE4A593A0;
        Fri, 29 Nov 2019 11:31:30 +0000 (UTC)
Received: from [10.33.36.147] (unknown [10.33.36.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDB1519C4F;
        Fri, 29 Nov 2019 11:31:28 +0000 (UTC)
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-3-mszeredi@redhat.com>
From:   Andrew Price <anprice@redhat.com>
Message-ID: <8694f75f-e947-d369-6be3-b08287c381e9@redhat.com>
Date:   Fri, 29 Nov 2019 11:31:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191128155940.17530-3-mszeredi@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 18R8PMqJNYSHFKnv-xroYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/11/2019 15:59, Miklos Szeredi wrote:
> String options always have parameters, hence the check for optional
> parameter will never trigger.
> 
> Check for param type being a flag first (flag is the only type that does
> not have a parameter) and report "Missing value" if the parameter is
> mandatory.
> 
> Tested with gfs2's "quota" option, which is currently the only user of
> fs_param_v_optional.

It's not clear to me what the bug is here. My tests with the quota 
option are giving expected results. Perhaps I missed a case?

Andy

> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Andrew Price <anprice@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Fixes: 31d921c7fb96 ("vfs: Add configuration parser helpers")
> Cc: <stable@vger.kernel.org> # v5.4
> ---
>   fs/fs_parser.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fs_parser.c b/fs/fs_parser.c
> index d1930adce68d..5d8833d71b37 100644
> --- a/fs/fs_parser.c
> +++ b/fs/fs_parser.c
> @@ -127,13 +127,15 @@ int fs_parse(struct fs_context *fc,
>   	case fs_param_is_u64:
>   	case fs_param_is_enum:
>   	case fs_param_is_string:
> -		if (param->type != fs_value_is_string)
> -			goto bad_value;
> -		if (!result->has_value) {
> +		if (param->type == fs_value_is_flag) {
>   			if (p->flags & fs_param_v_optional)
>   				goto okay;
> -			goto bad_value;
> +
> +			return invalf(fc, "%s: Missing value for '%s'",
> +				      desc->name, param->key);
>   		}
> +		if (param->type != fs_value_is_string)
> +			goto bad_value;
>   		/* Fall through */
>   	default:
>   		break;
> 

