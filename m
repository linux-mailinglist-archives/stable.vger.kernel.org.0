Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2519755D0CB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbiF0Xlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiF0Xlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:41:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707F911477;
        Mon, 27 Jun 2022 16:41:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l6so9522727plg.11;
        Mon, 27 Jun 2022 16:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LVvw/KmcyAhEnCi1+ULfjbEqPGwINQMzz3roMvT8h7o=;
        b=noq4s/t6HbRKdDTx6ScHKvV85oM3AWoFThWhKceIATQ5qtxKwQEMNU6rkowHDcvfqj
         HB03xWSHFeqYuedWK/yAP3auhMLU1kClNCmxk9HGmoycM0hNFm36BpXXlBWerSME9SJj
         U9oIQzPxg3BaO3wT1rYj484gs5vEZJUuxmBg0cLyK7mBmpk3XSD98IkFVrGI8fT+XOQZ
         EoR2DuDjL9Wq6R6Sbe3JXhQvUdypHGK8ErDM4aYSGToCBn9tLH9DT26vMFis5nDYd7HO
         j8e0qafR9B/EFqdkQ5Ib+Jn1WjOR2v3wjlfYkESGofJbh/9vxE5pH/amMdL0ErIPZr8W
         Frag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LVvw/KmcyAhEnCi1+ULfjbEqPGwINQMzz3roMvT8h7o=;
        b=qLIpE+Q3fvfcM+dUBdW78KTL8JKB1b5xold57g46/T8DlPMsnWoItmRMdjcHKXhxxn
         E5mGWAFKQ7NwVwwbkq8c+4WhOKmP7En1M5ktA706eEchtt7ndt6Z02XlHAyxp8orAx/A
         FEQ0xe8fQQzYe74rRaUfW4pcBScSAFoYEM0cRS+C1ZHJfOUU8Ub2Pj9lEUsc5/1sfTI6
         hsMGTwSYi533DW9QNFYP6IjlG5LkOXC14vBKGDf9eun9ONr6FT9OnE2+6js0YjtaWeqZ
         MuswJcJR9J0jHYYsHE2j+p4jc6lqTm7uarZ3m44A1wD64+eG1KJCIbOyyTPe+piw3+sf
         sIlg==
X-Gm-Message-State: AJIora/K9+L39D+jitulzTSlFlh6HcCTHcfA/IOWQgjb27Fs91G656+A
        dLpNKSWAsJjIbHFGx0otAmlGXJ/+3Qg=
X-Google-Smtp-Source: AGRyM1voFM5BDnME7K1em53oMYUOOBEdMFzeYVNN3EdnrGJQwRS4fBfuwnC7elg3m2oPUq7ept/g1g==
X-Received: by 2002:a17:902:d50b:b0:16a:2cb3:750d with SMTP id b11-20020a170902d50b00b0016a2cb3750dmr1930838plg.17.1656373304996;
        Mon, 27 Jun 2022 16:41:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y12-20020aa79e0c000000b005184031963bsm7919775pfq.85.2022.06.27.16.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:41:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Jun 2022 16:41:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
Message-ID: <20220627234143.GB2980567@roeck-us.net>
References: <20220627111933.455024953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:20:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
