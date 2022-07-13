Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96657345B
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiGMKfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiGMKfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:35:06 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE96BEDB55;
        Wed, 13 Jul 2022 03:35:04 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LjYph2G0tz1L8ZL;
        Wed, 13 Jul 2022 18:32:28 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 18:35:02 +0800
Received: from ubuntu1804.huawei.com (10.67.174.66) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 18:35:02 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <rostedt@goodmis.org>
CC:     <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <stable@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>, <zhangjinhao2@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: Re: [PATCH] tracing/histograms: Simplify create_hist_fields()
Date:   Wed, 13 Jul 2022 18:32:35 +0800
Message-ID: <20220713103235.129358-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220712134956.4acb90a3@gandalf.local.home>
References: <20220712134956.4acb90a3@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jul 2022 13:49:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 30 Jun 2022 09:31:52 +0800
> Zheng Yejian <zhengyejian1@huawei.com> wrote:
> 
> > When I look into implements of create_hist_fields(), I think there can be
> > following two simplifications:
> >   1. If something wrong happened in parse_var_defs(), free_var_defs() would
> >      have been called in it, so no need goto free again after calling it;
> >   2. After calling create_key_fields(), regardless of the value of 'ret', it
> >      then always runs into 'out: ', so the judge of 'ret' is redundant.
> > 
> > No functional changes.
> 
> I applied this but removed the "No functional changes" because it is a
> functional change. The end result may be the same, but the flow is
> different, and that means it changed functionally.
> 
> The only time "No functional changes" should be stated is if you move code
> around or change #ifdefs to perform the same action. IOW, if the assembly
> produced by the compiler is the same before and after your change, you can
> say "No functional changes", otherwise don't ever say that.
> 
> This is important, because if a bisect lands on this, people may think the
> bisect is incorrect, when in reality it could be the cause of the bug (I
> just had this happen to me with another commit that had "No functional
> changes" :-p )

I learn it now and share it with my colleagues in the neighborhood.
Thanks for your patience :)

> 
> -- Steve
> 
> 
> > 
> > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
