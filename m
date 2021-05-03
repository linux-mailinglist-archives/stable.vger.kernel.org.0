Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B19371553
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhECMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:42:08 -0400
Received: from mx.cjr.nz ([51.158.111.142]:15190 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232213AbhECMmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:42:08 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 97B727FC03;
        Mon,  3 May 2021 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620045673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9BkUUc/YwddJxTjYulvJEs1Njtdob0Y85AYgQernRLw=;
        b=J8bJ56Xtl6krlDV5GuXYF9Zc0SvGzv7VTKjl9cERszQqkRo2R/3uqup2BNaP3IrqTL1HHw
        zPvbEICwehftVGYK/emwXUVV8tKuzNje68rzkJHSypH+/RvksAxgwU/RCntcXqq+871CjU
        ip23vJYN0twy+ItIx5vqJx2juOIcI0n/8b3A7EvhCJSKhQHgUGxUI3ciWZmz2neALbAevU
        si2QWvxAPvxdv7Iu+LUfuEOXHz6gHCe4S62zfAjGeE/6Xu873quOISmvzPX8NlHrCEHhDB
        aqtBfjziBBIRnAeUKnEhrbsP1s7IyhfALR1TDBUzQswl5CPYb7dwWZfEzQF1iQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, aaptel@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] cifs: fix regression when mounting shares with prefix
 paths
In-Reply-To: <20210501014005.41545d44@suse.de>
References: <20210430221621.7497-1-pc@cjr.nz> <20210501014005.41545d44@suse.de>
Date:   Mon, 03 May 2021 09:41:08 -0300
Message-ID: <87wnsg2dnf.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Disseldorp <ddiss@suse.de> writes:

> On Fri, 30 Apr 2021 19:16:21 -0300, Paulo Alcantara wrote:
>
>> The commit 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
>> revealed an existing bug when mounting shares that contain a prefix
>> path or DFS links.
>
> Sorry for the mess. One question...
>
> ...
>>  	if (mntopts) {
>>  		char *ip;
>>  
>> -		cifs_dbg(FYI, "%s: mntopts=%s\n", __func__, mntopts);
>>  		rc = smb3_parse_opt(mntopts, "ip", &ip);
>> -		if (!rc && !cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip,
>> -						 strlen(ip))) {
>> -			cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
>> -			return -EINVAL;
>> +		if (!rc) {
>> +			rc = cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip, strlen(ip));
>> +			kfree(ip);
>> +			if (!rc) {
>> +				cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
>> +				return -EINVAL;
>> +			}
>>  		}
>>  	}
>>  
>> @@ -3189,7 +3198,7 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
>>  		return -EINVAL;
>>  	}
>>  
>> -	return rc;
>> +	return 0;
>>  }
>
> It seems that smb3_parse_opt() errors will no longer be propagated here.
> Is that intentional?

That was a mistake, actually.  Will fix it in v2.  Thanks!
