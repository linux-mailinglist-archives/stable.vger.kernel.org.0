Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008334AFAA
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 03:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfFSBr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 21:47:29 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:35343 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSBr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 21:47:29 -0400
Received: by mail-pf1-f180.google.com with SMTP id d126so8711316pfd.2;
        Tue, 18 Jun 2019 18:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EGnqtXQBaeWmXw32rGsxtQhchtdss28MxmZhzIOLjjs=;
        b=KC2Hj1453Y/5FcUyBdbxgA0T+1w8erWs8xcGRcBkMHm+e5I1d062ToRSqaoqM3O7rJ
         6UKUrxzCQn0Wmhmtl9XhBv8tkHRech1WmOdVyELOAQ+VMkoaXkUNlAKpxc5jlrOmoMnw
         E7i7yI7bz3G0S8qmVopWRD4kcIlyAmYJQHPkAyGCFeISYxz9cBhaJcs+jF6mO5MPh9uJ
         VgZ1z/csYvqZOEdpkfFyF+MKRognwPfsDLPjZSpWZ7Thbmix0Zr+tr4ocfGfY4uz3VtX
         WS409hDoH91kvpCHd6FAedI9A51EqT++X2dHyDslUcRD0bcorhcOWNbO3YywLFlu2RE9
         yS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EGnqtXQBaeWmXw32rGsxtQhchtdss28MxmZhzIOLjjs=;
        b=i7gjJc2CkPL2GZ30jQVyFWfEYImg2Rmv1cb6Zi+wiTWGfqZhuZXxtf+ds8N4vz5Vwk
         lkAHste1uHMrSDe7IXeIC0aoiSSTB6lL6XYSpFwpuluV4qoTbcLk1BrQSdJsBUFudctC
         lYQZuNT3/Kuht+B8pY6Rd0Mz5UUFbj9IMCBXM6lomQK6zLxO1Eh2tCDo1KTSdUYvZYTb
         Wf8aEeKwcF/sTStdIWwXWn8ya4sWwTQVcW9LMxKBs24fUdcNsonbZ6KUCgUa4LwkHEwZ
         g1zMrkyAvL/MinPkKzbZZMUQLBTaPahxh0Qem0WT1UF2hY3M8m1CzpJMrjKGvn4xu/6L
         zjvA==
X-Gm-Message-State: APjAAAV73Hs+ySpBe+UIzkRtPbPxF9U28ug2UpNLilzpqhd8bHmLrEQd
        0HweMAbT8RjuJuilvwaKHJK1Gc2t
X-Google-Smtp-Source: APXvYqzltnkDkU7F6t6pF9JPR+2oitR1ROB2GFi4CLsgtr2LT2HXmOWySY3dpsYe9+NJnJIT1zjkzw==
X-Received: by 2002:a63:d24f:: with SMTP id t15mr4859629pgi.301.1560908848117;
        Tue, 18 Jun 2019 18:47:28 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:cdaa:21a1:f5f0:6883? ([2001:df0:0:200c:cdaa:21a1:f5f0:6883])
        by smtp.gmail.com with ESMTPSA id ci15sm8494878pjb.12.2019.06.18.18.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 18:47:27 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1560043151.git.fthain@telegraphics.com.au>
 <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
 <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
 <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
 <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com> <yq1wohixux1.fsf@oracle.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <237c4979-c7ab-22d9-35ca-dda1afab2d11@gmail.com>
Date:   Wed, 19 Jun 2019 13:47:23 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <yq1wohixux1.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Martin,

On 19/06/19 12:47 PM, Martin K. Petersen wrote:
> Michael,
>
>> No matter - patch applied cleanly to what I'm running on my Falcon,
>> and works just fine for now (stresstest will take a few hours to
>> complete). And that'll thoroughly exercise the reselection code path,
>> from what we've seen before.
> How did it go?


Just fine - repeated with different settings for can_queue and 
cmd_per_lun, with not a single hitch. No regression at all.

Cheers,

     Michael



>
