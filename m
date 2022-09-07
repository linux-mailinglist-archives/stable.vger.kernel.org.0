Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497825B0BB1
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 19:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiIGRnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiIGRnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 13:43:41 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31901AA360;
        Wed,  7 Sep 2022 10:43:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d12so15315274plr.6;
        Wed, 07 Sep 2022 10:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XGtEtwtKdQqC2L+HBrNpJtoQPcL3EJdo5FiXRiQZ8KQ=;
        b=IW+XYA++XfUhgKATAADQ8OfG8sHr7JORhPeH1Qk2xJ0xgF9554pYg62oWubz6fa70c
         4wG8Kk358awHwWx3CeWsdFBsKr04s63pxkUGQN+BzJ11yPTnezBVpcBLOx566gCGqhIL
         KEOB8ejmSV1Q9npI03qaeqgHvEXBXHuwRpkjDwDQ/fdMWwiUQlo1FGXkr9CeljzMbqgu
         6ZERDS5DluFI7V7s0cibCIKGuVT1oWYph9f7Wd/YrioYtf/ijvuyXZHIDGNFGnMSK0nN
         KzPxOhmHNfrNi2DtwHpMcxjo4QV2b01f6EgVGOWRUMaTvLnJu3j+L18rlPDRteMbaUnL
         RZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XGtEtwtKdQqC2L+HBrNpJtoQPcL3EJdo5FiXRiQZ8KQ=;
        b=wHMs2UVuzLeCTZZU9SoyS4Fr3yFOV644k9pd5sXzDdVXcrzLlycTbIDFcLfsU61SKH
         WedXv/J0nL7v2gFK5dDsge48Listp/Q2QZoEBiXU248MwoYTtCVPBXdLjdehtOAPpF1X
         7zvv77YEBLt32zszoVPlK0WlsCcCFbRuczZc9cwoY2BcUS0Jhwy8S1pJBShk6gA2wjRo
         W9XPW3zWOuCGnl7iPAuSiNzLi3naZ6SpYVs4g8mK/ydevqT0+C+RA/UUNovg5BQKPVDS
         vAjPPHi8UrVg4WmYT21UEVt6BZ3/cpEh2TjcRA2TRzV/wpSc/kmJd5kfGOgSTdng/4nI
         ymfg==
X-Gm-Message-State: ACgBeo1modoAi7Wl6GqbdI3T/Toz67Kje0Y1dGh0TO0enrxv5cBd7cWS
        bg2/10s6syTiSoy8tFST3Rg=
X-Google-Smtp-Source: AA6agR6a0zpigjCBBzrrblpqDZk53LF5snvtNHBH6kQh/q06Z5yIbOnXCTmiLJoXPdz0GOCF77p3hQ==
X-Received: by 2002:a17:902:ce11:b0:172:6f2c:a910 with SMTP id k17-20020a170902ce1100b001726f2ca910mr4839746plg.156.1662572619629;
        Wed, 07 Sep 2022 10:43:39 -0700 (PDT)
Received: from localhost ([2406:7400:63:83c4:f166:555c:90a1:a48d])
        by smtp.gmail.com with ESMTPSA id y1-20020a62ce01000000b0053e5ff3eb63sm2667150pfg.213.2022.09.07.10.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:43:39 -0700 (PDT)
Date:   Wed, 7 Sep 2022 23:13:33 +0530
From:   "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] ext4: Make mballoc try target group first even with
 mb_optimize_scan
Message-ID: <20220907174333.tnnq3xk4o3w76s5x@riteshh-domain>
References: <20220906150803.375-1-jack@suse.cz>
 <20220906152920.25584-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906152920.25584-1-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/09/06 05:29PM, Jan Kara wrote:
> One of the side-effects of mb_optimize_scan was that the optimized
> functions to select next group to try were called even before we tried
> the goal group. As a result we no longer allocate files close to
> corresponding inodes as well as we don't try to expand currently
> allocated extent in the same group. This results in reaim regression
> with workfile.disk workload of upto 8% with many clients on my test
> machine:
> 
>                      baseline               mb_optimize_scan
> Hmean     disk-1       2114.16 (   0.00%)     2099.37 (  -0.70%)
> Hmean     disk-41     87794.43 (   0.00%)    83787.47 *  -4.56%*
> Hmean     disk-81    148170.73 (   0.00%)   135527.05 *  -8.53%*
> Hmean     disk-121   177506.11 (   0.00%)   166284.93 *  -6.32%*
> Hmean     disk-161   220951.51 (   0.00%)   207563.39 *  -6.06%*
> Hmean     disk-201   208722.74 (   0.00%)   203235.59 (  -2.63%)
> Hmean     disk-241   222051.60 (   0.00%)   217705.51 (  -1.96%)
> Hmean     disk-281   252244.17 (   0.00%)   241132.72 *  -4.41%*
> Hmean     disk-321   255844.84 (   0.00%)   245412.84 *  -4.08%*
> 
> Also this is causing huge regression (time increased by a factor of 5 or
> so) when untarring archive with lots of small files on some eMMC storage
> cards.
> 
> Fix the problem by making sure we try goal group first.
> 

Yup, this is definitely a bug. We were never trying goal group then,
except maybe for rotational devices (due to ac_groups_linear_remaining).

Looks right to me.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

