Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6087650DF6F
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbiDYLz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 07:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiDYLzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 07:55:16 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B512ABF
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:51:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r187-20020a1c44c4000000b0038ccb70e239so12316472wma.3
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ib6nQlp08A5L9C0VdErv324vMKIB/tKGFJooHE6SPao=;
        b=FGPew/JsMHemqppExogpDPOAw5g4gf1ssAKTU8fEoDX/TYrqhqAgx36NUbhIHfxaxO
         oGCt5CK2FsLLjjcHAuSPTrThgGRIqlrWQMHnrmZyf0JSJyqDjvrjQYK4tUkqgX1qx0Lu
         5yGCgzmxlkwn2fZfqW2Jv3JM938EbEunI/vGTmh5yFSWsU5lr6FoQth79T/LrEb0UhBS
         /3/zjjJGFYSJp2AdQUMsZG3QiYUzMih4wfHLiglTYwfQCtRm/US0vOI7RuiQHcY0XerE
         5xdNs5OqFcAzVGc0Cv54TyVkjrOzE/R8SljWIFQ4Vkd9C7s248D6rCUJ93Ue1XOjrsFf
         QvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ib6nQlp08A5L9C0VdErv324vMKIB/tKGFJooHE6SPao=;
        b=jZhxhAD1xAaULbisid7dqWP4jZ2kgQvy0fAuL3dfcecJ+YyfRFHlMlndxNlMz7KLiu
         ZEiYJZtD9/AR/LVXPyfiUIq8zgj8GwHDQBTnw1pdqS6CSyh7NzPviPqk3aBLjAfTZUad
         ctFiKAstmMniSjFk2Sz62BWOuxIRmHbzSk5oLX/MMCesiEBirfnsTGFlufAEYisZ912K
         XRajaVNeebCAb7vMZrop43pzWH5lPiXTisvpq8H6FQgcHRME97uzvYz/04wGpzaoINe7
         y9S46S9fcn23k8DK3zBcTrGBeYCWpK0SWiHw6xz+TozkHR+x5g7BYareVUa0/5068rfw
         89DA==
X-Gm-Message-State: AOAM5332STOXABVtn8yxrZrGeH3MWfC+PR/mtJTdpFgVVSn+vORj2hYK
        UYPFXCheGJmeTs3eHMGaXo8u/Q==
X-Google-Smtp-Source: ABdhPJwTi7rTFUk/I2iEam2Reae+PhOpYVcJX2xASabdJn+lKdmLrBwmczED1vVi1f2ATPqORx5UTg==
X-Received: by 2002:a7b:c7c3:0:b0:389:cbf1:fadf with SMTP id z3-20020a7bc7c3000000b00389cbf1fadfmr26141200wmk.147.1650887513507;
        Mon, 25 Apr 2022 04:51:53 -0700 (PDT)
Received: from 6wind.com ([2a01:e0a:5ac:6460:c065:401d:87eb:9b25])
        by smtp.gmail.com with ESMTPSA id a16-20020a056000051000b00207b5d9f51fsm8796490wrf.41.2022.04.25.04.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 04:51:53 -0700 (PDT)
Date:   Mon, 25 Apr 2022 13:51:52 +0200
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Message-ID: <YmaLWN0aGIKCzkHP@platinum>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406095252.22338-1-olivier.matz@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:
> These 2 patches fix issues related to the promiscuous mode on VF.
> 
> Comments are welcome,
> Olivier
> 
> Cc: stable@vger.kernel.org
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Changes since v1:
> - resend with CC intel-wired-lan
> - remove CC Hiroshi Shimamoto (address does not exist anymore)
> 
> Olivier Matz (2):
>   ixgbe: fix bcast packets Rx on VF after promisc removal
>   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Any feedback about this patchset?
Comments are welcome.

Thanks,
Olivier
