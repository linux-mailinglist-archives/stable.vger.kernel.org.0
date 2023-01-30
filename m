Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0873268188E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 19:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbjA3ST0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 13:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbjA3STY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 13:19:24 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C576B75E;
        Mon, 30 Jan 2023 10:19:16 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id g9so8454815pfo.5;
        Mon, 30 Jan 2023 10:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCTnt4UHkjh+KturpG+BgNEdB7rIfLkxoGG9uQQNS2M=;
        b=0zIXcIFwr0W4hOtTB4q1yX1RJRqm/CVALduKqZj03HJGN8rzzcKf8BO0o9Te4y/hPI
         tk2oc5MW0h79B1ur+O/bjKyspGAHr2icdOFVgTbfW8KJ4ZWDEFzY56tvTF4i7t5hJa5j
         XVtN+ok+Bsgb26y8GMj4q93FEm3G8Ympp9AxYELoM6sZGTObQ9RN4U0iprM2ZxReXVcf
         GL6f4pQDYBkclPdeXFi9D3oxA2b+/Sn3drCOJO0NJMvrS+4Y9RYNwJ0eMUmfyfr6AwGm
         XtUJRNDtmka1+pcY2XYhaEgq24SauLeH45/cEhTxhTF/5VeGQjkvOCRuj2PYaczT1ppM
         ZGjA==
X-Gm-Message-State: AO0yUKUSkBCwY7o/7eqBA8oiISyT1PWACVoHvdCPdwniovYeVmoeFZa/
        sr5ZGuoPFTiOJw76qMS4q/U=
X-Google-Smtp-Source: AK7set9F7OxYYf5cUUJPaSciocvf9756iNTgzNVxnnMshrlLCyF6v4L+p7tO0TYs0+bJjYol+1Ztwg==
X-Received: by 2002:a05:6a00:450e:b0:593:b2b2:9544 with SMTP id cw14-20020a056a00450e00b00593b2b29544mr6190700pfb.0.1675102755589;
        Mon, 30 Jan 2023 10:19:15 -0800 (PST)
Received: from ?IPV6:2620:0:1000:2514:4774:59fa:531b:5f22? ([2620:0:1000:2514:4774:59fa:531b:5f22])
        by smtp.gmail.com with ESMTPSA id m14-20020a056a00164e00b0058bc1a13ffcsm7757697pfc.25.2023.01.30.10.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 10:19:14 -0800 (PST)
Message-ID: <4504517a-25f0-5626-7dc3-50e96f392c84@acm.org>
Date:   Mon, 30 Jan 2023 10:19:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20230128000409.never.976-kees@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230128000409.never.976-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/23 16:04, Kees Cook wrote:
> The aac_priv() helper assumes that the private cmd area immediately
> follows struct scsi_cmnd. Allocate this space as part of scsicmd,
> else there is a risk of heap overflow. Seen with GCC 13: [ ... ]

Bart Van Assche <bvanassche@acm.org>

