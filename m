Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ABF5961E1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiHPSFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiHPSFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:05:31 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A53F81B26;
        Tue, 16 Aug 2022 11:05:31 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id gp7so10398775pjb.4;
        Tue, 16 Aug 2022 11:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eKDysHCQjTCqQt/NwtOxjkIdkCjeDt0eSaPWU62kEnE=;
        b=jI4N179I5a1W5RfKUpfzp9MCYHUA/CK/4IPA4dJlfXgC9BGwlvxHb7g09/WN9p1Xqi
         k6iLF6fMKBmY6IoS22n/aC5CKEk66M7A2Rcqxr6srVaonyUFCLauDYy3nuX8/wBp5wLJ
         QwyRtvBYkm3BO1+UKln6GUncy7oZ2b0OzqulViuJd1OFDiipfq5ed1EC7y9SdpvzYcdT
         syReqPxpBcqIw72RY9zwvF2Tx1WXbeX+3i9f4uYkaJkW0sQ1BY3QlPe7wHVDwxl9W9/f
         Ho5L/v+HFpeEh1OeOdUODdQ3OAccMK9cZz7hnqwflmLN4N+3DWClfZuHbnsFGoqnWe6g
         0m3Q==
X-Gm-Message-State: ACgBeo2D6ohbDnCeAlGjdg0NTUm9vCeFggASVxr3GZeuYePlpMbbDGDH
        8Zw7PRUvR96o8FCBha+gqug=
X-Google-Smtp-Source: AA6agR7u1gjzOv8+2GCYfZiH4L1Ti/Qxf//GeJ51maGR8pSRIW0EkW7m8qeMHwyIWeOqGZq/Pow7xw==
X-Received: by 2002:a17:902:ab41:b0:171:54ae:624c with SMTP id ij1-20020a170902ab4100b0017154ae624cmr22657572plb.157.1660673130341;
        Tue, 16 Aug 2022 11:05:30 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ff4b:545d:11c8:da9f? ([2620:15c:211:201:ff4b:545d:11c8:da9f])
        by smtp.gmail.com with ESMTPSA id i3-20020a626d03000000b0052c0a9234e0sm9066610pfc.11.2022.08.16.11.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 11:05:29 -0700 (PDT)
Message-ID: <b532e50f-7aa0-5ac3-c7a6-6a43ab9c1bc9@acm.org>
Date:   Tue, 16 Aug 2022 11:05:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 0784/1157] scsi: sd: Rework asynchronous resume
 support
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180510.851284927@linuxfoundation.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220815180510.851284927@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/22 11:02, Greg Kroah-Hartman wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> [ Upstream commit 88f1669019bd62b3009a3cebf772fbaaa21b9f38 ]
> 
> For some technologies, e.g. an ATA bus, resuming can take multiple
> seconds. Waiting for resume to finish can cause a very noticeable delay.
> Hence this commit that restores the behavior from before "scsi: core: pm:
> Rely on the device driver core for async power management" for most SCSI
> devices.
> 
> This commit introduces a behavior change: if the START command fails, do
> not consider this as a SCSI disk resume failure.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215880
> Link: https://lore.kernel.org/r/20220630195703.10155-3-bvanassche@acm.org
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")

Hi Greg,

It has been reported that this patch causes a regression, namely disks 
not coming back after a resume. That issue is worse than the issue fixed 
by this patch - eliminating a delay. Please drop this patch from the 
stable tree.

A revert of this patch has been posted on the linux-scsi mailing list. 
See also 
https://lore.kernel.org/linux-scsi/8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com/.

Thanks,

Bart.
