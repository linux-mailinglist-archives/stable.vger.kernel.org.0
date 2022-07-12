Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8045718E6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 13:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiGLLvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 07:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiGLLvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 07:51:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E3B31F6;
        Tue, 12 Jul 2022 04:51:14 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LhzZ95CjvzlVxf;
        Tue, 12 Jul 2022 19:49:37 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 19:51:11 +0800
Received: from ubuntu1804.huawei.com (10.67.174.66) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 19:51:11 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <rostedt@goodmis.org>
CC:     <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <stable@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>, <zhangjinhao2@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: Re: [PATCH v2] tracing/histograms: Fix memory leak problem
Date:   Tue, 12 Jul 2022 19:48:44 +0800
Message-ID: <20220712114844.158722-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220711115211.4f613cbe@gandalf.local.home>
References: <20220711115211.4f613cbe@gandalf.local.home>
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

On Mon, 11 Jul 2022 11:52:11 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 11 Jul 2022 09:27:44 -0500
> "Zanussi, Tom" <tom.zanussi@linux.intel.com> wrote:
> 
> > So I'm wondering if this means that that the original unnecessary bugfix
> > was based on a bug in the clang static analyzer or if that would just be
> > considered a false positive...
> 
> Good question. I'd like to know this, as if it is the case, I want to
> report that in my pull request to Linus.
> 
> -- Steve

I didn't use clang static analyzer before, but from its home page,
'False Positives' seems to exist, see https://clang-analyzer.llvm.org/:
    > Static analysis is not perfect. It can falsely flag bugs in a program
    > where the code behaves correctly. Because some code checks require more
    > analysis precision than others, the frequency of false positives can
    > vary widely between different checks. Our long-term goal is to have the
    > analyzer have a low false positive rate for most code on all checks.

So I try the clang-14 which comes from
https://github.com/llvm/llvm-project/releases/tag/llvmorg-14.0.0,
then execute like:
  $ scan-build make -j16

Then I take a rough look at following warnings related to 'trace_events_hist.c'
(serial number is manually added, no double free warning, maybe due to clang version):
  1. kernel/trace/trace_events_hist.c:1540:6: warning: Branch condition evaluates to a garbage value [core.uninitialized.Branch]
          if (!attrs->keys_str) {
              ^~~~~~~~~~~~~~~~
  2. kernel/trace/trace_events_hist.c:1580:9: warning: Array access (via field 'field_var_str') results in a null pointer dereference [core.NullDereference]
                  kfree(elt_data->field_var_str[i]);
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
  3. kernel/trace/trace_events_hist.c:1898:3: warning: 1st function call argument is an uninitialized value [core.CallAndMessage]
                  destroy_hist_field(hist_field->operands[i], level + 1);
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  4. kernel/trace/trace_events_hist.c:2095:2: warning: 1st function call argument is an uninitialized value [core.CallAndMessage]
          kfree(ref_field->system);
          ^~~~~~~~~~~~~~~~~~~~~~~~
  5. kernel/trace/trace_events_hist.c:2099:2: warning: 1st function call argument is an uninitialized value [core.CallAndMessage]
          kfree(ref_field->name);
          ^~~~~~~~~~~~~~~~~~~~~~
  6. kernel/trace/trace_events_hist.c:2158:4: warning: Potential leak of memory pointed to by 'ref_field' [unix.Malloc]
                          return NULL;

Since I'm not very familiar with trace_events_hist.c, I roughly conclude that:
  1. warning 1/3/6 are plausible but false-positive;
  2. warning 2/4/5 seems positive although they don't cause practical problems because
elt_data->field_var_str[i] / ref_field->system / ref_field->name can be 'NULL'
on 'kfree'. Do we need to explicitly check 'NULL' there?
