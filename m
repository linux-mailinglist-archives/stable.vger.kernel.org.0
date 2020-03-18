Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B371898C0
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCRKCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:02:04 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:47350 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727281AbgCRKCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 06:02:03 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 657F02E15CC;
        Wed, 18 Mar 2020 13:02:00 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id tp1R23B0QU-1xfe8Xmc;
        Wed, 18 Mar 2020 13:02:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1584525720; bh=/xw7fW2pdFx89LSiwTXQJ76K5tu31uzu2W1LtK1icL8=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=BYDtUQgAe4seyUyGP7FUF0T0PafYN1Rox75Oj9CntAoOAtdrUUGs2IMGOwozn8I+t
         rnz3Ld/3IU9EMOnrW2bwnJ3n6dOx1g0z7ZqE5Gs9pzY3FT2Ax/aHMLf87JArGdTz+Q
         X0ZOekAWilsqjKlny93+5FfcvyVRJI231frQhDO4=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:6709::1:1])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id poCWEyjx0B-1xcitWcE;
        Wed, 18 Mar 2020 13:01:59 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 4.19 03/89] cgroup, netclassid: periodically release
 file_lock on classid updating
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
References: <20200317103259.744774526@linuxfoundation.org>
 <20200317103300.173739219@linuxfoundation.org>
 <20200318090253.GA32397@duo.ucw.cz>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <2f3e0bdb-5c5f-541a-486e-b6385ad600bb@yandex-team.ru>
Date:   Wed, 18 Mar 2020 13:01:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200318090253.GA32397@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/03/2020 12.02, Pavel Machek wrote:
> Hi!
> 
>> From: Dmitry Yakunin <zeil@yandex-team.ru>
>>
>> [ Upstream commit 018d26fcd12a75fb9b5fe233762aa3f2f0854b88 ]
> ...
>> Now update is non atomic and socket may be skipped using calls:
>>
>> dup2(oldfd, newfd);
>> close(oldfd);
>>
>> But this case is not typical. Moreover before this patch skip is possible
>> too by hiding socket fd in unix socket buffer.
> 
> Dunno. This makes interface even more interesting.

This is part of brilliant cgroup-v1 design. =)
Cgroup-v2 doesn't recolor sockets when task is moved.

> 
>> +
>>   static int update_classid_sock(const void *v, struct file *file, unsigned n)
>>   {
>>   	int err;
>> +	struct update_classid_context *ctx = (void *)v;
>>   	struct socket *sock = sock_from_file(file, &err);
>>
> ...
>> +	if (--ctx->batch == 0) {
>> +		ctx->batch = UPDATE_CLASSID_BATCH;
>> +		return n + 1;
>> +	}
>>   	return 0;
>>   }
> 
> We take "const void *" and then write to it. That's asking for
> trouble... right? Should the const annotation be removed, at least for
> sake of humans trying to understand the code?

Indeed, there is no much sense in opaque const void *.
This is how iterate_fd() is declared.

> 
> Best regards,
> 									Pavel
> 
