Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139AC2F562D
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 02:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbhANBoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 20:44:02 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:52363 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbhANBoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 20:44:02 -0500
Received: by mail-pj1-f45.google.com with SMTP id v1so2225755pjr.2;
        Wed, 13 Jan 2021 17:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhGGUKQp3iIGumGW0JSHdb3eHww+a9fUNcP2GsUbZME=;
        b=O0F4Vlc+hvpRo7rOsq6MQye74RWhJvpOXSPSGMDciqccQ52DzAsGu7uZq5DJturXuX
         yr8f+f1zZ685lhSp2LfsDg3MmtfrsXLqdBFUz6H/KDGvkmIJSg6iVxuFo3V0GjyJlOcJ
         qQMlCvgC6KwouJq/mHsPMsdUSLe1guqlArkT/2kCsGamlI4x7c1uErK1Y40Ft6zMVqa2
         nnC4ubsdMdhSjqL8PTJrt+1R2vMZ1VjEZB0j5x0kcC0X5ofJvbkxc40hgx/DiLumskJz
         Hish82MjejkDLH3QmsgMqppdJa2pmb2zNRGRlfkiqLvZopRvvZ6YYtchUN14OL2EdE0w
         e2Pg==
X-Gm-Message-State: AOAM531QdgzdEFhibpfiJSwFBGt5AcmfqG/bKHqEzaGdIm5ezkIxzMAD
        tFsAvF++OtEwY9RPG5QbGvM=
X-Google-Smtp-Source: ABdhPJw18RCVSky7edGM+fQ8iYuOqozo18ui3MzTaUhjO+czTB7CDPz/Qgx9H9bXtHxykoiyD309AA==
X-Received: by 2002:a17:90a:c084:: with SMTP id o4mr2289007pjs.165.1610588601514;
        Wed, 13 Jan 2021 17:43:21 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m22sm3810610pgj.46.2021.01.13.17.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 17:43:20 -0800 (PST)
Subject: Re: [PATCH 4.19 06/77] scsi: scsi_transport_spi: Set RQF_PM for
 domain validation commands
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210111130036.414620026@linuxfoundation.org>
 <20210111130036.711898511@linuxfoundation.org>
 <20210113114745.GA2843@duo.ucw.cz>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e1fd4693-95f5-58c2-20c6-fbd96653edfe@acm.org>
Date:   Wed, 13 Jan 2021 17:43:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113114745.GA2843@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/21 3:47 AM, Pavel Machek wrote:
>> From: Bart Van Assche <bvanassche@acm.org>
>>
>> [ Upstream commit cfefd9f8240a7b9fdd96fcd54cb029870b6d8d88 ]
>>
>> Disable runtime power management during domain validation. Since a later
>> patch removes RQF_PREEMPT, set RQF_PM for domain validation commands such
>> that these are executed in the quiesced SCSI device state.
> 
> This and "05/77] scsi: ide: Do not set the RQF_PREEMPT flag for" do
> not fix anything AFAICT. They are in series with other patches in
> 5.10, so they may make sense there, but I don't think we need them in
> 4.19.

Agreed. Please either backport the entire series of 8 patches or do not
backport any patch from that series. Selecting a subset of the patches
of that series is dangerous. As an example, applying patch 8/8 without
applying the prior patches from that series would break SCSI domain
validation. See also
https://lore.kernel.org/linux-scsi/20201209052951.16136-1-bvanassche@acm.org/

Thanks,

Bart.
