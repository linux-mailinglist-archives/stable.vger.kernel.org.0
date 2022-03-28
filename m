Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672C34E90D8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbiC1JPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239699AbiC1JPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:15:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D694DF69;
        Mon, 28 Mar 2022 02:14:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c11so11751009pgu.11;
        Mon, 28 Mar 2022 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6H4q2iSZzFHnIGwhfSbyLy1zEV6vtOQ9h5AkAZhACPw=;
        b=hqOqKxq2TrhTTBYYKJXXwpgwhIjpl5RaESVxQBpheloQIrB2inQbMkpVxMtoBvlAQD
         GR7DBCJW93bVKRJUNXBmLCBhlcErqs172KUSWqtUy7bjAFEmgClU7CI4zZ7DqWD9uQ6r
         IvuXUmbLo7622JjQwFOPxUCr5jJAlCtjBcfgMAj9fXYOjBhK9ilJisIwXEbg64KIYi8t
         IvRKejTqwiSNSPOKDyC9UHfvE3wREnO1mgdLStdH/O/t6bMLXMbLwXwL237SieE+9ppm
         uHZtSKhSiLyf5VRIBSCiklFGOU4mY+CWQFazkLgNplpiUFTYWSkPLe8tprq38aIYNbMA
         Yu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6H4q2iSZzFHnIGwhfSbyLy1zEV6vtOQ9h5AkAZhACPw=;
        b=v6XGrvIqfNmKNUBRbwqh0dtbl1nCvsJOB3ZXKkCkBNc/Gq1CcyYiuDnJBkOPGyAhUj
         looEjQnBjcdqxl/XT6/2rsjcjKyABUMz8QunfvSH2Pa+BRJElVn7eGkVaF/RV2N3vj/o
         rKmuzmaWt2AupkLxZQzMqniR2+YzoE06F93eWXBCqcmFuZyGBgr1kyyLT5KDWT3vch8F
         luImbTtECER6rL5OZ388v30vAzK9pWgd8+lEbXnYZpBoish+p81kVJefLqR9CqHSeHD8
         OThYxoJfaZbjAdfB8KQOZbd8Z+yvpVMtHvyfvvGOvXtChb87zoNsSaTkEm3ewFHHhHH6
         4SVg==
X-Gm-Message-State: AOAM531UXVnSj9fKnBjuiimQ1YvEE+XMxDVXERjwNNkUDYJIh2iTG1A7
        zOGLaojnIN95HPLAG5MxI3Y=
X-Google-Smtp-Source: ABdhPJwC0bq1MK990sXRpQCIbVqhHQ6WkN7e4ch4BD9elDqBUQ0lX1m2FUoXMDEWT7fT3i/XvM5a9w==
X-Received: by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP id f15-20020a056a00238f00b004f778b12f6bmr22433546pfc.17.1648458843200;
        Mon, 28 Mar 2022 02:14:03 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id a16-20020a17090a6d9000b001c9c3e2a177sm647659pjk.27.2022.03.28.02.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:14:02 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     viresh.kumar@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, nm@ti.com,
        rafael.j.wysocki@intel.com, sboyd@kernel.org,
        stable@vger.kernel.org, vireshk@kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] opp: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 17:13:39 +0800
Message-Id: <20220328091339.27021-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220328085057.ikn3mcyz2gbftkg4@vireshk-i7>
References: <20220328085057.ikn3mcyz2gbftkg4@vireshk-i7>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 14:20:57 +0530, Viresh Kumar wrote:
> On 28-03-22, 15:43, Xiaomeng Tong wrote:
> > No. the conditon to call opp_migrate_dentry(opp_dev, opp_table); is:
> > if (!list_is_singular(&opp_table->dev_list)), 
> > 
> > while list_is_singlular is: !list_empty(head) && (head->next == head->prev);
> > 
> > so the condition is: list_empty(head) || (head->next != head->prev)
> > 
> > if the list is empty, the bug can be triggered.
> 
> List can't be empty here by design. It will be a huge bug in that
> case, which should lead to crash somewhere.
> 

There is anther condition to trigger this bug: the list is not empty and
no element found (if (iter != opp_dev)).

--
Xiaomeng Tong
