Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A3F53D82F
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiFDSy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiFDSyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:54:23 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69ED4AE3C;
        Sat,  4 Jun 2022 11:54:22 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 30-20020a9d0121000000b0060ae97b9967so7836957otu.7;
        Sat, 04 Jun 2022 11:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R0ip9L5XFPXWj3oUnARhfVyHYFAdcHGsjzLEJOa2o6s=;
        b=OpdzuPHix9QMRP9E2aA14/d6PYUPHA4J98hftVsnDctl9pl4It8FR91e0jiajNApUQ
         sndxwSn6zcdljyoArKtMo1cElo2786SX3WmhcHoWY4I6tinpbjiPMj0Uqy1cKV0QA6kS
         1DjXb330NgVxxc6CghFT9RTP/YCKaeYcMX0QKynVwJXCFLENWmV997gnXZo2VqbVpEFf
         n/EulfiaL9Ncq3LCUs8k9klbLvkvIPSv3OLkMTilsODKbJyl4RdZh9yDiaiP5DW0dZSR
         hAcRJZ3le+SyXncRRDnI3TQdJWIhErQtTbgJknGCNZh63vtoIXJlBWVV9i7PnDGFVRue
         reVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R0ip9L5XFPXWj3oUnARhfVyHYFAdcHGsjzLEJOa2o6s=;
        b=NH2wF/PecAEHMNv/dJCNJRRlY6Nc6adiYVpgjUr8iOiatWI53LVkobBK+yZiE1yQMP
         BC7st/vulkztTbps37Ez3qqBy30HJZx5QS10sB4JRqfuP4H5D/8zlDHr3zcX7XIf65Oy
         XhDxAGPxoO1F6nCP+ZQcADVduMs59OylZrACv8qKVdEkBrLkRJwbChg6mKjwY0XqCRfH
         9re5deaE4pr0EBhsxzrs18uLFdacbpZgS4O4ui7xsnw4mqYPVbY4vtrw6z1sejlTyYGC
         MspQzpQrDrHIgygW/GlbPumqL5+RZEYTetciqkQWrtSJ2fF8xRCV5LD9SO140U4ky/0/
         lz1w==
X-Gm-Message-State: AOAM532IuBm8JR8OQ9X3wI/KdS0shx+RegEfBfqiInjtI4sZQkAt7mpJ
        gONQ7L920W4iZfrFTxSPAuk=
X-Google-Smtp-Source: ABdhPJwrrTe9MbSepEBHKpIDAypZeF+gVlvkQVIFb98kAJSGl5df1xsNJMkUxvBdGOU0MHX7UepQSA==
X-Received: by 2002:a05:6830:2462:b0:60b:f113:410a with SMTP id x34-20020a056830246200b0060bf113410amr921826otr.300.1654368862273;
        Sat, 04 Jun 2022 11:54:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6-20020a4adf46000000b0035eb4e5a6b8sm5483074oou.14.2022.06.04.11.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:54:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:54:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/30] 4.19.246-rc1 review
Message-ID: <20220604185420.GC3955081@roeck-us.net>
References: <20220603173815.088143764@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:39:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.246 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
