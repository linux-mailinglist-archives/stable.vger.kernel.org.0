Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8271CF4CF
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgELMuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 08:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727859AbgELMuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 08:50:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB78C061A0C;
        Tue, 12 May 2020 05:50:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so6103148pgb.7;
        Tue, 12 May 2020 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nD7mwqL28F/FA8jgIOhguAdsQcCz7IfddsONGZBrF24=;
        b=p6hLAmag7K7kfAUc5kymK52qOL0I6ugxYF9BXaqHpS2n02To3hD7ysF07DwLopImuP
         zDMuZ0X4jIe8Z2siNyHjn9mI1Xrlove8ueVtvI1/MLLcubE7V7nzDS8rGLZFSUmR9BOj
         O3fuHGtcIktnJZ8L/3UBvCSlyY+aZlIjdltezcJoYxtzRF2Qv4yt9kylgqbPkh5iZCeF
         lYRsRArhLI8O0mqDYrnIXlXFj1D7AlqJ8HPjNJMeFGELs0J0ks9XkOTZGoClwr4kWtEv
         Zw0nq89xBTJWEjOOwNsC8no42+H0gQ3QC5DLABnnyJKbK4buokx/8cSB742QBmz20KNn
         yNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nD7mwqL28F/FA8jgIOhguAdsQcCz7IfddsONGZBrF24=;
        b=OyNgPqpEvBiHALzgxmsWB952+P6MVBTx4Tc1K8lp8Hj4+CSGs5DH0p5cdzDL6B9ppp
         CgbeZFC37AJc233549NlNPm3JgzgpOKlxQDfVTfm3s2raec6aAiS7lNYpV3OTgL4VaYs
         fe0M9Y0RhkLIC4N4kbqS3nmSWMNbX5aIp5k974ta42NKEx9VK36FcvHgOY9KuCsxgQ0L
         Y892Loha2ZVK3/8VzS9iaVUOoUyjOlEFepahavp2r84vKJ0xA2Vx9RMDNBci68PDZFNw
         ZadRwdURiWCRmmzMOZ0SBNJlRB8UFouvHGPoRy+srKzuNeALI5IYTEqSfwIRu80qs+3b
         +KgA==
X-Gm-Message-State: AGi0PubKKF+f8kNz5DefYlDOKcXwk1wHfdCOQLx3ndN3eI44pm5g71lg
        qY5FPMI3UC6o5gcuimu7n8Q=
X-Google-Smtp-Source: APiQypK/0dwTmLzbF5cs9Qs4wZwaC8bIwAbNtyrLspPcuLyFKrf4LLSfTVJSe102YLJDWP+/r1tgBg==
X-Received: by 2002:a62:17c3:: with SMTP id 186mr21342719pfx.159.1589287811500;
        Tue, 12 May 2020 05:50:11 -0700 (PDT)
Received: from localhost.localdomain ([124.123.80.46])
        by smtp.gmail.com with ESMTPSA id q62sm7562643pfc.132.2020.05.12.05.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 05:50:10 -0700 (PDT)
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize <
 pagesize
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
 <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
 <20200512114533.GA54730@kroah.com>
From:   Ritesh Harjani <ritesh.list@gmail.com>
Message-ID: <61fb772b-75e2-f391-1a5f-044e573b38f7@gmail.com>
Date:   Tue, 12 May 2020 18:20:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200512114533.GA54730@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

On 5/12/20 5:15 PM, Greg KH wrote:
> On Mon, May 11, 2020 at 01:37:59PM +0530, Ritesh Harjani wrote:
>> Hello stable-list,
>>
>> I think this subjected patch [1] missed the below fixes tag.
>> I guess the subjected patch is only picked for 5.7. And
>> AFAIU, this patch will be needed for 5.6 as well.
>>
>> Could you please do the needful.
>>
>> Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)
>>
>> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1
> 
> This patch does not apply to the 5.6 kernel tree at all.  Please provide
> a working backport if you wish to see it present there.

Sorry if that's the case.
I tried both "git cherry-pick" and "git am" with patch mentioned @ [1]
to apply on branch "remotes/linux-stable/linux-5.6.y" of tree
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
and it applied cleanly.

Also, just noticed this patch in the queue. Is it that maybe you are
trying to apply it twice?

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.6/ext4-don-t-set-dioread_nolock-by-default-for-blocksi.patch

Do let me know if I am missing anything here.

-ritesh
