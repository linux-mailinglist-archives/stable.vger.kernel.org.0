Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40D12E31DB
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 17:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgL0Ql6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 11:41:58 -0500
Received: from meesny.iki.fi ([195.140.195.201]:40850 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgL0Ql6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 11:41:58 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Dec 2020 11:41:57 EST
Received: from [IPv6:2001:14ba:a809:f00:365c:2bfe:5f3f:873c] (d1yft0yb2nt1-835-t80y-3.rev.dnainternet.fi [IPv6:2001:14ba:a809:f00:365c:2bfe:5f3f:873c])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jussi.kivilinna)
        by meesny.iki.fi (Postfix) with ESMTPSA id EE62820179;
        Sun, 27 Dec 2020 18:32:45 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1609086766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlXVv+khteELPm7l3VGH4hOZK6vW8fOUvcXm9SkA1hw=;
        b=Yz6g4Dq8EbaYJGpO3cY32HjusL9b+6bgm0BKrkj+8EkzsNLrPa7OLxhFf2yTjjJZua+xxP
        61DUD180H0jHPL25zfUrFUYGmSp06EqzjzH51vlC1t7ct2Gki93gDWA96C69Gouksuz5F8
        UkRSrNnNU3GWiUGmF7GaXHupI2KD1ug=
Subject: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux 5.10.3)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
References: <16089960203931@kroah.com>
From:   Jussi Kivilinna <jussi.kivilinna@iki.fi>
Message-ID: <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
Date:   Sun, 27 Dec 2020 18:32:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <16089960203931@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1609086766; a=rsa-sha256; cv=none;
        b=jvepUbUlFHJjledfmThJxzLNBiIH7/UoGrWfN6A0TedxIYUdioFWnjPqoZI/2EvkBLy971
        TUUh+KtHgjfnNr+FfbJLJBwMnhq6bqpp+bcMtpaqtI6SlvnMTqovIITCJ5EYOTFvSuk0Tv
        r4ihzEZn4ctG4W8l6V0Igx0+oXxQnhQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1609086766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlXVv+khteELPm7l3VGH4hOZK6vW8fOUvcXm9SkA1hw=;
        b=gcsBRtzjt06ofXQj890AAUXKEVMTlhc1xJaPXnQl8HpAqhnGcKTMNqBBxwJi8t49Brv39N
        oPc3SMM2/DtN+V2NM3A5XQ4Ia45KNrLnRdVVZXpjaehSaItuYwU+vMWFM3G8GU0hkW9Hid
        9/y3qafzeaS3zK7lbR/nH9rpwzoLZKw=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jussi.kivilinna smtp.mailfrom=jussi.kivilinna@iki.fi
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Now that 5.9 series is EOL, I tried to move to 5.10.3. I ran in to regression where LXC containers do not start with newer kernel. I found that issue had been reported (bisected + with reduced test case) in bugzilla at: https://bugzilla.kernel.org/show_bug.cgi?id=209971

Has this been fixed in 5.11-rc? Is there any patch that I could backport and test with 5.10?

-Jussi

On 26.12.2020 17.20, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.10.3 kernel.
> 
> All users of the 5.10 kernel series must upgrade.
> 
> The updated 5.10.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 
> ------------
