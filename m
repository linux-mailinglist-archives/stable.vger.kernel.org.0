Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E651355A4E7
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiFXXez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXXey (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:34:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B24B857B2;
        Fri, 24 Jun 2022 16:34:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k7so3332105plg.7;
        Fri, 24 Jun 2022 16:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7hrbn8OHpUk6upmt2TtJxgs3WrguDKJhl7supQAK01s=;
        b=Pwqx+9lNA24/4CVWrpWt+xFmwII0HX1iRuBRIiamXXhGjYbUikNK+OUnb5oijN1Y7c
         yErx5xThIc2xaK6mRyaVVYaBZeKg0bTZZnUfg1P4wU6+DDxFcLfDGMbrYGh7xsmUPvR6
         dQaTjam/Grgmf78Oy8DdDPVZqvtKdg+05QZ1qUtpuwvWv+L2sxTUBdKsf9Qk1UD+ArlE
         MUXNoRR1UmSCc6AmnWbGF1k9fYVLCRRdrtr3ScnDiAKm7x9I6BkP9PLj9/SR4j6GvkBi
         B8nQfn4RvqOHfz5oeYZqkp1yCHqUdAAeWcMi264f8ypLBhDcbx66dOVqK6/JQsPVXQm6
         o7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7hrbn8OHpUk6upmt2TtJxgs3WrguDKJhl7supQAK01s=;
        b=GqCHfwRBz5T7OE7gI87HVgtASoi5fvOkkJ7WcfQwCCtjbVSo3RntUgleTt4j2lyP9z
         /xJwiokG3RwVhyYSTYEFJKapn7cEgOmr8iQryXIhp7zuUhelf0SbsRKXf8CTC4nUYY4J
         6JpZwPvrySwgfiUWfdoaoBb3scULe54bVepf0Tmo3ZATXqBKNN6Tc2RzAFV5C/p4WclP
         fIdqRnXw/Ces6oskUUB3TN647DW01DuUmvr39+oGdhwFgahauKf9N4a5rRkjWh8QRJY6
         6HtrAOequ0u8rXiF4wvfvv2zLSwLqncSVPWUKdMQsNgwMdQboBnp849qU8clT85/Bx98
         ZGOA==
X-Gm-Message-State: AJIora/uYyq4FBH1azjOuG9O+yvQBM/2g8Xj11QCCP1EEadX3GgNUBvs
        idef2BX5Jgk2vGFiLa39Nvs=
X-Google-Smtp-Source: AGRyM1uSmpXGkTL2rr/HA3czlBQ0N7LRlhHoVwPUeGUBPV8TXTuZ2h5FAkf+xvepocbiMq2lxB3OfA==
X-Received: by 2002:a17:902:ca91:b0:16a:1126:c5af with SMTP id v17-20020a170902ca9100b0016a1126c5afmr1553267pld.78.1656113693874;
        Fri, 24 Jun 2022 16:34:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b82-20020a621b55000000b0051bf9159d2dsm2262574pfb.208.2022.06.24.16.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:34:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:34:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/11] 5.10.125-rc1 review
Message-ID: <20220624233452.GD3341529@roeck-us.net>
References: <20220623164322.296526800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:44:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.125 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
