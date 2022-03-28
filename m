Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C2C4E8F3B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiC1HpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiC1HpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:45:12 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D632752E18;
        Mon, 28 Mar 2022 00:43:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so14655947pjq.2;
        Mon, 28 Mar 2022 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5F0vPMEUiwjxuq5pjTLwGQrsLXzqAZhWm21dKQena8E=;
        b=Pp5hdQtvybkoE7iXCBGqw92+FFCxtS0gcrDzWSM1XbdfogwH6IUPx9/+LqG9FedtVM
         86lC/5AznmmTN+ZUSDXmPb1Wp6XyGRyx1sBuKEpeWIFH13EM48Sgy49hjQn8KC+tCRkw
         Fxpxt5chztOHglhRcRYwAt0RIZduYDp7n1cbh7DDnbl/LZYYKN3eCPI7x4eXEgo16zVz
         tZvv8PHSpn5ur7nF1XxuOPXBXzeeNf0H/x/YEtIErf3KsZyJ0og5EGXQOIga9nOLAXNB
         vpOnB38wzG8gtJu1vjIQKUPJJI8oJ7CsbkiQEJHohouuFqZJK+Dwlsa+HOjX6AYIZYCB
         l+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5F0vPMEUiwjxuq5pjTLwGQrsLXzqAZhWm21dKQena8E=;
        b=dE2gnF5WyM/VkhExXQ7q00VKaSlE6Hz2Zv3TFK7zhbvTnyzn9mjWL4iJrX0XrFXI7E
         nx0SPLyQMM3vr/dC+UMFOoTRdvTCRFYA2u4XYNlgS5YkvWYS91R0T4XevcqDAmswJelg
         Q0+BkWgnJZRMUHY/YnoyUxik+KtB4tHuMYAedZGCOxACsFJ45oKz11jnX9gEQo4s3QR0
         Y8xB6jbDSqlM9V0lfgz/88JJg0AvzwQFOQaGjT9dq8OClbCdeZkks7Rp9NxfY7UL6+SF
         gFPeyTtojEKBK/5BVQ3elglNH844XBhi/jzP6JdXt3Ct9TsrTMepUyiayk6VzPK+yemz
         Ppcg==
X-Gm-Message-State: AOAM532TdtL2llhlI3k0YV6Ss45ccmAgrkyFL9pPkS58XHZtb3wwGEF8
        SJHY3OvEPau72BpYX9OvTZw=
X-Google-Smtp-Source: ABdhPJyO4+ufZp/SIAWh+2kglfewOd/M/i3FDRBuWVxR+N7p90doKEWl81dY+fiOrjG6cVxA9k0AfQ==
X-Received: by 2002:a17:902:8644:b0:153:9f01:2090 with SMTP id y4-20020a170902864400b001539f012090mr24200102plt.101.1648453411437;
        Mon, 28 Mar 2022 00:43:31 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id f30-20020a63755e000000b00381f6b7ef30sm12082098pgn.54.2022.03.28.00.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 00:43:30 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     viresh.kumar@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, nm@ti.com,
        rafael.j.wysocki@intel.com, sboyd@kernel.org,
        stable@vger.kernel.org, vireshk@kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] opp: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 15:43:22 +0800
Message-Id: <20220328074322.25349-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220328031739.72togwws2u2rlluo@vireshk-i7>
References: <20220328031739.72togwws2u2rlluo@vireshk-i7>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 08:47:39 +0530, Viresh Kumar wrote:
> > diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
> > index 596c185b5dda..a4476985e4ce 100644
> > --- a/drivers/opp/debugfs.c
> > +++ b/drivers/opp/debugfs.c
> > @@ -187,14 +187,19 @@ void opp_debug_register(struct opp_device *opp_dev, struct opp_table *opp_table)
> >  static void opp_migrate_dentry(struct opp_device *opp_dev,
> >  			       struct opp_table *opp_table)
> >  {
> > -	struct opp_device *new_dev;
> > +	struct opp_device *new_dev = NULL, *iter;
> >  	const struct device *dev;
> >  	struct dentry *dentry;
> >  
> >  	/* Look for next opp-dev */
> > -	list_for_each_entry(new_dev, &opp_table->dev_list, node)
> > -		if (new_dev != opp_dev)
> > +	list_for_each_entry(iter, &opp_table->dev_list, node)
> > +		if (iter != opp_dev) {
> > +			new_dev = iter;
> >  			break;
> > +		}
> > +
> > +	if (!new_dev)
> > +		return;
> 
> I think you missed this check in the parent function ?
> 
> 		if (!list_is_singular(&opp_table->dev_list)) {
> 
> 
> i.e. this bug can never happen.
>

No. the conditon to call opp_migrate_dentry(opp_dev, opp_table); is:
if (!list_is_singular(&opp_table->dev_list)), 

while list_is_singlular is: !list_empty(head) && (head->next == head->prev);

so the condition is: list_empty(head) || (head->next != head->prev)

if the list is empty, the bug can be triggered.

--
Xiaomeng Tong
