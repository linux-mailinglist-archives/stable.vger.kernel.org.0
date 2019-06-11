Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E04191E
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 01:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390488AbfFKXrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 19:47:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39406 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387864AbfFKXrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 19:47:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so8427359pfe.6;
        Tue, 11 Jun 2019 16:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=0w5PyTbJcE+7PtxzV1JAmmnhaz4mbqsIEXxhrO8y/nc=;
        b=awiuQUI9gAtnyBWDyPM2oiviNP96T4I/xvCOoYN8SvRkrI3hkL7yO40eUmXFWK9NXe
         n25uEimbmgQMRIUwQDsK7uB9FzGqunzfIyhc9Jpja6faHqQNVtUUILNUmMz4VmvWRbcU
         88M/QCEJG6n31wDtCi6remU5Gm015Z5iHY4lep5y2jXRhNQ2tHjYYf2RrT1Izv7cW7lD
         zCjccDTXUo6rX3ThwVJzKbu5GhA9LE0PSUSLx7oW5AjqKRJTWrE3hXGOFuRkD/Sxa8Yy
         a/sgSvbiRJU6W7/jOIq9kmxRuHZKgbQvDGHDqPeGBnYxPp1FDtXz8gSEjgLvy1OQygxU
         7K9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0w5PyTbJcE+7PtxzV1JAmmnhaz4mbqsIEXxhrO8y/nc=;
        b=ojhq0ImAOWHYNHMvv2yf4vIPSM3yGybHm25YLgg5PEDqV3HWW5t92V7kqInaM9AFPU
         IFseO40qHFu1PfAsOBpZq1cTis8vZaEsHPdcmCl2yxPQ/gQsFBHVcLGCr/Z6A0OCX2o+
         PrydeHt1QmwPxLxRiEO0LRyhIFENo54ZEoItKRFtPbp+/WpoEpuGuG9D9P4iWxDi6CfW
         FlmVV5jIO7oVldSc9RvRg/eaxM/X9KnFG/Z1cuLV+lsBe2KfDX7waq+yi2vqEbbHL1mM
         mwLPWmKNPcDlgbDu7OFBBeAUZJZ+0oBgTXAF6Fd45m+VTwZ36evFxBWThLa+Q79hk+SE
         GQ4Q==
X-Gm-Message-State: APjAAAVHGqmsT5bcbtbjUdEY96D3jXhzzoyIrc7JXYwtGigaIGDPCkYH
        1QsmuB/ULpzu75l6YDpFH78AD4Ds
X-Google-Smtp-Source: APXvYqzeIvJOr5WW9SHcd0aMEUsnXezqVeQDxfD8PoMhsBB0v0thKDyGBWGxNbX7Bc3gVOUf0GtrAg==
X-Received: by 2002:a62:2e46:: with SMTP id u67mr82884329pfu.206.1560296830006;
        Tue, 11 Jun 2019 16:47:10 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:cd5b:7c57:228c:7f0a? ([2001:df0:0:200c:cd5b:7c57:228c:7f0a])
        by smtp.gmail.com with ESMTPSA id e4sm21818015pgi.80.2019.06.11.16.47.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:47:08 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1560043151.git.fthain@telegraphics.com.au>
 <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
 <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
 <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com>
Date:   Wed, 12 Jun 2019 11:46:59 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finn,

On 11/06/19 9:33 PM, Finn Thain wrote:
> On Tue, 11 Jun 2019, Michael Schmitz wrote:
>
>> Hi Finn,
>>
>> IIRC I'd tested that change as well - didn't change broken target
>> behaviour but no regressions in other respects. Add my tested-by if
>> needed.
>>
> Unfortunately I can't confirm that this is the same patch as the one you
> tested as I no longer have that commit. But Stan did test a wide variety
> of targets and I'm confident that the reselection code path was covered.
>
No matter - patch applied cleanly to what I'm running on my Falcon, and 
works just fine for now (stresstest will take a few hours to complete). 
And that'll thoroughly exercise the reselection code path, from what 
we've seen before.

Cheers,

     Michael


