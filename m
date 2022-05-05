Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5DB51C897
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 20:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiEETB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 15:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359647AbiEETB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 15:01:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835473B294;
        Thu,  5 May 2022 11:58:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p6so5010149pjm.1;
        Thu, 05 May 2022 11:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hl7WfbK9DHwjRygGR7ADeqierefpNYfJm5+DL9udtug=;
        b=OFfZ/N4ZNieS82RLO2lUXkmMIoP9FiYRII/KMVevjj+bVGRYg+mMTBKbb0/JqotQUX
         9gp5wY5MKel5KW8ncLjcRhENadQvO/QeL3ySyVmwDP57xrwu/6juk+NdBLTkHyXG/rvY
         9lR//nyvP1XRepA7+H29tJouOo+ags2gYvRwTIkcrTGGuNHiqu899zZAmOpWaKRXtq8C
         XHDypD2dSJ4KOm5a7M++yHrAQPG1TUhN7jYAG7KeOrEV6iHCZtdjY4WgBBB2aG4sSg6+
         rxrv54wA8R2U+XoTc29ubK0wCy1tLqZoPSLv7No7NsEvodbNt4t0RdQrjAX0/NVMVp7M
         tnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hl7WfbK9DHwjRygGR7ADeqierefpNYfJm5+DL9udtug=;
        b=4Axw4QKoBXvSWBTf91bYfOnBe5NRq6WnL8FgXDoCkcXrQit7bk1rQ+4w+0xRdzWI5v
         YLBedV1x/6cn8bUXX+agBDWk3MTA+JboRszuRrxDJVEn4RkQkzVCRXv61vZKBQXhL5OP
         MCowRLaB0T6d84Q+tQBUw8KC/Ov+jtetberKcowgEJl+zb102/HopCEdszwsOtGEPY5+
         jCiVAg+FVlG3pIEEuwkQJhBH5Gm1S30q6RswGbuGdop2bYXHxdI/QV8quG4/lYgp6gho
         qCng5lNP13aetrpK7Gp22DhPKu/Si18xXVpQo9CvPQ/F3/QDyouCNUPAUyiklGS++ECA
         cDVQ==
X-Gm-Message-State: AOAM533m+/C8L6SUeQxLq+RMxxUnSHmKpsPwHxMlaShd+I7k6f5tVFsW
        xZmHxpVaq0xbtpFI8iIli6Y=
X-Google-Smtp-Source: ABdhPJwsQ86h5uavznp8KijLdCxh5u3bPlGhn58LKfpl/w6rzAJPptjGVsEU1TS9E+PIx69DJx6Gpg==
X-Received: by 2002:a17:902:eacd:b0:15c:17fc:31e with SMTP id p13-20020a170902eacd00b0015c17fc031emr28923495pld.4.1651777096636;
        Thu, 05 May 2022 11:58:16 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:29a5])
        by smtp.gmail.com with ESMTPSA id s19-20020a056a00195300b0050dc762812esm1730617pfk.8.2022.05.05.11.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 11:58:15 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 5 May 2022 08:58:14 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Message-ID: <YnQeRppX2bPoqOTL@slm.duckdns.org>
References: <20220427145428.1411867-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427145428.1411867-1-longman@redhat.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,TVD_SUBJ_WIPE_DEBT,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied to cgroup/for-5.18-fixes.

Thanks.

-- 
tejun
