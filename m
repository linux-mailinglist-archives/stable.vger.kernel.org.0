Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FF74ED18C
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 04:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345234AbiCaCMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 22:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241434AbiCaCMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 22:12:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3048D6582B;
        Wed, 30 Mar 2022 19:10:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a16so5220294plh.13;
        Wed, 30 Mar 2022 19:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=33MCZ8b0NYenzbLU8BDYeirTMtj9WkZ1p5wUprm5Z+c=;
        b=exhoHsrFNLRQSWJwWxIKVGvGsoq/Ubf45rtuKjViIkk7hbkMGcpdgCNoJHyiZPxpmI
         TeQnECXraab/zHLf38bC3Vcp2pUe2I5xVw/k6brx5fYA7caBa7TUmsL+hVgXK4FcfY5t
         yBDkkIL6mRvVdXA/+3QQpiD1xbgYEKOSzCdMRnrAWoMybbpqIHmHPnkc2MNH2RFEMFPY
         nt8PBw+GVrAbZQYofPj2rrQzZXkVBrXnxwAosfrGNoCHWVR0ABudzjEw2a7KcLlGeHtN
         ehMngeM1inl2fSr7WiTvoz/hMzELNCY+s0nQA0q2uN1KGwPQ1Je0yTEzBc1g7wYnofb5
         m5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=33MCZ8b0NYenzbLU8BDYeirTMtj9WkZ1p5wUprm5Z+c=;
        b=NArYNTeUAT/YvmKHcusc/Gdd4uR4IumZuPLA3tRoRpVw9fzZ2jYgBpW6SLr44dEHWv
         ECgPtI0Phzm0c3O8i/6aFeErpNPfbO+Z93gTxVceBZP+RnKxq5G4sENPo4R5ASwsnb84
         X0tGojPJW4wVFLu9WD7qRL3r31J6vSNGXf7c1Epe4jWbsypsmD78CVxqnWUyw0ytyafj
         IQ1k4pGAWbQRqXeGhNn5N6ZQ6n5kjriTPCUbJEv6TwN6ORyE3Q/kSEWUEWFFsNfYO5dO
         6yJ/d1GXK+Cje7vDktOoMAtu444/jItqBkeemaYmGyR1Hl9YtBHrDnI1za4T9KnBQ5YH
         j0QA==
X-Gm-Message-State: AOAM533WFq8SRIYTE+HCI/XWFi0UHacodX7FU/sRzBRKM/LxzCQWp4+I
        CFU4zcrZG3yxKNChtTqje18=
X-Google-Smtp-Source: ABdhPJxZnxvqOwt2v4RcZ907rKxDKHUWeJhkgksm28dXCJZ1aV4R1olkgktMOh2UVIBz48wRKFukzg==
X-Received: by 2002:a17:90b:1583:b0:1c7:3736:629c with SMTP id lc3-20020a17090b158300b001c73736629cmr3127544pjb.215.1648692628619;
        Wed, 30 Mar 2022 19:10:28 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id y13-20020a17090a390d00b001c995e0a481sm7701317pjb.30.2022.03.30.19.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 19:10:28 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     viresh.kumar@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, nm@ti.com,
        rafael.j.wysocki@intel.com, sboyd@kernel.org,
        stable@vger.kernel.org, vireshk@kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] opp: fix a missing check on list iterator
Date:   Thu, 31 Mar 2022 10:10:22 +0800
Message-Id: <20220331021022.28305-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220328093933.xa37n4dmq6o6tpel@vireshk-i7>
References: <20220328093933.xa37n4dmq6o6tpel@vireshk-i7>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 15:09:33 +0530, Viresh Kumar wrote:
> On 28-03-22, 17:13, Xiaomeng Tong wrote:
> > On Mon, 28 Mar 2022 14:20:57 +0530, Viresh Kumar wrote:
> > > On 28-03-22, 15:43, Xiaomeng Tong wrote:
> > > > No. the conditon to call opp_migrate_dentry(opp_dev, opp_table); is:
> > > > if (!list_is_singular(&opp_table->dev_list)), 
> > > > 
> > > > while list_is_singlular is: !list_empty(head) && (head->next == head->prev);
> > > > 
> > > > so the condition is: list_empty(head) || (head->next != head->prev)
> > > > 
> > > > if the list is empty, the bug can be triggered.
> > > 
> > > List can't be empty here by design. It will be a huge bug in that
> > > case, which should lead to crash somewhere.
> > > 
> > 
> > There is anther condition to trigger this bug: the list is not empty and
> > no element found (if (iter != opp_dev)).
> 
> I suggest reading the code again, considering opp_debug_unregister()
> as well.
> 
> What's happening here is this:
> 
> - Several devices share the OPP table.
> - One of them (devX) is going away and opp_debug_unregister() is called for this device.
> - If devX is the last device for this OPP table, then we don't migrate
>   and just release all resources.
> - Otherwise, we migrate it to the next element in the list. i.e. any
>   device which != devX.
> 
> Please tell based on this where do you see a possibility of a bug.
> Surely there can be one, but I fail to see it at the moment and need
> more detail of the same.
> 

Perhaps you are right. Anyway, It is a good choise to use list iterator
only inside the loop as linus suggested [1], to avoid potential risk.
I have also repost another patch with changed commit message. Please
check it, thank you.

[1]:https://lore.kernel.org/lkml/20220301075839.4156-1-xiam0nd.tong@gmail.com/

--
Xiaomeng Tong

