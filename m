Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E641B91
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 07:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfFLFdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 01:33:04 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41149 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfFLFdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 01:33:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so23683836eds.8
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 22:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0kzCUHZ+JYHSTECyKvtArsrCIaPlOml0LMhBZ62fOBQ=;
        b=rvCQOCVJrmELZ6nCfInVoF926QNRI89j6U6fV0IY9lzpz+LW25JDHS/xdTzo4Hbiw4
         hQUHHDdjD14fuj/p2gLSxKNwgzeJi1c5DSj6UOHuh6Hdg6KNHSqZzEAplwXqLkDkE9Co
         m4HaaxqIJ8NDyVhw4vrMF++LZJo/b97PjXqlPz8jdy4cO0Jqdics07wx+5kr6kRVgVQB
         n/KGD2ByHhQzHd27NtHmjIsNNHRJQE98Jmn/hBsgaU1dsqp35Yq9tkS8YQCQRgPim/1J
         nF467t/yI/+uO65OQEjYClttrA736C2hzxrRuu97NfkSpktUyXeBZrHMUJhP2/9PLZfh
         IOpA==
X-Gm-Message-State: APjAAAU2dDDjd0wblPXvT0htE701a00m10hG4phKcEhOcLE5Z5MoY749
        cfwC81ANouc+lzZ5s3ICmZorGAYpk+A=
X-Google-Smtp-Source: APXvYqzSVYA1VAvZMc3w2pPlGPDS91ZKHiAQwhFqCpDOxLmo3yQ4uz4s35vV9zY9mK+u3QQ7hvLzyA==
X-Received: by 2002:a50:8b9d:: with SMTP id m29mr49827138edm.248.1560317582307;
        Tue, 11 Jun 2019 22:33:02 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id w1sm670991ejv.69.2019.06.11.22.33.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 22:33:01 -0700 (PDT)
Subject: Re: [PATCH] libata: Extend quirks for the ST1000LM024 drives with
 NOLPM quirk
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
References: <20190611143259.28647-1-hdegoede@redhat.com>
 <yq1d0jjeaj6.fsf@oracle.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <be8260f7-cb3c-36b1-22d7-edc6b2657512@redhat.com>
Date:   Wed, 12 Jun 2019 07:33:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <yq1d0jjeaj6.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12-06-19 05:40, Martin K. Petersen wrote:
> 
> Hans,
> 
>> -	/* drives which fail FPDMA_AA activation (some may freeze afterwards) */
>> -	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
>> -	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
>> +	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
>> +	   the ST disks also have LPM issues */
>> +	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
>> +						ATA_HORKAGE_NOLPM, },
>> +	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
>> +						ATA_HORKAGE_NOLPM, },
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Slightly orthogonal, and I know it's been discussed before, but I think
> it would be worth considering just blacklisting all firmware revs for
> this model.
> 
> There were several firmware releases for these drives. And while it's
> conceivable that post-2BA30001 may fix the issues, I think it's safe to
> say that all the intermediate releases between the two we have are
> equally broken.

Dropping the firmware version sounds reasonable to me. Do you want me to
send a follow-up patch doing this?

Regards,

Hans

